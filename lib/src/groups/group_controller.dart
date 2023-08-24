import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/util/url_launcher.dart';

class GroupController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();
  final TimezoneService _tzService = Get.find<TimezoneService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  final AvailabilityController _availabilityController = Get.find<AvailabilityController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final RxList<String> selectedCategories = RxList<String>();

  final RxList<GroupModel> groups = RxList<GroupModel>();
  final RxList<GroupModel> userGroups = RxList<GroupModel>();
  final RxList<GroupModel> matchingGroups = RxList<GroupModel>();
  final RxList<GroupModel> filteredGroups = RxList<GroupModel>();
  final RxList<GroupModel> sameCategoryGroups = RxList<GroupModel>();

  final Rx<GroupModel> group = GroupModel.empty().obs;
  final isLoading = Rx<bool>(true);

  final Rx<TextEditingController> meetingTimeController = TextEditingController().obs;
  RxString? selectedCategory = ''.obs;
  RxString? selectedDay = ''.obs;

  final userGroupStatus = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchGroups();
    _fetchUserGroups();
    categoryController.fetchCategories();
    _fetchAvailableGroups();
    _listenToGroupChanges();
    filteredGroups.value = groups;
    _updateSameCategoryGroupsFromUserGoal();
  }

  @override
  void onClose() {
    super.onClose();
    _groupService.unsubscribeFromGroupChanges();
  }

  Future<void> createGroup() async {
    try {
      GroupModel groupCopy = group.value;
      groupCopy.meetingTimeUTC = _tzService.convertLocalTimeToUTC(group.value.meetingTimeUTC);

      UserModel user = _authService.getUser()!;
      GroupModel groupResponse = await _groupService.createGroup(groupCopy, user.tenantId);

      _analytics.track('GROUP_CREATED', properties: {
        'user': user.toJson(),
        'group': groupResponse.toJson(),
      });

      selectedCategory!.value = '';
      showSuccessSnackBar(message: 'The group has been created!');
    } catch (e, s) {
      Log().e("Error while creating group:", e, s);
      showErrorSnackBar(message: 'Error creating group, please try again');
    }
  }

  void joinGroup(String groupId) async {
    final UserModel? user = _authService.getUser();
    if (user == null) return;

    try {
      await _groupService.joinGroup(user, groupId);
      showSuccessSnackBar(message: 'Successfully joined group');

      final GroupModel joinedGroup = await _groupService.readGroup(groupId);
      userGroups.add(joinedGroup);
      userGroups.refresh();
      _fetchAvailableGroups(); // Refresh the matching groups

      _analytics.track('GROUP_JOINED', properties: {
        'user': user.toJson(),
        'group': joinedGroup.toJson(),
      });
    } catch (e, s) {
      Log().e("Error while joining group $groupId:", e, s, user.tenantId);
      showErrorSnackBar(message: 'Unable to join group: ${e.toString()}');
    }
    userGroupStatus[groupId]?.value = true;
  }

  void leaveGroup(String groupId) async {
    final UserModel? user = _authService.getUser();
    if (user == null) return;
    try {
      await _groupService.leaveGroup(user.id, groupId);
      showSuccessSnackBar(message: 'Successfully left group');

      userGroups.removeWhere((group) => group.id == groupId);

      userGroups.refresh();
      _fetchAvailableGroups(); // Refresh the matching groups
      _analytics.track('GROUP_LEFT', properties: {
        'user': user.toJson(),
        'groupId': groupId,
      });
    } catch (e, s) {
      Log().e("Error while leaving group $groupId:", e, s, user.tenantId);
      showErrorSnackBar(message: 'Unable to leave group: ${e.toString()}');
    }

    userGroupStatus[groupId]?.value = false;
  }

  bool isUserMemberOfGroup(String groupId) {
    return userGroupStatus.containsKey(groupId) ? userGroupStatus[groupId]!.value : false;
  }

  Future<GroupModel> fetchGroup(String groupId) async {
    try {
      final groupResponse = await _groupService.readGroup(groupId);
      return groupResponse;
    } catch (e) {
      showErrorSnackBar(message: 'Group not found');
      rethrow;
    }
  }

  Future<List<UserModel>> fetchGroupMembers(String groupId) async {
    try {
      return await _groupService.getGroupMembers(groupId);
    } catch (e) {
      showErrorSnackBar(message: 'Unable to fetch group members');
      return [];
    }
  }

  void filterGroupsByCategory(List<String> categories) {
    if (categories.isEmpty) {
      filteredGroups.value = groups;
    } else {
      filteredGroups.value = groups.where((group) => categories.contains(group.category)).toList();
    }
  }

  void _fetchGroups() async {
    isLoading(true);
    try {
      final response = await _groupService.readAllGroups(_authService.getUser()!.tenantId);
      if (response != null) {
        groups.value = response;
      }
    } catch (e) {
      showErrorSnackBar(message: 'Unable to fetch groups. Please try again');
    } finally {
      isLoading(false);
    }
  }

  void _fetchUserGroups() async {
    final UserModel? user = _authService.getUser();
    if (user == null) return;

    try {
      List<GroupModel> userGroupsList = await _groupService.getUserGroups(user);
      userGroups.value = userGroupsList;

      for (var group in userGroupsList) {
        userGroupStatus[group.id] = true.obs;
      }
    } catch (e) {
      showErrorSnackBar(message: 'Failed to get user groups');
    }
  }

  void _fetchAvailableGroups() async {
    final UserModel? user = _authService.getUser();
    if (user == null) return;

    try {
      final List<GoalModel> userGoals = await _goalService.readUserGoals(user.id);
      if (userGoals.isNotEmpty) {
        final String category = userGoals.first.category;
        List<GroupModel> allGroups = await _groupService.getGroupsByCategory(category, user.tenantId);
        final userGroups = await _groupService.getUserGroups(user);

        if (allGroups.isNotEmpty) {
          final availableGroups = allGroups.where((group) => !userGroups.any((userGroup) => userGroup.id == group.id)).toList();

          // Filter groups based on the availability match
          final matchingAvailableGroups = (await Future.wait(
            availableGroups.map((group) async => await _availabilityController.checkMatchingAvailability(user.id, group) ? group : null),
          ))
              .whereType<GroupModel>()
              .toList();

          // Filter out the groups the user is already a member of
          matchingAvailableGroups.removeWhere((group) => userGroupStatus[group.id]?.value ?? false);

          matchingGroups.value = matchingAvailableGroups;
          sameCategoryGroups.value = availableGroups;
        }
      }
    } catch (e, s) {
      Log().e("Error while fetching the available groups:", e, s);
      showErrorSnackBar(message: 'Failed to fetch available groups');
    }
  }

  void _updateSameCategoryGroupsFromUserGoal() async {
    UserModel? user = _authService.getUser();
    if (user == null) return;

    try {
      final List<GoalModel> userGoals = await _goalService.readUserGoals(user.id);
      if (userGoals.isNotEmpty) {
        sameCategoryGroups.value = groups.value.where((group) => group.category == userGoals[0].category && group.currentMembers < group.maxMembers).toList();
      }
    } catch (e, s) {
      Log().e("Error while updating same category groups from user goal:", e, s);
    }
  }

  void _listenToGroupChanges() {
    String tenantId = _authService.getUser()!.tenantId;
    _groupService.subscribeToGroupChanges(tenantId, (eventType, changedGroup) {
      switch (eventType) {
        case 'INSERT':
          Log().d("Debug: INSERT event received for group: ${changedGroup.id}");
          _handleInsertEvents(changedGroup);
          break;
        case 'UPDATE':
          Log().d("Debug: UPDATE event received for group: ${changedGroup.id}");
          _handleUpdateEvents(changedGroup);
          break;
        case 'DELETE':
          Log().d("Debug: DELETE event received for group: ${changedGroup.id}");
          _handleDeleteEvents(changedGroup);
          break;
        default:
          break;
      }
      userGroupStatus[changedGroup.id] = RxBool(isUserMemberOfGroup(changedGroup.id));
    });
  }

  void _handleDeleteEvents(GroupModel changedGroup) {
    for (var list in [groups, userGroups, matchingGroups, sameCategoryGroups]) {
      list.removeWhere((group) => group.id == changedGroup.id);
    }
  }

  void _handleUpdateEvents(GroupModel changedGroup) {
    for (var list in [groups, userGroups, matchingGroups, sameCategoryGroups]) {
      int index = list.indexWhere((group) => group.id == changedGroup.id);
      if (index != -1) {
        list[index] = changedGroup;
      }
    }
  }

  void _handleInsertEvents(GroupModel changedGroup) {
    groups.add(changedGroup);

    if (isUserMemberOfGroup(changedGroup.id)) {
      userGroups.add(changedGroup);
    }
    UserModel? user = _authService.getUser();
    if (user == null) return;

    _availabilityController.checkMatchingAvailability(user.id, changedGroup).then((matches) {
      if (matches) {
        matchingGroups.add(changedGroup);
      }
    });
    _fetchAvailableGroups();
  }

  Future<void> launchMeetingUrl(GroupModel group) async {
    try {
      await launchURL(group.meetingUrl);
    } catch (e) {
      print("Exception: $e");
      showErrorSnackBar(message: "Unable to launch ${group.meetingUrl}. Please contact the group admin.");
    }
  }
}
