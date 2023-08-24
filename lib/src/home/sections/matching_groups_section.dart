import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/home/sections/group_cards_row.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class MatchingGroupsSection extends GetView<GroupController> {
  final GoalController goalController = Get.find<GoalController>();

  MatchingGroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Matching Groups", style: headingText),
        xHalfSpace,
        Obx(() {
          List<GroupModel> matchingGroups = controller.matchingGroups;
          List<GroupModel> sameCategoryGroups = controller.sameCategoryGroups;

          if (matchingGroups.isNotEmpty) {
            return GroupCardsRow(groups: matchingGroups);
          } else if (sameCategoryGroups.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Found groups related to your goal, but they don\'t align with your availability.',
                  style: bodyRegular,
                ),
                xSpace,
                ListTile(
                  leading: AppIcons.getIcon('calendar2', IconState.hoverState),
                  title: const Text('Update your availability to discover better matches.', style: bodyRegular),
                  onTap: () => Get.toNamed(Routes.availability),
                ),
                xxSpace,
                GroupCardsRow(groups: sameCategoryGroups),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Currently, no groups align with your goal.', style: bodyRegular),
                xSpace,
                const Text('Broaden your availability to explore more group options.', style: bodyRegular),
                ListTile(
                  leading: AppIcons.getIcon('calendar2', IconState.hoverState),
                  title: const Text('Update availability', style: bodyRegular),
                  onTap: () => Get.toNamed(Routes.availability),
                ),
                ListTile(
                  leading: AppIcons.getIcon('profile2user', IconState.hoverState),
                  title: const Text('Browse all groups', style: bodyRegular),
                  onTap: () => Get.toNamed(Routes.allGroups),
                ),
              ],
            );
          }
        }),
      ],
    );
  }
}
