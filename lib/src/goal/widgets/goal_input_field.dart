import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class GoalInput extends StatelessWidget {
  final TextEditingController controller;

  const GoalInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      maxLength: 280,
      label: "Goal",
      hintText: 'E.g. Go for a 6 km run 3x per week after work',
      maxLines: 3,
      validator: (value) => FormValidators.validateEmpty(value, 'Please enter a goal'),
    );
  }
}
