import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/add_action_modal_widget.dart';
import 'package:mastermind_together/src/goal/add_goal_modal.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/goal/goals_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/layout/custom_layout.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/add_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/reorder_button.dart';

class AllGoalsScreen extends GetView<GoalsController> {
  AllGoalsScreen({super.key});

  final GoalController _goalController = Get.find<GoalController>();

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      content: Column(
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
        AddBtn(onPressed: () => AddGoalModal.show(context, controller)),
      ],
    );
  }

  Widget _buildGoalList() {
    return Expanded(
      child: Obx(() {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: controller.goals.length,
          itemBuilder: (context, index) => _buildGoalTile(context, controller.goals[index], index),
          onReorder: (oldIndex, newIndex) => controller.reorderGoals(oldIndex, newIndex),
        );
      }),
    );
  }

  Widget _buildGoalTile(BuildContext context, GoalModel goal, int index) {
    final actionController = controller.actionControllers[goal.id];

    return KeyedSubtree(
      key: ValueKey(goal.id),
      child: Card(
        elevation: 2,
        child: ListTile(
          key: ValueKey(goal.id),
          tileColor: index == 0 ? activeMenuIconColor.withOpacity(0.6) : null,
          leading: ReorderBtn(index: controller.goals.indexOf(goal)),
          onTap: () async {
            await _goalController.fetchGoalDetails(goal.id);
            Get.toNamed(Routes.goalRoute(goal.id));
          },
          title: Text(goal.goal, style: bodySemiBold),
          subtitle: _buildActionExpansionTile(context, actionController!, goal.id),
          // Empty onLongPress callback is required for ReorderableListView
          onLongPress: () {},
        ),
      ),
    );
  }

  Widget _buildActionExpansionTile(BuildContext context, ActionController actionController, String goalId) {
    return Obx(
      () {
        if (actionController.actions.isNotEmpty) {
          return ExpansionTile(
              title: const Text("Actions", style: labelText),
              children: actionController.actions
                  .map((action) => ListTile(
                        title: Text(action.description, style: bodyRegular),
                      ))
                  .toList());
        }
        return Padding(
          padding: const EdgeInsets.only(top: fontSize),
          child: TextButton(
            onPressed: () {
              AddActionModalWidget.show(context, actionController, goalId);
            },
            child: Text('Add Action', style: linkTextStyle.copyWith(color: hoverMenuIconColor)),
          ),
        );
      },
    );
  }
}
