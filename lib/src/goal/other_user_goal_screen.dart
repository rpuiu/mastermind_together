import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_chat_widget.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/ui/theme/layout/scrollable_layout.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/label_categ_widget.dart';

class OtherUserGoalScreen extends GetView<GoalController> {
  final String? goalId = Get.parameters['id'];
  final String? username = Get.parameters['username'];

  OtherUserGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (goalId == null) {
      return const Scaffold(body: Center(child: Text("Invalid goal ID")));
    }

    controller.goalId = goalId;
    return ScrollableCustomLayout(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          xHalfSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Goal Details", style: headingText),
              Row(
                children: [
                  const Icon(Icons.person, size: 24.0),
                  const SizedBox(width: 2),
                  Text(username!, style: bodyMedium),
                ],
              ),
            ],
          ),
          xHalfSpace,
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return _buildGoalDetails(controller.goalDetails.value!);
            }
          }),
          xxxSpace,
          GoalChatWidget(goalId: controller.goalId!),
          xxxSpace,
          // Add chat functionality here
        ],
      ),
    );
  }

  Widget _buildGoalDetails(GoalModel goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                goal.goal,
                style: subtitleTextStyle.copyWith(height: 1),
                softWrap: true,
              ),
            ),
            wXSpace,
            LabelCategoryWidget(label: goal.category),
          ],
        ),
        // Other details about the goal
      ],
    );
  }

  // Placeholder for action list
  Widget _buildActionList(GoalModel goal) {
    return const Text("Actions go here");
  }
}
