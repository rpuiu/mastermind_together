import 'package:flutter/material.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class GoalButton extends StatelessWidget {
  final GoalController controller;
  final TextEditingController goalController;
  final GlobalKey<FormState> formKey;
  final String label;

  const GoalButton({
    super.key,
    required this.controller,
    required this.goalController,
    required this.formKey,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          controller.saveGoal(goalController.text);
        }
      },
      label: label,
      labelTextStyle: buttonTextStyle,
      backgroundColor: buttonBackgroundColor,
    );
  }
}
