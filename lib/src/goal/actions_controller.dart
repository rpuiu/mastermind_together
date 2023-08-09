import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/action_model.dart';
import 'package:mastermind_together/src/services/supa/action_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class ActionController extends GetxController {
  final ActionService _actionService = Get.find<ActionService>();

  final RxList<ActionModel> actions = <ActionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchActionsForGoal(String goalId) async {
    try {
      actions.value = await _actionService.readActionsForGoal(goalId);
    } catch (e) {
      showErrorSnackBar(message: "Unable to fetch actions for the goal.");
    }
  }

  Future<void> createAction(String goalId, String description, String status) async {
    try {
      ActionModel createdAction = await _actionService.createAction(goalId, description, status);
      actions.add(createdAction);
    } catch (e) {
      showErrorSnackBar(message: "Unable to create action.");
    }
  }

  Future<void> updateActionStatus(String actionId, String newStatus) async {
    try {
      await _actionService.updateActionStatus(actionId, newStatus);
      int index = actions.indexWhere((action) => action.id == actionId);
      if (index != -1) {
        ActionStatus statusEnum = ActionStatus.values.firstWhere(
          (e) => e.toString().split('.').last == newStatus,
          orElse: () => ActionStatus.pending,
        );
        actions[index] = actions[index].copyWith(status: statusEnum);
      }
    } catch (e) {
      showErrorSnackBar(message: "Unable to update action status.");
    }
  }

  Future<void> deleteAction(String actionId) async {
    try {
      await _actionService.deleteAction(actionId);
      actions.removeWhere((action) => action.id == actionId);
    } catch (e) {
      showErrorSnackBar(message: "Unable to delete action.");
    }
  }

  void updateActionDescription(String goalId, String id, String newDescription) async {
    try {
      await _actionService.updateActionDescription(id, newDescription);
      fetchActionsForGoal(goalId);
    } catch (e) {
      showErrorSnackBar(message: 'Error updating category: $e');
    }
  }
}
