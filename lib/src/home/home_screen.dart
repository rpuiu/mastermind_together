import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart'; // Import GoalController
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/goal/widgets/goal_action_button.dart';
import 'package:mastermind_together/src/goal/widgets/goal_input_field.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/home/sections/goals_section.dart';
import 'package:mastermind_together/src/home/sections/matching_groups_section.dart';
import 'package:mastermind_together/src/home/sections/my_groups_section.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/scrollable_custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

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
          // If the user has no goals
          if (goalController.goals.isEmpty) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 376),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(width: 156, height: 162, 'assets/images/home/target.png'),
                      const SizedBox(height: 3 * fontSize),
                      const Text("Create your first goal", style: headingText),
                      const SizedBox(height: fontSize),
                      const Text("So we can suggest groups that match your interest!", style: labelText),
                      const SizedBox(height: 2 * fontSize),
                      CategoryDropdown(controller: goalController),
                      const SizedBox(height: 1.5 * fontSize),
                      GoalInput(controller: goalInputController),
                      const SizedBox(height: 2 * fontSize),
                      GoalButton(
                        controller: goalController,
                        goalController: goalInputController,
                        formKey: formKey,
                        label: "Let's Go!",
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            // If the user has goals, display the regular content
            return Column(
              children: [
                const SizedBox(height: 4 * fontSize),
                const GoalsSection(),
                const SizedBox(height: 4 * fontSize),
                const MyGroupsSection(),
                const SizedBox(height: 4 * fontSize),
                MatchingGroupsSection(),
                const SizedBox(height: 4 * fontSize),
              ],
            );
          }
        },
      ),
    );
  }
}
