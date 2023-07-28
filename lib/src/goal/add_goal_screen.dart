import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/checkbox/checkbox_list_tile.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/text_field.dart';

class AddGoalScreen extends GetView<GoalController> {
  final TextEditingController goalController = TextEditingController();

  AddGoalScreen({super.key});

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
                  CustomTextField(controller: goalController, label: "Goal", hintText: 'What is your goal?'),
                  const SizedBox(height: 2 * fontSize),
                  Obx(
                    () => CustomDropDown(
                      label: "Category",
                      selectedValue: controller.selectedCategory!.value,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedCategory!.value = newValue;
                        }
                      },
                      items: controller.categoryController.categories,
                    ),
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
