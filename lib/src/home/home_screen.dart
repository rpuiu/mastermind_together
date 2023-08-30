import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart'; // Import GoalController
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/goal/widgets/goal_input_field.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/home/sections/goals_section.dart';
import 'package:mastermind_together/src/home/sections/matching_groups_section.dart';
import 'package:mastermind_together/src/home/sections/my_groups_section.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/scrollable_custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class HomeScreen extends GetView<HomeController> {
  final GoalController goalController = Get.find<GoalController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController goalInputController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableCustomScaffold(
      body: Obx(
        () {
          if (goalController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // If the user has no goals
          if (goalController.goals.isEmpty) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: oneColContentWidth),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(width: 156, height: 162, 'assets/images/home/target.png'),
                      xxxSpace,
                      const Text("Create your first goal", style: headingText),
                      xSpace,
                      const Text("So we can suggest groups that match your interest!", style: labelText),
                      xxSpace,
                      CategoryDropdown(
                        selectedCategory: goalController.selectedCategory,
                        onCategoryChanged: (String newValue) => goalController.selectedCategory!.value = newValue,
                      ),
                      xHalfSpace,
                      GoalInput(controller: goalInputController),
                      xxSpace,
                      CustomButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            goalController.saveGoal(goalInputController.text);
                          }
                        },
                        label: "Let's Go!",
                        labelTextStyle: buttonTextStyle,
                        backgroundColor: buttonBackgroundColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // If the user has goals, display the regular content
            return Column(
              children: [
                xxxxSpace,
                const GoalsSection(),
                xxxxSpace,
                const MyGroupsSection(),
                xxxxSpace,
                MatchingGroupsSection(),
                xxxxSpace,
              ],
            );
          }
        },
      ),
    );
  }
}
