import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/goal/goals_controller.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalController extends GetxController {
  String? goalId;

  final GoalService _goalService = Get.find<GoalService>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final GoalsController goalsController = Get.find<GoalsController>();
  final isLoading = Rx<bool>(true);

  final Map<String, ActionController> actionControllers = <String, ActionController>{}.obs;
  final Rx<GoalModel?> goalDetails = Rx<GoalModel?>(null);

  @override
  void onReady() async {
    super.onReady();
    if (goalId != null) {
      await fetchGoalDetails(goalId!);
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    for (var actionController in actionControllers.values) {
      actionController.dispose();
    }
  }

  Future<void> fetchGoalDetails(String goalId) async {
    isLoading.value = true;
    goalDetails.value = await _goalService.getGoalDetails(goalId);
    isLoading.value = false;
  }

  Future<void> deleteGoal(String goalId) async {
    isLoading.value = true;
    try {
      await _goalService.deleteGoal(goalId);
      // todo oare e nevoie de asta????
      goalsController.removeGoal(goalId);
    } catch (e) {
      showErrorSnackBar(message: "Unable to delete goal");
    }
    isLoading.value = false;
  }
}
