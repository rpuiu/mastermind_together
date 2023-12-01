import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final UsersExtendedService _usersExtendedService = Get.find<UsersExtendedService>();
  final isLoading = Rx<bool>(false);

  RxString? selectedCategory = ''.obs;
  RxBool autoSelectGroup = false.obs;

  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final RxList<bool> expandedGoals = <bool>[].obs;
  final Map<String, ActionController> actionControllers = <String, ActionController>{}.obs;

  final RxMap<String, GoalModel> allUserGoals = <String, GoalModel>{}.obs;

  @override
  void onReady() async {
    super.onReady();
    _listenToCurrentUserGoalChanges();
    await categoryController.fetchCategories();
    await fetchUserGoals();
    isLoading.value = false;
    await fetchAllRankZeroGoals();
  }

  Future<void> fetchUserGoals() async {
    isLoading.value = true;

    final UserModel? user = _authService.getUser();
    if (user != null) {
      goals.value = await _goalService.readUserGoals(user.id);
      expandedGoals.addAll(List.filled(goals.length, false));
      for (var goal in goals) {
        actionControllers[goal.id] = ActionController(goal);
      }
    }
    isLoading.value = false;
  }

  void updateGoal(GoalModel goal) {
    int index = goals.value.indexWhere((goal) => goal.id == goal.id);
    goals.value[index] = goal;
  }

  void toggleGoalExpansion(int index) {
    expandedGoals[index] = !expandedGoals[index];
  }

  Future<void> saveGoal(String goal) async {
    isLoading.value = true;
    try {
      final UserModel? user = _authService.getUser();
      if (user != null) {
        int newRank = goals.length;
        GoalModel createdGoal = await _goalService.createGoal(
          user.id,
          goal,
          selectedCategory!.value,
          autoSelectGroup.value,
          user.tenantId,
          newRank,
        );
        _analytics.track('GOAL_CREATED', properties: {'user': user.toJson(), 'goal': createdGoal.toJson()});

        goals.add(createdGoal);
        actionControllers[createdGoal.id] = ActionController(createdGoal);
      }
    } catch (e) {
      showErrorSnackBar(message: "Unable to create goal");
    }
    isLoading.value = false;
  }

  void _listenToCurrentUserGoalChanges() {
    try {
      _goalService.subscribeToGoalChanges((newGoal) {
        final UserModel? user = _authService.getUser();
        if (user != null && newGoal.userId == user.id && !goals.any((g) => g.id == newGoal.id)) {
          goals.add(newGoal);
        }
      });
    } catch (e) {
      showErrorSnackBar(message: "Unable to listen to any goal changes.");
    }
  }

  void addGoal(GoalModel createdGoal) {
    goals.add(createdGoal);
  }

  void removeGoal(String goalId) {
    goals.removeWhere((goal) => goal.id == goalId);
  }

  int getRank() {
    return goals.length;
  }

  @override
  void onClose() {
    super.onClose();
    for (var actionController in actionControllers.values) {
      actionController.dispose();
    }
    _goalService.unsubscribeFromGoalChanges();
  }

  reorderGoals(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final GoalModel item = goals.removeAt(oldIndex);
    goals.insert(newIndex, item);
    _updateRanksAfterReorder();
  }

  Future<void> _updateRanksAfterReorder() async {
    for (int i = 0; i < goals.length; i++) {
      goals[i].rank = i;
      await _goalService.updateGoalRank(goals[i].id, i);
    }
  }

  Future<void> fetchAllRankZeroGoals() async {
    isLoading.value = true;
    try {
      final UserModel? user = _authService.getUser();
      List<GoalModel> allGoals = await _goalService.readAllGoalsOrderedByCreatedAt(user!.tenantId);
      await _associateUsernamesWithGoals(allGoals);
    } catch (e) {
      showErrorSnackBar(message: "Unable to fetch all rank 0 goals");
    }
    isLoading.value = false;
  }

  Future<void> _associateUsernamesWithGoals(List<GoalModel> goals) async {
    for (var goal in goals) {
      try {
        UserModel user = await readUserExtended(goal.userId);
        allUserGoals.putIfAbsent(user.username, () => goal);
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  Future<UserModel> readUserExtended(String userId) => _usersExtendedService.readUserExtended(userId);
}
