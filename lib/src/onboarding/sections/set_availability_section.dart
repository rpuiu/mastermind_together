import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/set_availability_widget.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class SetAvailabilitySection extends StatelessWidget {
  const SetAvailabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: oneColContentWidth),
        child: Column(
          children: [
            Image.asset(width: 156, height: 162, 'assets/images/onboarding/onboard-2-nobg.png'),
            xxSpace,
            const Text("Step 2/3", style: labelText),
            xSpace,
            Text(
              "Set Your Availability for Accountability Groups",
              style: welcomeTextStyle,
              textAlign: TextAlign.center,
            ),
            xxSpace,
            const Text(
              "Choose your timezone and select times when you're free for group calls.",
              style: labelText,
            ),
            xHalfSpace,
            const SetAvailabilityWidget(),
            xxSpace,
            CustomButton(
              onPressed: () {
                controller.onboardingStep.value = OnboardingStep.noGroups;
              },
              label: "Confirm and Find Groups",
              labelTextStyle: buttonTextStyle,
              backgroundColor: buttonBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
