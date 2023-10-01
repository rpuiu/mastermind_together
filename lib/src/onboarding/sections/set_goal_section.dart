import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/goal/goals_controller.dart';
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/goal/widgets/goal_input_field.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/util/iframe.dart';

class SetGoalSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController goalInputController;

  const SetGoalSection({super.key, required this.formKey, required this.goalInputController});

  @override
  Widget build(BuildContext context) {
    final GoalsController goalsController = Get.find<GoalsController>();
    final OnboardingController controller = Get.find<OnboardingController>();

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 350,
            height: 200,
            child: const Iframe(
              src: 'https://embed.voomly.com/embed/assets/embed.html?videoId=B4JMObpxH&videoRatio=1.8172588832487309&type=f&skinColor=%23008EFF',
              width: 350,
              height: 200,
            ),
          ),
          xxSpace,
          const Text("Step 1/3", style: labelText),
          xSpace,
          Text(
            "What Life-Changing Goal Are You Pursuing?",
            style: welcomeTextStyle,
            textAlign: TextAlign.center,
          ),
          xSpace,
          GoalInput(controller: goalInputController),
          xxSpace,
          CategoryDropdown(
            selectedCategory: goalsController.selectedCategory,
            onCategoryChanged: (String newValue) => goalsController.selectedCategory!.value = newValue,
          ),
          xxSpace,
          CustomButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await goalsController.saveGoal(goalInputController.text);
                await controller.updateOnboardingStatus(OnboardingStatus.goals);
                controller.nextOnboardingStep.value = OnboardingStatus.availability;
              }
            },
            label: "Set My Goal!",
            labelTextStyle: buttonTextStyle,
            backgroundColor: buttonBackgroundColor,
          ),
        ],
      ),
    );
  }
}
