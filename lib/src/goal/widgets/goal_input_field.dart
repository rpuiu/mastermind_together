import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/info_tooltip.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class GoalInput extends StatelessWidget {
  final TextEditingController controller;

  const GoalInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      maxLength: characterMaxLength,
      label: "Goal",
      hintText: 'E.g. Complete a marathon by the end of July',
      icon: const InfoTooltip(
        title: 'What\'s a Goal?',
        content: 'Your goal is a specific objective you aim to achieve. Make it measurable and time-bound for best results.',
      ),
      maxLines: 3,
      validator: (value) => FormValidators.validateEmpty(value, 'Please enter a goal'),
    );
  }
}
