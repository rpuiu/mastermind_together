import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/goal/widgets/goal_input_field.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/custom_modal.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class AddGoalModal {
  static void show(BuildContext context, GoalController goalController) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController textEditingController = TextEditingController();

    CustomModal.show(
      context: context,
      title: 'Add a Goal',
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              xHalfSpace,
              CategoryDropdown(
                selectedCategory: goalController.selectedCategory,
                onCategoryChanged: (String newValue) => goalController.selectedCategory!.value = newValue,
              ),
              xHalfSpace,
              GoalInput(controller: textEditingController),
              xHalfSpace,
            ],
          ),
        ),
      ],
      actions: [
        CustomButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              goalController.saveGoal(textEditingController.text);
              Get.back();
              showSuccessSnackBar(message: "Successfully added goal: \n ${textEditingController.text} ");
            }
          },
          label: 'Save Goal',
          labelTextStyle: buttonTextStyle,
          backgroundColor: buttonBackgroundColor,
        ),
      ],
    );
  }
}
