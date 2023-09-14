import 'package:get/get.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';

enum OnboardingStep {
  noGoal,
  noAvailability,
  noGroups,
  done,
}

class OnboardingController extends GetxController {
  static final OnboardingController _singleton = OnboardingController._internal();

  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  Rx<OnboardingStep> onboardingStep = OnboardingStep.noGoal.obs;

  factory OnboardingController() {
    return _singleton;
  }

  OnboardingController._internal();

  @override
  void onInit() {
    super.onInit();
    final savedStep = _localStorage.getOnboardingStep();
    if (savedStep != null) {
      onboardingStep.value = savedStep;
    }

    ever(onboardingStep, (currentStep) {
      _localStorage.setOnboardingStep(currentStep);
    });
  }
}
