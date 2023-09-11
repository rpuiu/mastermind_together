import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/all_groups_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GroupOperationsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final TimezoneService _tzService = Get.find<TimezoneService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final UserGroupService _groupService = Get.find<UserGroupService>();

  final AllGroupsController allGroupsController = Get.find<AllGroupsController>();
  final MembersController _membersController = Get.find<MembersController>();

  final Rx<GroupModel> groupToCreate = GroupModel.empty().obs;
  final Rx<TextEditingController> meetingTimeController = TextEditingController().obs;

  RxString? selectedCategory = ''.obs;
  RxString? selectedDay = ''.obs;
  final RxBool isLoading = false.obs;

  Future<void> createGroup() async {
    try {
      UserModel user = _authService.getUser()!;

      GroupModel groupCopy = groupToCreate.value;
      groupCopy.meetingTimeUTC = _tzService.convertLocalTimeToUTC(groupToCreate.value.meetingTimeUTC);
      groupCopy.createdBy = user.id;
      groupCopy.admin = user.id;

      GroupModel groupResponse = await _groupService.createGroup(groupCopy, user);

      await joinGroup(groupResponse.id);

      _analytics.track('GROUP_CREATED', properties: {
        'user': user.toJson(),
        'group': groupResponse.toJson(),
      });

      selectedCategory!.value = '';

      Get.toNamed(Routes.groupRoute(groupResponse.id));
    } catch (e, s) {
      Log().e("Error while creating group:", e, s);
      showErrorSnackBar(message: 'Error creating group, please try again');
    }
  }

  Future<void> joinGroup(String groupId, {Function? onJoined}) async {
    isLoading.value = true;

    final UserModel? user = _authService.getUser();
    if (user == null) return;

    try {
      final GroupModel joinedGroup = await _groupService.joinGroup(user, groupId);
      _membersController.groupIdToMembershipStatus[groupId] = true.obs;

      showSuccessSnackBar(message: 'Successfully joined group');

      allGroupsController.userGroups.add(joinedGroup);
      allGroupsController.userGroups.refresh();
      await allGroupsController.fetchAvailableGroups(); // Refresh the matching groups

      _analytics.track('GROUP_JOINED', properties: {
        'user': user.toJson(),
        'group': joinedGroup.toJson(),
      });

      if (onJoined != null) onJoined();
    } catch (e, s) {
      Log().e("Error while joining group $groupId:", e, s, user.tenantId);
      showErrorSnackBar(message: 'Unable to join group: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void leaveGroup(String groupId) async {
    final UserModel? user = _authService.getUser();
    if (user == null) return;
    try {
      await _groupService.leaveGroup(user.id, groupId);
      showSuccessSnackBar(message: 'Successfully left group');

      allGroupsController.userGroups.removeWhere((group) => group.id == groupId);

      allGroupsController.userGroups.refresh();
      allGroupsController.fetchAvailableGroups(); // Refresh the matching groups
      _analytics.track('GROUP_LEFT', properties: {
        'user': user.toJson(),
        'groupId': groupId,
      });
    } catch (e, s) {
      Log().e("Error while leaving group $groupId:", e, s, user.tenantId);
      showErrorSnackBar(message: 'Unable to leave group: ${e.toString()}');
    }

    _membersController.groupIdToMembershipStatus[groupId]?.value = false;
  }
}
