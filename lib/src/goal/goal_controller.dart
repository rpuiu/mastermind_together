import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/dbops/supa/auth_service.dart';
import 'package:mastermind_together/src/dbops/supa/category_service.dart';
import 'package:mastermind_together/src/dbops/supa/goal_service.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  final RxList<String> categories = <String>[].obs;

  RxString? selectedCategory = 'Please select...'.obs;
  RxBool autoSelectGroup = false.obs;

  final RxList<Goal> goals = <Goal>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGoals();
    listenToGoalChanges();
    fetchCategories();
  }

  void fetchUserGoals() async {
    final User user = _authService.getCurrentUser();
    goals.value = await _goalService.readUserGoals(user.id);
  }

  Future<void> saveGoal(String goal) async {
    final User user = _authService.getCurrentUser();

    await _goalService.createGoal(user.id, goal, selectedCategory!.value, autoSelectGroup.value);
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

  void fetchCategories() async {
    try {
      final allCategories = await _categoryService.getAllCategories();
      categories.assignAll(['Please select...']);
      categories.addAll(allCategories.map((c) => c.name));
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle error as needed.
    }
  }
}
