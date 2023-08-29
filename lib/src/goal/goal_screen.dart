import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/add_actions_widget.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/scrollable_custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/label_categ_widget.dart';

class GoalScreen extends GetView<GoalController> {
  final String goalId = Get.parameters['goalId']!;

  GoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchGoalDetails(goalId);
    return ScrollableCustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          xHalfSpace,
          const Text("Goal", style: headingText),
          xHalfSpace,
          Obx(() {
            final goal = controller.goalDetails.value;
            if (goal != null) {
              return _buildGoalDetails(goal);
            } else {
              return const CircularProgressIndicator();
            }
          }),
          xxxSpace,
          const Text("Actions", style: headingText),
          xSpace,
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: AddActionsWidget(
              goalId: goalId,
              actionController: ActionController(goalId),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalDetails(GoalModel goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(goal.goal, style: subtitleTextStyle.copyWith(height: 1)), //TODO edit goal
        xxSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelCategoryWidget(label: goal.category),
            Text('Status: ${goal.status}', style: bodyMedium), //TODO change status
            Text(
              'Due Date: ${goal.dueDate != null ? goal.dueDate!.toLocal() : 'Set Date'}', //TODO set due date
              style: bodyRegular,
            ),
          ],
        ),
      ],
    );
  }
}
