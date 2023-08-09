import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions_controller.dart';
import 'package:mastermind_together/src/goal/add_actions_widget.dart';

class GoalScreen extends GetView<ActionController> {
  final String goalId = Get.parameters['goalId']!;

  GoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('Goal Actions'),
      ),
      body: AddActionsScreen(goalId: goalId),
    );
  }
}
