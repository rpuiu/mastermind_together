import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/categories/category_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';

class GoalController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GoalService _goalService = Get.find<GoalService>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  RxString? selectedCategory=''.obs;
  RxBool autoSelectGroup = false.obs;

  final RxList<GoalModel> goals = <GoalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGoals();
    _listenToCurrentUserGoalChanges();
    categoryController.fetchCategories();
  }

  void fetchUserGoals() async {
    final UserModel? user = _authService.getUser();
    if (user != null) {
      goals.value = await _goalService.readUserGoals(user.id);
    }
  }

  Future<void> saveGoal(String goal) async {
    try {
      final UserModel? user = _authService.getUser();
      if (user != null) {
        GoalModel createdGoal = await _goalService.createGoal(user.id, goal, selectedCategory!.value, autoSelectGroup.value, user.tenantId);
        _analytics.track('GOAL_CREATED', properties: {'user': user.toJson(), 'goal': createdGoal.toJson()});

        Get.toNamed(Routes.home);
      }
    } catch (e) {
      showErrorSnackBar(message: "Unable to create goal");
    }
  }

  void _listenToCurrentUserGoalChanges() {
    try {
      _goalService.subscribeToGoalChanges((newGoal) {
        final UserModel? user = _authService.getUser();
        if (user != null && newGoal.userId == user.id) {
          goals.add(newGoal);
        }
      });
    } catch (e) {
      showErrorSnackBar(message: "Unable to listen to any goal changes.");
    }
  }

  @override
  void onClose() {
    super.onClose();
    _goalService.unsubscribeFromGoalChanges();
  }
}
