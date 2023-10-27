import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';

class MembersController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserGroupService _userGroupService = Get.find<UserGroupService>();

  final Map<String, RxBool> groupIdToMembershipStatus = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserGroupStatus();
  }

  Future<void> _initializeUserGroupStatus() async {
    UserModel currentUser = _authService.getUser()!;
    final userGroups = await _userGroupService.getUserGroups(currentUser);
    for (var group in userGroups) {
      groupIdToMembershipStatus[group.id] = true.obs;
    }
  }

  bool isUserAdmin(GroupModel targetGroup) {
    final UserModel? currentUser = _authService.getUser();
    if (currentUser == null) return false;
    return targetGroup.admin == currentUser.id;
  }

  bool isUserMemberOfGroup(String groupId) {
    return groupIdToMembershipStatus[groupId]?.value ?? false;
  }

  String getCurrentUserTimezone(){
   return _authService.getUser()!.timezone;
  }
}
