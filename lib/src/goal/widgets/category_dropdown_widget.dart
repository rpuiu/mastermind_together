import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class CategoryDropdown extends StatelessWidget {
  final GoalController controller;

  const CategoryDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.categoryController.categories.isNotEmpty
          ? CustomDropDown(
              label: "Category",
              hint: 'E.g. Fitness',
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
    );
  }
}
