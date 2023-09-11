import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/util/url_launcher.dart';

class GroupScreenController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();

  final String groupId;

  final Rx<GroupModel> group = GroupModel.empty().obs;

  final RxList<UserModel> members = List<UserModel>.empty().obs;

  final RxBool isLoading = RxBool(true);

  GroupScreenController({required this.groupId});

  @override
  void onInit() {
    super.onInit();
    _fetchGroupDetails(groupId).then((_) {
      isLoading(false);
    });
  }

  Future<void> updateGroupName(String id, String newName) async {
    try {
      group.value = await _groupService.updateGroupName(id, newName);
      showSuccessSnackBar(message: 'Group name updated successfully.');
    } catch (e, s) {
      Log().e("Error while updating group name:", e, s);
      showErrorSnackBar(message: 'Error updating group name, please try again.');
    }
  }

  Future<void> updateMeetingDetails(String id, String newDay, TimeOfDay newTime) async {
    try {
      group.value = await _groupService.updateMeetingDetails(id, newDay, newTime);
      showSuccessSnackBar(message: 'Meeting details updated successfully.');
    } catch (e, s) {
      Log().e("Error while updating meeting details:", e, s);
      showErrorSnackBar(message: 'Error updating meeting details, please try again.');
    }
  }

  Future<void> updateMeetingUrl(String id, String newMeetingUrl) async {
    try {
      group.value = await _groupService.updateMeetingUrl(id, newMeetingUrl);
      showSuccessSnackBar(message: 'Meeting URL updated successfully.');
    } catch (e, s) {
      Log().e("Error while updating meeting URL:", e, s);
      showErrorSnackBar(message: 'Error updating meeting URL, please try again.');
    }
  }

  Future<void> updateGroupLocation(String id, String newLocation) async {
    try {
      group.value = await _groupService.updateGroupLocation(id, newLocation);
      showSuccessSnackBar(message: 'Group location updated successfully.');
    } catch (e, s) {
      Log().e("Error while updating group location:", e, s);
      showErrorSnackBar(message: 'Error updating group location, please try again.');
    }
  }

  updateGroupDescription(String id, String newDescription) async {
    try {
      group.value = await _groupService.updateGroupDescription(id, newDescription);
      showSuccessSnackBar(message: 'Group description updated successfully.');
    } catch (e, s) {
      Log().e("Error while updating group description:", e, s);
      showErrorSnackBar(message: 'Error updating group description, please try again.');
    }
  }

  Future<void> launchMeetingUrl(GroupModel group) async {
    try {
      await launchURL(group.meetingUrl);
    } catch (e) {
      showErrorSnackBar(message: "Unable to launch ${group.meetingUrl}. Please contact the group admin.");
    }
  }

  Future<void> _fetchGroupDetails(String groupId) async {
    group.value = await _fetchGroup(groupId);
    members.value = await _fetchGroupMembers(groupId);
  }

  Future<GroupModel> _fetchGroup(String groupId) async {
    try {
      final groupResponse = await _groupService.readGroup(groupId);
      return groupResponse;
    } catch (e) {
      showErrorSnackBar(message: 'Group not found');
      rethrow;
    }
  }

  Future<List<UserModel>> _fetchGroupMembers(String groupId) async {
    try {
      return await _groupService.getGroupMembers(groupId);
    } catch (e) {
      showErrorSnackBar(message: 'Unable to fetch group members');
      return [];
    }
  }
}
