import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
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
              Get.toNamed(Routes.goal);
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
                          title: Text(goal.goal),
                          subtitle: Text(goal.goalArea),
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
                    if (groupController.userGroups.isEmpty) {
                      return Center(child: Text('No groups yet.')); // Center the text
                    } else {
                      return ListView.builder(
                        itemCount: groupController.userGroups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.userGroups[index];
                          return ListTile(
                            title: Text(group.name),
                            // More group properties...
                          );
                        },
                      );
                    }
                  }),
                ),
                Text("Matching Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(() {
                    if (groupController.matchingGroups.isEmpty) {
                      return Center(child: Text('No matching groups found.'));
                    } else {
                      return ListView.builder(
                        itemCount: groupController.matchingGroups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.matchingGroups[index];
                          return ListTile(
                            title: Text(group.name),
                            // More group properties...
                          );
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
