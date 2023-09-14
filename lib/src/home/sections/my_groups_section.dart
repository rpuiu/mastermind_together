import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/all_groups_controller.dart';
import 'package:mastermind_together/src/home/sections/group_cards_row.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class MyGroupsSection extends GetView<AllGroupsController> {
  const MyGroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Groups", style: headingText),
          xHalfSpace,
          Obx(() {
            if (controller.userGroups.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You aren\'t part of any groups yet. Here\'s what you can do:',
                    style: bodyRegular,
                  ),
                  xSpace,
                  ListTile(
                    leading: AppIcons.getIcon('profile2user', IconState.hoverState),
                    title: const Text('Join a group to start your accountability journey.', style: bodyRegular),
                    onTap: () => Get.toNamed(Routes.allGroups),
                  ),
                  ListTile(
                    leading: AppIcons.getIcon('add', IconState.hoverState),
                    title: const Text('Create your own group.', style: bodyRegular),
                    onTap: () => Get.toNamed(Routes.createGroup),
                  ),
                ],
              );
            } else {
              return GroupCardsRow(groups: controller.userGroups);
            }
          }),
        ],
      ),
    );
  }
}
