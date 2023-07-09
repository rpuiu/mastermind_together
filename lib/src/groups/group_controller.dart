import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
import 'package:mastermind_together/src/goal/category_model.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/category_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final CategoryService _categoryService = Get.find<CategoryService>();
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();
  final TimezoneService _tzService = Get.find<TimezoneService>();

  final AvailabilityController _availabilityController = Get.find<AvailabilityController>();

  final RxList<GroupModel> groups = RxList<GroupModel>();
  final RxList<GroupModel> userGroups = RxList<GroupModel>();
  final RxList<GroupModel> matchingGroups = RxList<GroupModel>();

  final Rx<GroupModel> group = GroupModel.empty().obs;
  final isLoading = Rx<bool>(true);

  final meetingTimeController = TextEditingController(text: "Please select...").obs;
  RxList<String> categories = <String>[].obs;
  RxString? selectedCategory = 'Please select...'.obs; //TODO
  RxString? selectedDay = 'Please select...'.obs; //TODO?

  final userGroupStatus = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchGroups();
    _fetchUserGroups();
    _fetchCategories();
    _fetchAvailableGroups();
    _listenToGroupChanges();
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

      await _groupService.createGroup(groupCopy);

      showSuccessSnackBar(message: 'The group has been created!');
    } catch (e, s) {
      print('$e: $s');
      showErrorSnackBar(message: 'Error creating group, please try again');
    }
  }

  void joinGroup(String groupId) async {
    final User user = _authService.getCurrentUser();
    try {
      await _groupService.joinGroup(user.id, groupId);
      showSuccessSnackBar(message: 'Successfully joined group');

      final GroupModel joinedGroup = await _groupService.readGroup(groupId);
      userGroups.add(joinedGroup);
      userGroups.refresh();
      _fetchAvailableGroups(); // Refresh the matching groups
    } catch (e, s) {
      print('$e $s');
      showErrorSnackBar(message: 'Unable to join group due to: ${e.toString()}');
    }
    userGroupStatus[groupId]?.value = true;
  }

  void leaveGroup(String groupId) async {
    final User user = _authService.getCurrentUser();
    try {
      await _groupService.leaveGroup(user.id, groupId);
      showSuccessSnackBar(message: 'Successfully left group');

      userGroups.removeWhere((group) => group.id == groupId);

      userGroups.refresh();
      _fetchAvailableGroups(); // Refresh the matching groups
    } catch (e, s) {
      print('$e $s');
      showErrorSnackBar(message: 'Unable to leave group due to: ${e.toString()}');
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
    } catch (e, s) {
      showErrorSnackBar(message: 'Group not found');
      rethrow;
    }
  }

  Future<List<UserModel>> fetchGroupMembers(String groupId) async {
    try {
      return await _groupService.getGroupMembers(groupId);
    } catch (e, s) {
      showErrorSnackBar(message: 'Unable to fetch group members');
      return [];
    }
  }

  void _fetchGroups() async {
    isLoading(true);
    try {
      final response = await _groupService.readAllGroups();
      if (response != null) {
        groups.value = response;
      }
    } catch (e, s) {
      showErrorSnackBar(message: 'Unable to fetch groups. Please try again');
    } finally {
      isLoading(false);
    }
  }

  void _fetchUserGroups() async {
    final User user = _authService.getCurrentUser();
    try {
      List<GroupModel> userGroupsList = await _groupService.getUserGroups(user.id);
      userGroups.value = userGroupsList;

      for (var group in userGroupsList) {
        userGroupStatus[group.id] = true.obs;
      }
    } catch (e, s) {
      showErrorSnackBar(message: 'Failed to get user groups');
    }
  }

  void _fetchAvailableGroups() async {
    final User user = _authService.getCurrentUser();

    try {
      final List<GoalModel> userGoals = await _goalService.readUserGoals(user.id);
      if (userGoals.isNotEmpty) {
        final String category = userGoals.first.category; //TODO Only first goal gets taken into account
        List<GroupModel> allGroups = await _groupService.getGroupsByCategory(category);
        final userGroups = await _groupService.getUserGroups(user.id);

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
        }
      }
    } catch (e, s) {
      print('$e $s');
      showErrorSnackBar(message: 'Failed to fetch available groups');
    }
  }

  void _fetchCategories() async {
    try {
      List<CategoryModel> allCategories = await _categoryService.getAllCategories();
      categories.assignAll(['Please select...']);
      categories.addAll(allCategories.map((c) => c.name));
    } catch (e, s) {
      showErrorSnackBar(message: 'Error fetching goal areas: $e');
    }
  }

  void _listenToGroupChanges() {
    _groupService.subscribeToGroupChanges((eventType, changedGroup) {
      switch (eventType) {
        case 'INSERT':
          print("Debug: INSERT event received for group: ${changedGroup.id}");
          _handleInsertEvents(changedGroup);
          break;
        case 'UPDATE':
          print("Debug: UPDATE event received for group: ${changedGroup.id}");
          _handleUpdateEvents(changedGroup);
          break;
        case 'DELETE':
          print("Debug: DELETE event received for group: ${changedGroup.id}");
          _handleDeleteEvents(changedGroup);
          break;
        default:
          break;
      }
      userGroupStatus[changedGroup.id] = RxBool(isUserMemberOfGroup(changedGroup.id));
    });
  }

  void _handleDeleteEvents(GroupModel changedGroup) {
    for (var list in [groups, userGroups, matchingGroups]) {
      list.removeWhere((group) => group.id == changedGroup.id);
    }
  }

  void _handleUpdateEvents(GroupModel changedGroup) {
    for (var list in [groups, userGroups, matchingGroups]) {
      int index = list.indexWhere((group) => group.id == changedGroup.id);
      if (index != -1) {
        list[index] = changedGroup;
        print("Debug: Group updated in the list");
      }
    }
  }

  void _handleInsertEvents(GroupModel changedGroup) {
    groups.add(changedGroup);

    if (isUserMemberOfGroup(changedGroup.id)) {
      userGroups.add(changedGroup);
    }
    _availabilityController.checkMatchingAvailability(_authService.getCurrentUser().id, changedGroup).then((matches) {
      if (matches) {
        matchingGroups.add(changedGroup);
      }
    });
  }
}
