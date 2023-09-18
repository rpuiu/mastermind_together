import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';

class OnboardingController extends GetxController {
  final UsersExtendedService _ueService = Get.find<UsersExtendedService>();
  final AuthService _authService = Get.find<AuthService>();

  Rx<OnboardingStatus> nextOnboardingStep = OnboardingStatus.none.obs;

  Future<OnboardingStatus> getOnboardingStatus() async {
    final String userId = _authService.getUser()!.id;
    return await _ueService.readOnboardingStatus(userId);
  }

  Future<void> updateOnboardingStatus(OnboardingStatus newOnboardingStatus) async {
    final String userId = _authService.getUser()!.id;
    return await _ueService.updateOnboardingStatus(userId, newOnboardingStatus);
  }

  @override
  void onReady() async {
    OnboardingStatus onboardingStatus = await getOnboardingStatus();
    if (OnboardingStatus.done != onboardingStatus) {
      nextOnboardingStep.value = OnboardingStatus.values[onboardingStatus.index + 1];
    } else {
      nextOnboardingStep.value = onboardingStatus;
    }
    super.onReady();
  }

  @override
  void dispose() {}
}
