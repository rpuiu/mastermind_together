import 'package:flutter/material.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/add_actions_widget.dart';
import 'package:mastermind_together/src/ui/widgets/custom_modal.dart';

class ActionsModal {
  final String goalId;

  ActionsModal({required this.goalId});

  static void show(BuildContext context, String goalId, ActionController actionController) {
    CustomModal.show(
      context: context,
      title: 'Actions',
      children: [
        AddActionsWidget(goalId: goalId, actionController: actionController),
      ],
      actions: [], // No specific actions/buttons needed as AddActionsWidget already has them.
    );
  }
}
