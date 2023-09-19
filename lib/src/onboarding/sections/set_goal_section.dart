import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
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
    final GoalController goalController = Get.find<GoalController>();
    final OnboardingController controller = Get.find<OnboardingController>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: oneColContentWidth),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(width: 156, height: 162, 'assets/images/home/target.png'),
              const Iframe(
                src:
                'https://embed.voomly.com/embed/assets/embed.html?videoId=B4JMObpxH&videoRatio=1.8172588832487309&type=f&skinColor=%23008EFF',
                width: 560,
                height: 308,
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
                selectedCategory: goalController.selectedCategory,
                onCategoryChanged: (String newValue) => goalController.selectedCategory!.value = newValue,
              ),
              xxSpace,
              CustomButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await goalController.saveGoal(goalInputController.text);
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
        ),
      ),
    );
  }
}
