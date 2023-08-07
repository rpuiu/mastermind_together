import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/goal_card.dart';

class HomeScreen extends GetView<HomeController> {
  final AuthController authController = Get.find<AuthController>();
  final GoalController goalController = Get.find<GoalController>();
  final GroupController groupController = Get.find<GroupController>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: CustomDrawer(),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text("My Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(
                    () => goalController.goals.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10), // Spacer
                                const Text('You haven\'t set any goals yet.'),
                                CustomButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.createGoal);
                                  },
                                  child: const Text('Set a Goal'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: goalController.goals.length,
                            itemBuilder: (_, index) {
                              final goal = goalController.goals[index];
                              return GoalCard(goal: goal, index: index);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                const Text("My Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(() {
                    if (groupController.userGroups.isEmpty) {
                      return const Center(child: Text('No groups yet.'));
                    } else {
                      return ListView.builder(
                        itemCount: groupController.userGroups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.userGroups[index];
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
                    } else if (groupController.matchingGroups.isEmpty) {
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
                          groupController.sameCategoryGroups.isEmpty
                              ? Container()
                              : const Text("Available groups in the same category:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: ListView.builder(
                              itemCount: groupController.sameCategoryGroups.length,
                              itemBuilder: (context, index) {
                                final group = groupController.sameCategoryGroups[index];
                                return GroupCard(group: group);
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        itemCount: groupController.matchingGroups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.matchingGroups[index];
                          return GroupCard(group: group);
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
