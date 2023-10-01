import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/availability/set_availability_widget.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/util/iframe.dart';

class SetAvailabilitySection extends StatelessWidget {
  const SetAvailabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 350,
          height: 200,
          child: const Iframe(
            src: 'https://embed.voomly.com/embed/assets/embed.html?videoId=1ZTW8VyCH&videoRatio=1.5139949109414759&type=f&skinColor=%23008EFF',
            width: 350,
            height: 200,
          ),
        ),
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
          onPressed: () async {
            await controller.updateOnboardingStatus(OnboardingStatus.done);
            controller.nextOnboardingStep.value = OnboardingStatus.groups;
          },
          label: "Confirm and Find Groups",
          labelTextStyle: buttonTextStyle,
          backgroundColor: buttonBackgroundColor,
        ),
      ],
    );
  }
}
