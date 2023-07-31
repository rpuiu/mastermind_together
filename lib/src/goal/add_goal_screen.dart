import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class AddGoalScreen extends GetView<GoalController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController goalController = TextEditingController();

  AddGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: goalController,
                    label: "Goal",
                    hintText: 'What is your goal?',
                    validator: FormValidators.validateGoal,
                  ),
                  const SizedBox(height: 2 * fontSize),
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
                            items: controller.categoryController.categories,
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 2 * fontSize),
                  // MAIN-T-44
                  // Obx(
                  //   () => CustomCheckboxListTile(
                  //     title: "Auto select group?",
                  //     tooltip: "If you select this you will automatically be assigned to a group based on your goal and availability",
                  //     value: controller.autoSelectGroup.value,
                  //     onChanged: (newValue) => controller.autoSelectGroup.value = newValue!,
                  //   ),
                  // ),
                  const SizedBox(height: 2 * fontSize),
                  CustomButton(
                    onPressed: () {
                      controller.saveGoal(goalController.text);
                      Get.back();
                    },
                    child: const Text('Save Goal'),
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
