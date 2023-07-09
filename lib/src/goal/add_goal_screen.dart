import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';

class AddGoalScreen extends GetView<GoalController> {
  final TextEditingController goalController = TextEditingController();

  AddGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Goal'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: goalController,
                    decoration: InputDecoration(
                      labelText: 'What is your goal?',
                    ),
                  ),
                  SizedBox(height: 20), // adds some spacing
                  Obx(() => DropdownButton<String>(
                        value: controller.selectedCategory!.value,
                        onChanged: (String? newValue) {
                          controller.selectedCategory!.value = newValue!;
                        },
                        items: controller.categoryController.categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),

                  SizedBox(height: 20), // adds some spacing
                  Obx(() => CheckboxListTile(
                        title: Text("Auto select group?"),
                        value: controller.autoSelectGroup.value,
                        onChanged: (newValue) {
                          controller.autoSelectGroup.value = newValue!;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      )),

                  SizedBox(height: 20), // adds some spacing
                  ElevatedButton(
                    onPressed: () {
                      controller.saveGoal(goalController.text);
                      Get.back();
                    },
                    child: Text('Save Goal'),
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
