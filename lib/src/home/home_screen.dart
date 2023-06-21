import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/routes.dart';

class HomeScreen extends GetView<HomeController> {
  final AuthController authController = Get.find();
  final GoalController goalController = Get.find();

  HomeScreen({super.key});

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
            icon: Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Obx(
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
    );
  }
}
