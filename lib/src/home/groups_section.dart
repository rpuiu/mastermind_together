import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

class GroupsSection extends GetView<GroupController> {
  final GoalController goalController = Get.find<GoalController>();

  GroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text("My Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Obx(() {
              if (controller.userGroups.isEmpty) {
                return const Center(child: Text('No groups yet.'));
              } else {
                return ListView.builder(
                  itemCount: controller.userGroups.length,
                  itemBuilder: (context, index) {
                    final group = controller.userGroups[index];
                    return GroupCard(group: group);
                  },
                );
              }
            }),
          ),
          const Text("Matching Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Obx(() {
              List<GoalModel> userGoals = goalController.goals.value;
              if (userGoals.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Please set a goal in order to view matching groups.'),
                    CustomButton(
                      onPressed: () {
                        Get.toNamed(Routes.createGoal);
                      },
                      child: const Text('Set a Goal'),
                    ),
                  ],
                );
              } else if (controller.matchingGroups.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No matching groups found.'),
                    CustomButton(
                      onPressed: () {
                        Get.toNamed(Routes.createGroup);
                      },
                      child: const Text('Create new group'),
                    ),
                    const SizedBox(height: 10),
                    controller.sameCategoryGroups.isEmpty
                        ? Container()
                        : const Text("Available groups in the same category:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.sameCategoryGroups.length,
                        itemBuilder: (context, index) {
                          final group = controller.sameCategoryGroups[index];
                          return GroupCard(group: group);
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: controller.matchingGroups.length,
                  itemBuilder: (context, index) {
                    final group = controller.matchingGroups[index];
                    return GroupCard(group: group);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
