import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/set_availability_widget.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/goal/widgets/goal_input_field.dart';
import 'package:mastermind_together/src/home/sections/matching_groups_section.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/onboarding/sections/groups_section.dart';
import 'package:mastermind_together/src/onboarding/sections/set_availability_section.dart';
import 'package:mastermind_together/src/onboarding/sections/set_goal_section.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/responsive_padding_wrapper.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  final GoalController goalController = Get.find<GoalController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController goalInputController = TextEditingController();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ResponsivePaddingWrapper(
          child: Obx(
            () {
              switch (controller.onboardingStep.value) {
                case OnboardingStep.noGoal:
                  return SetGoalSection(formKey: formKey, goalInputController: goalInputController);
                case OnboardingStep.noAvailability:
                  return const SetAvailabilitySection();
                case OnboardingStep.noGroups:
                  return const GroupsSection();
                case OnboardingStep.done:
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}




