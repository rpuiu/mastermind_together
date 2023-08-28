import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/action_model.dart';
import 'package:mastermind_together/src/services/supa/action_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class ActionController extends GetxController {
  final String goalId;

  final ActionService _actionService = Get.find<ActionService>();

  final RxList<ActionModel> actions = <ActionModel>[].obs;

  ActionController(this.goalId) {
    fetchActionsForGoal();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void fetchActionsForGoal() async {
    try {
      actions.value = await _actionService.readActionsForGoal(goalId);
    } catch (e) {
      showErrorSnackBar(message: "Unable to fetch actions for the goal.");
    }
  }

  Future<void> createAction(String goalId, String description, String status) async {
    try {
      int newRank = actions.length;
      ActionModel createdAction = await _actionService.createAction(goalId, description, status, newRank);
      actions.add(createdAction);
    } catch (e) {
      showErrorSnackBar(message: "Unable to create action.");
    }
  }

  Future<void> updateRanksAfterReorder() async {
    for (int i = 0; i < actions.length; i++) {
      actions[i] = actions[i].copyWith(rank: i);
      await _actionService.updateActionRank(actions[i].id, i);
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

  void updateActionDescription(String id, String newDescription) async {
    try {
      await _actionService.updateActionDescription(id, newDescription);
      fetchActionsForGoal();
    } catch (e) {
      showErrorSnackBar(message: 'Error updating category: $e');
    }
  }

  void updateListWithActionDescription(String id, String description) {
    var tempActions = List<ActionModel>.from(actions);
    var index = tempActions.indexWhere((action) => action.id == id);
    if (index != -1) {
      tempActions[index] = tempActions[index].copyWith(description: description);
      actions.assignAll(tempActions);
    }
  }
}
