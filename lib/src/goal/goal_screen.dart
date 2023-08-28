import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/add_actions_widget.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';

class GoalScreen extends StatelessWidget {
  final String goalId = Get.parameters['goalId']!;

  GoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: AddActionsWidget(
          goalId: goalId,
          actionController: ActionController(goalId),
        ),
      ),
    );
  }
}
