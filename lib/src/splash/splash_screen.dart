import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:mastermind_together/src/routes.dart'; // Import your routes

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController onboardingController = Get.find<OnboardingController>();

    //TODO??? add login fix Initialize the delay navigation
    _delayNavigation(context, onboardingController);

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> _delayNavigation(BuildContext context, OnboardingController onboardingController) async {
    await Future.delayed(const Duration(seconds: 2));

    if (onboardingController.onboardingStep.value == OnboardingStep.done) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }
}
