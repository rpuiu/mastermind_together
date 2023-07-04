import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/goal/category_model.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/category_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final CategoryService _categoryService = Get.find<CategoryService>();
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();
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

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    fetchUserGroups();
    fetchCategories();
    fetchAvailableGroups();
  }

  // void listenToGoalChanges() { //TODO
  //   _groupService.subscribeToGroupChanges((newGoal) => groups.add(newGoal));
  // }

  Future<void> createGroup() async {
    try {
      await _groupService.createGroup(group.value);
      Get.snackbar(
        'Group Created',
        'The group has been successfully created!',
        snackPosition: SnackPosition.BOTTOM,
      );
      update();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error creating group',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void fetchGroups() async {
    isLoading(true);
    try {
      final response = await _groupService.readAllGroups();
      if (response != null) {
        groups.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchCategories() async {
    try {
      List<CategoryModel> allCategories = await _categoryService.getAllCategories();
      categories.assignAll(['Please select...']);
      categories.addAll(allCategories.map((c) => c.name));
    } catch (e) {
      print('Error fetching goal areas: $e');
      // Handle error as needed.
    }
  }

  void joinGroup(String groupId) async {
    final User user = _authService.getCurrentUser();
    try {
      await _groupService.joinGroup(user.id, groupId);
      Get.snackbar(
        'Success',
        'Successfully joined group',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error joining group',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void leaveGroup(String groupId) async {
    final User user = _authService.getCurrentUser();
    try {
      await _groupService.leaveGroup(user.id, groupId);
      Get.snackbar(
        'Success',
        'Successfully left group',
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchGroups(); // Fetch groups again to reflect changes in UI //TODO replace with realtime
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error leaving group',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<GroupModel> fetchGroup(String groupId) async {
    final groupResponse = await _groupService.readGroup(groupId);
    if (groupResponse != null) {
      return groupResponse;
    } else {
      throw Exception('Group not found.');
    }
  }

  Future<List<UserModel>> getGroupMembers(String groupId) async {
    try {
      return await _groupService.getGroupMembers(groupId);
    } catch (e) {
      print(e);
      return [];
    }
  }

  void fetchUserGroups() async {
    final User user = _authService.getCurrentUser();
    try {
      userGroups.value = await _groupService.getUserGroups(user.id);
    } catch (e) {
      print('Error fetching user groups: $e');
    }
  }

  void fetchAvailableGroups() async {
    final User user = _authService.getCurrentUser();

    try {
      final List<GoalModel> userGoals = await _goalService.readUserGoals(user.id);
      if (userGoals.isNotEmpty) {
        final String category = userGoals.first.category; //TODO Only first goal gets taken into account
        List<GroupModel> allGroups = await _groupService.getGroupsByCategory(category);
        final userGroups = await _groupService.getUserGroups(user.id);

        if (allGroups.isNotEmpty) {
          final availableGroups = allGroups
              .where(
                (group) => !userGroups.any((userGroup) => userGroup.id == group.id),
              )
              .toList();

          // Filter groups based on the availability match
          final matchingAvailableGroups = (await Future.wait(
            availableGroups.map((group) async => await _availabilityController.checkMatchingAvailability(user.id, group) ? group : null),
          ))
              .whereType<GroupModel>()
              .toList();

          matchingGroups.value = matchingAvailableGroups;
        }
      }
    } catch (e) {
      print('Error fetching available groups: $e');
    }
  }

  bool isUserMemberOfGroup(String groupId) {
    try {
      return userGroups.value.any((group) => group.id == groupId);
    } catch (e) {
      print('Error determining if user is a member of the group: $e');
      return false;
    }
  }
}
