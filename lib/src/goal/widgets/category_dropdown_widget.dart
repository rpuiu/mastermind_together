import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class CategoryDropdown extends StatelessWidget {
  final RxString? selectedCategory;
  final CategoryController categoryController = Get.find<CategoryController>();
  final Function(String) onCategoryChanged;

  CategoryDropdown({super.key, required this.selectedCategory, required this.onCategoryChanged});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => categoryController.categories.isNotEmpty
          ? CustomDropDown(
              label: "Category",
              hint: 'E.g. Fitness',
              selectedValue: selectedCategory?.value,
              onChanged: (String? newValue) {
                if (newValue != null && selectedCategory != null) {
                  selectedCategory!.value = newValue;
                  onCategoryChanged(newValue);
                }
              },
              items: categoryController.categoryNames,
              validator: (value) => FormValidators.validateEmpty(value, 'Please select a category'),
            )
          : Container(),
    );
  }
}
