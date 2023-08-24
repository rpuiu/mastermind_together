import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/add_goal_modal.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/add_button.dart';

class AllGoalsScreen extends GetView<GoalController> {
  const AllGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: <Widget>[
          xHalfSpace,
          _buildHeader(context),
          xHalfSpace,
          _buildGoalList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("All Goals", style: headingText),
        wHalfSpace,
        AddButton(onPressed: () => AddGoalModal.show(context)),
      ],
    );
  }

  Widget _buildGoalList() {
    return Expanded(
      child: Obx(() {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: controller.goals.length,
          itemBuilder: (context, index) {
            return _buildGoalTile(context, controller.goals[index]);
          },
          onReorder: _handleReorder,
        );
      }),
    );
  }

  ListTile _buildGoalTile(BuildContext context, GoalModel goal) {
    final actionController = controller.actionControllers[goal.id];
    return ListTile(
      key: ValueKey(goal.id),
      leading: ReorderableDragStartListener(
        index: controller.goals.indexOf(goal),
        child: const Icon(Icons.drag_handle),
      ),
      onTap: () => Get.toNamed(Routes.goalRoute(goal.id)),
      title: Text(goal.goal, style: bodySemiBold),
      subtitle: Obx(() => _buildActionExpansionTile(actionController!)),
      // Empty onLongPress callback is required for ReorderableListView
      onLongPress: () {},
    );
  }

  ExpansionTile _buildActionExpansionTile(ActionController actionController) {
    return ExpansionTile(
      title: const Text("Actions", style: labelText),
      children: _buildActionList(actionController),
    );
  }

  List<Widget> _buildActionList(ActionController actionController) {
    return actionController.actions.map((action) => ListTile(title: Text(action.description, style: bodyRegular))).toList();
  }

  void _handleReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final GoalModel item = controller.goals.removeAt(oldIndex);
    controller.goals.insert(newIndex, item);
  }
}
