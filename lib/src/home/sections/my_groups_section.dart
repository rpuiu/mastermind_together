import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/home/sections/group_cards_row.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class MyGroupsSection extends GetView<GroupController> {
  const MyGroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("My Groups", style: headingText),
        const SizedBox(height: 1.5 * fontSize),
        Obx(() {
          if (controller.userGroups.isEmpty) {
            return const Center(child: Text('No groups yet.'));
          } else {
            return GroupCardsRow(groups: controller.userGroups);
          }
        }),
      ],
    );
  }
}
