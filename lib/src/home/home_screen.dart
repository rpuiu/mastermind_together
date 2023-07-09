import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/routes.dart';

class HomeScreen extends GetView<HomeController> {
  final AuthController authController = Get.find<AuthController>();
  final GoalController goalController = Get.find<GoalController>();
  final GroupController groupController = Get.find<GroupController>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.toNamed(Routes.createGoal);
            },
          ),
          IconButton(
            icon: Icon(Icons.groups),
            onPressed: () {
              Get.toNamed(Routes.allGroups);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: authController.logout,
          ),
          IconButton(
            icon: Icon(Icons.event_available),
            onPressed: () {
              Get.toNamed(Routes.availability);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("My Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: goalController.goals.length,
                      itemBuilder: (_, index) {
                        final goal = goalController.goals[index];
                        return ListTile(
                          title: Text(
                            '$index: ${goal.goal}',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Category: ${goal.category}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                Text("My Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(() {
                    print("Debug: Obx called for rebuilding ListView");
                    if (groupController.userGroups.isEmpty) {
                      return Center(child: Text('No groups yet.')); // Center the text
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
                Text("Matching Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(() {
                    List<GoalModel> userGoals = goalController.goals.value;
                    // Check if userGoal is null or empty
                    if (userGoals.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Please set a goal in order to view matching groups.'),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the create goal screen
                              Get.toNamed(Routes.createGoal);
                            },
                            child: Text('Set a Goal'),
                          ),
                        ],
                      );
                    } else if (groupController.matchingGroups.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No matching groups found.'),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the create group screen
                              Get.toNamed(Routes.createGroup);
                            },
                            child: Text('Create new group'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the same category groups screen
                              Get.toNamed(Routes.allGroups); //TODO all groups with filter.
                            },
                            child: Text('View groups in the same category'),
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
