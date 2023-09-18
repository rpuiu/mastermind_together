import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/sections/matching_groups_section.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

import '../../auth/user_model.dart';

class GroupsSection extends StatelessWidget {
  const GroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: oneColContentWidth),
        child: Column(
          children: [
            Image.asset(width: 206, height: 212, 'assets/images/onboarding/onboard-3.png'),
            xxSpace,
            const Text("Step 3/3", style: labelText),
            xSpace,
            Text(
              "Ready to Join an Accountability Circle?",
              style: welcomeTextStyle,
              textAlign: TextAlign.center,
            ),
            xxSpace,
            MatchingGroupsSection(),
            xxSpace,
            CustomButton(
              onPressed: () {
                Get.offAndToNamed(Routes.home);
              },
              label: "Continue to Dashboard",
              labelTextStyle: buttonTextStyle,
              backgroundColor: buttonBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
