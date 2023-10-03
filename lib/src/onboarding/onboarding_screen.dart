import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/onboarding/sections/groups_section.dart';
import 'package:mastermind_together/src/onboarding/sections/set_availability_section.dart';
import 'package:mastermind_together/src/onboarding/sections/set_goal_section.dart';
import 'package:mastermind_together/src/ui/theme/layout/responsive_padding_wrapper.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  final GoalController goalController = Get.find<GoalController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController goalInputController = TextEditingController();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double adaptiveMaxWidth = getAdaptiveMaxWidth(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: ResponsivePaddingWrapper(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: adaptiveMaxWidth),
              child: Obx(
                () {
                  switch (controller.nextOnboardingStep.value) {
                    case OnboardingStatus.goals:
                      return SetGoalSection(formKey: formKey, goalInputController: goalInputController);
                    case OnboardingStatus.availability:
                      return const SetAvailabilitySection();
                    case OnboardingStatus.groups:
                      return const GroupsSection();
                    case OnboardingStatus.done:
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getAdaptiveMaxWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 800.0; // For large screens
    } else if (screenWidth > 800) {
      return 600.0; // For medium screens
    } else {
      return 376.0; // Default value
    }
  }
}
