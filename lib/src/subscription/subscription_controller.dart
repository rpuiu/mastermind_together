import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/subscription_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';

class SubscriptionController extends GetxController {
  final SubscriptionService _subscriptionService = Get.find<SubscriptionService>();
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final AuthService _authService = Get.find<AuthService>();
  final UserGroupService _userGroupService = Get.find<UserGroupService>();

  Future<bool> canUserCreateGroup() async {
    try {
      UserModel user = _authService.getUser()!;
      String userId = user.id;

      final int? groupCreationLimit = await _subscriptionService.getGroupCreationLimit(userId, user.subscriptionId);
      final int currentGroupCount = await _groupService.getUserCreatedGroupCount(userId);

      if (groupCreationLimit != null && currentGroupCount >= groupCreationLimit) {
        return false;
      }
      return true;
    } catch (e) {
      Log().e("Error while checking group creation limit:", e);
      return false;
    }
  }

  Future<bool> canUserJoinGroup() async {
    UserModel user = _authService.getUser()!;
    String userId = user.id;

    final int? groupJoiningLimit = await _subscriptionService.getGroupJoiningLimit(userId, user.subscriptionId);
    final int currentJoinedGroupCount = await _userGroupService.getUserJoinedGroupCount(userId);

    if (groupJoiningLimit != null && currentJoinedGroupCount >= groupJoiningLimit) {
      return false;
    }
    return true;
  }
}
