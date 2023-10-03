import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_card.dart';
import 'package:mastermind_together/src/goal/goals_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class GoalsSection extends GetView<GoalsController> {
  const GoalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text("Ready for an awesome day?", style: headingText),
          ),
          const SizedBox(
            height: 2 * fontSize,
          ),
          Expanded(
            child: Obx(
              () {
                final goal = controller.goals.isNotEmpty ? controller.goals[0] : null;
                return goal != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: fontSize / 2),
                        child: GoalCard(goal: goal, index: 0),
                      )
                    : const Center(child: Text('No goals available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
