import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/add_goal_modal.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/home/sections/group_cards_row.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class MatchingGroupsSection extends GetView<GroupController> {
  final GoalController goalController = Get.find<GoalController>();

  MatchingGroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Matching Groups", style: headingText),
        const SizedBox(height: 1.5 * fontSize),
        Obx(() {
          List<GoalModel> userGoals = goalController.goals.value;
          if (userGoals.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Please set a goal in order to view matching groups.'),
                CustomButton(
                  onPressed: () {
                    AddGoalModal.show(context);
                  },
                  label: 'Set a Goal',
                  labelTextStyle: buttonTextStyle,
                  backgroundColor: buttonBackgroundColor,
                ),
              ],
            );
          } else {
            List<GroupModel> matchingGroups = controller.matchingGroups;
            List<GroupModel> displayGroups = matchingGroups.isEmpty ? controller.sameCategoryGroups : matchingGroups;
            return GroupCardsRow(groups: displayGroups);
          }
        }),
      ],
    );
  }
}
