import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class AllGroupsController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();

  final AvailabilityController _availabilityController = Get.find<AvailabilityController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final MembersController _membersController = Get.find<MembersController>();

  final RxList<String> selectedCategories = RxList<String>();
  final RxBool isMatchingGroupsSelected = false.obs;
  final RxBool isRelatedGroupsSelected = false.obs;

  final RxList<GroupModel> groups = RxList<GroupModel>();
  final RxList<GroupModel> userGroups = RxList<GroupModel>();
  final RxList<GroupModel> matchingGroups = RxList<GroupModel>();
  final RxList<GroupModel> filteredGroups = RxList<GroupModel>();
  final RxList<GroupModel> sameCategoryGroups = RxList<GroupModel>();

  final isLoading = Rx<bool>(false);

  @override
  void onInit() async {
    super.onInit();
    await categoryController.fetchCategories();
    _listenToGroupChanges();
    filteredGroups.value = groups;
    ever(_availabilityController.availabilityChanged, (_) async => await fetchAvailableGroups());
  }

  @override
  void onReady() async {
    super.onReady();
    isLoading.value = true;
    await _fetchGroups();
    await _fetchUserGroups();
    await fetchAvailableGroups();
    await _updateSameCategoryGroupsFromUserGoal();
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    _groupService.unsubscribeFromGroupChanges();
  }

  void filterGroupsByCategory(List<String> categories) {
    if (categories.isEmpty) {
      filteredGroups.value = groups;
    } else {
      filteredGroups.value = groups.where((group) => categories.contains(group.category)).toList();
    }
  }

  Future<void> _fetchGroups() async {
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

  Future<void> _fetchUserGroups() async {
    final UserModel? user = _authService.getUser();
    if (user == null) return;

    try {
      List<GroupModel> userGroupsList = await _groupService.getUserGroups(user);
      userGroups.value = userGroupsList;
    } catch (e) {
      showErrorSnackBar(message: 'Failed to get user groups');
    }
  }

  Future<void> fetchAvailableGroups() async {
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
          matchingAvailableGroups.removeWhere((group) => _membersController.groupIdToMembershipStatus[group.id]?.value ?? false);

          matchingGroups.value = matchingAvailableGroups;
          sameCategoryGroups.value = availableGroups;
        }
      }
    } catch (e, s) {
      Log().e("Error while fetching the available groups:", e, s);
      showErrorSnackBar(message: 'Failed to fetch available groups');
    }
  }

  Future<void> _updateSameCategoryGroupsFromUserGoal() async {
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
    _groupService.subscribeToGroupChanges(tenantId, (eventType, changedGroup) async {
      switch (eventType) {
        case 'INSERT':
          Log().d("Debug: INSERT event received for group: ${changedGroup.id}");
          await _handleInsertEvents(changedGroup);
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
      _membersController.groupIdToMembershipStatus[changedGroup.id] = RxBool(_membersController
          .isUserMemberOfGroup(changedGroup.id)); //makes sure that your userGroupStatus state is always up-to-date with the latest changes from the server.
    });
  }

  void _updateListsBasedOnGroup(GroupModel changedGroup, Function(GroupModel, int, RxList<GroupModel>) operation) {
    for (var list in [groups, userGroups, matchingGroups, sameCategoryGroups]) {
      final index = list.indexWhere((group) => group.id == changedGroup.id);
      operation(changedGroup, index, list);
    }
  }

  void _handleUpdateEvents(GroupModel changedGroup) {
    _updateListsBasedOnGroup(changedGroup, (changedGroup, index, list) {
      if (index != -1) {
        list[index] = changedGroup;
      }
    });
  }

  void _handleDeleteEvents(GroupModel changedGroup) {
    _updateListsBasedOnGroup(changedGroup, (changedGroup, index, list) {
      list.removeWhere((group) => group.id == changedGroup.id);
    });
  }

  Future<void> _handleInsertEvents(GroupModel changedGroup) async {
    groups.add(changedGroup);

    if (_membersController.isUserMemberOfGroup(changedGroup.id)) {
      userGroups.add(changedGroup);
    }
    UserModel? user = _authService.getUser();
    if (user == null) return;

    _availabilityController.checkMatchingAvailability(user.id, changedGroup).then((matches) {
      if (matches) {
        matchingGroups.add(changedGroup);
      }
    });
    await fetchAvailableGroups();
  }

  void toggleMatchingGroupsSelected() {
    isMatchingGroupsSelected.value = !isMatchingGroupsSelected.value;
  }

  void toggleRelatedGroupsSelected() {
    isRelatedGroupsSelected.value = !isRelatedGroupsSelected.value;
  }

  void filterMatchingGroups() {
    if (isMatchingGroupsSelected.value) {
      filteredGroups.value = matchingGroups;
    } else {
      filterGroupsByCategory(selectedCategories);
    }
  }

  void filterRelatedGroups() {
    if (isRelatedGroupsSelected.value) {
      filteredGroups.value = sameCategoryGroups;
    } else {
      filterGroupsByCategory(selectedCategories);
    }
  }
}
