import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/dbops/supa/auth_service.dart';
import 'package:mastermind_together/src/dbops/supa/goal_service.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();

  // This is just a placeholder. You might want to fetch these from your database.
  final List<String> goalAreas = ['Please select...', 'Health', 'Career', 'Education', 'Others'];

  RxString? selectedArea = 'Please select...'.obs;
  RxBool autoSelectGroup = false.obs;

  final RxList<Goal> goals = <Goal>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGoals();
    listenToGoalChanges();
  }

  void fetchUserGoals() async {
    final User user = _authService.getCurrentUser();
    goals.value = await _goalService.readUserGoals(user.id);
  }

  Future<void> saveGoal(String goal) async {
    final User user = _authService.getCurrentUser();

    await _goalService.createGoal(user.id, goal, selectedArea!.value, autoSelectGroup.value);
    Get.toNamed(Routes.home);
  }

  void listenToGoalChanges() {
    _goalService.subscribeToGoalChanges((newGoal) => goals.add(newGoal));
  }

  @override
  void onClose() {
    super.onClose();
    _goalService.unsubscribeFromGoalChanges();
  }
}
