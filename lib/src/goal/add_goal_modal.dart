import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.5 * fontSize),
              child: AddGoalModal(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(1.5 * fontSize),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add a Goal', style: bodySemiBold),
                const SizedBox(height: 1.5 * fontSize),
                Obx(
                  () => controller.categoryController.categories.isNotEmpty
                      ? CustomDropDown(
                          label: "Category",
                          selectedValue: controller.selectedCategory?.value,
                          onChanged: (String? newValue) {
                            if (newValue != null && controller.selectedCategory != null) {
                              controller.selectedCategory!.value = newValue;
                            }
                          },
                          items: controller.categoryController.categoryNames,
                          validator: (value) => FormValidators.validateEmpty(value, 'Please select a category'),
                        )
                      : Container(),
                ),
                const SizedBox(height: 1.5 * fontSize),
                CustomTextFormField(
                  controller: goalController,
                  maxLength: 280,
                  label: "Goal",
                  hintText: 'What is your goal?',
                  validator: (value) => FormValidators.validateEmpty(value, 'Please enter a goal'),
                ),
                const SizedBox(height: 1.5 * fontSize),
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.saveGoal(goalController.text);
                      Get.back();
                    }
                  },
                  child: const Text('Save Goal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
