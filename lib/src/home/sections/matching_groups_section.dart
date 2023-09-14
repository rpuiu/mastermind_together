import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/groups/all_groups_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/widgets/horizontal_groups_list.dart';
import 'package:mastermind_together/src/home/sections/group_cards_row.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class MatchingGroupsSection extends GetView<AllGroupsController> {
  final GoalController goalController = Get.find<GoalController>();

  MatchingGroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          List<GroupModel> matchingGroups = controller.matchingGroups;
          List<GroupModel> sameCategoryGroups = controller.sameCategoryGroups;

          if (matchingGroups.isNotEmpty) {
            return _buildMatchingGroups(matchingGroups, sameCategoryGroups);
          } else if (sameCategoryGroups.isNotEmpty) {
            return _buildRelatedGroups(sameCategoryGroups);
          } else {
            return _buildNoGroups();
          }
        }),
      ],
    );
  }

  Column _buildNoGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('We couldn\'t find any matching or related groups at the moment, but you have other options:', style: bodyRegular),
        xSpace,
        _buildListTile('Create Your Own Group', 'Start fresh and set your own meeting times.', 'add', Routes.createGroup),
        _buildListTile('Update availability', 'Broaden your availability to explore more group options.', 'calendar2', Routes.availability),
        _buildListTile('Explore All Groups', 'Find groups that may interest you.', 'profile2user', Routes.allGroups),
        _buildListTile('Check Back Later', 'New groups form regularly. Keep an eye out for a fit.', 'close', Routes.home)
      ],
    );
  }

  Column _buildRelatedGroups(List<GroupModel> sameCategoryGroups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore matching and related groups to boost your journey toward your goal',
          style: bodyRegular,
        ),
        xxxSpace,
        HorizontalGroupList(
          groups: sameCategoryGroups,
          heading: 'Related Groups',
          subHeading: 'Groups that align with your goal but meet outside your available times.',
        ),
        xxSpace,
        const Text(
          'Other Options',
          style: headingText,
        ),
        xSpace,
        _buildListTile('Update availability', 'Broaden your availability to explore more group options.', 'calendar2', Routes.availability),
        _buildListTile('Create Your Own Group', 'Start fresh and set your own meeting times.', 'add', Routes.createGroup),
        _buildListTile('Explore All Groups', 'Find groups that may interest you.', 'profile2user', Routes.allGroups),
      ],
    );
  }

  Column _buildMatchingGroups(List<GroupModel> matchingGroups, List<GroupModel> relatedGroups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        xxxSpace,
        const Text("Matching Groups", style: headingText),
        halfSpace,
        const Text("Groups that align with your goal and fit your availability.", style: bodyRegular),
        xxSpace,
        GroupCardsRow(groups: matchingGroups),
        xxSpace,
      //   if (relatedGroups.isNotEmpty) ...[
      //     xxSpace,
      //     HorizontalGroupList(
      //       groups: relatedGroups,
      //       heading: 'Related Groups',
      //       subHeading: 'Groups that align with your goal but meet outside your available times.',
      //     ),
      //   ],
      //   xxSpace,
      //   const Text(
      //     'Other Options',
      //     style: headingText,
      //   ),
      //   xSpace,
      //   _buildListTile('Update availability', 'Broaden your availability to explore more group options.', 'calendar2', Routes.availability),
      //   _buildListTile('Create Your Own Group', 'Start fresh and set your own meeting times.', 'add', Routes.createGroup),
      //   _buildListTile('Explore All Groups', 'Find groups that may interest you.', 'profile2user', Routes.allGroups),
      ],
    );
  }

  Widget _buildListTile(String title, String subtitle, String icon, String route) {
    return ListTile(
      leading: AppIcons.getIcon(icon, IconState.hoverState),
      title: Text(title, style: bodyRegular),
      subtitle: Text(subtitle, style: labelText),
      onTap: () => Get.toNamed(route),
    );
  }
}
