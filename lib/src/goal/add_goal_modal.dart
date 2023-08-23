import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/goal/widgets/goal_action_button.dart';
import 'package:mastermind_together/src/goal/widgets/goal_input_field.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class AddGoalModal extends GetView<GoalController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController goalController = TextEditingController();

  AddGoalModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5 * fontSize),
            child: AddGoalModal(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(1.5 * fontSize),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add a Goal', style: bodySemiBold),
                  const SizedBox(height: 1.5 * fontSize),
                  CategoryDropdown(controller: controller),
                  const SizedBox(height: 1.5 * fontSize),
                  GoalInput(controller: goalController),
                  const SizedBox(height: 1.5 * fontSize),
                  GoalButton(
                    controller: controller,
                    goalController: goalController,
                    formKey: formKey,
                    label: 'Save Goal',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
