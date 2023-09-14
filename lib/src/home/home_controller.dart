import 'package:get/get.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart'; // Import OnboardingController

class HomeController extends GetxController {
  final OnboardingController onboardingController = Get.find<OnboardingController>();
  Rx<OnboardingStep> onboardingStep = OnboardingStep.noGoal.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to the changes in onboardingStep of OnboardingController
    ever(onboardingController.onboardingStep, (dynamic _) {
      onboardingStep.value = onboardingController.onboardingStep.value;
    });
  }
}
