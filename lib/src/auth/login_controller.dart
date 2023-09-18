import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UsersExtendedService _ueService = Get.find<UsersExtendedService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      UserModel user = await _authService.signInWithPassword(email, password);
      _analytics.identify(user.id);
      _analytics.track('USER_AUTHENTICATED', properties: {'user': '${user.toJson()}'});

      await _redirect(user.id);
    } on AuthException catch (e) {
      if (e.message == 'Invalid login credentials') {
        showErrorSnackBar(message: "Invalid credentials. Please try again");
      }
      isLoading.value = false;
    } catch (e) {
      showErrorSnackBar(message: "Error while authenticating [$email]. Please try again or contact us for support.");
      await _authService.signOut(); // on sign-in failure, sign out the user
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _analytics.track('USER_LOGGED_OUT');
      showSuccessSnackBar(message: 'Logged out successfully');
    } catch (e) {
      showErrorSnackBar(message: "Error while logging out. Please try again or contact us for support");
    }
  }

  Future<void> _redirect(String userId) async {
    String? originalRoute = _localStorage.getOriginalRoute();

    if (originalRoute != null) {
      Get.offAllNamed(originalRoute);
      _localStorage.clearOriginalRoute(); // Clear the original route after using it
    } else {
      if (_authService.isTenant()) {
        Get.offAllNamed(Routes.tenantDashboard);
      } else {
        OnboardingStatus onboardingStatus = await _ueService.readOnboardingStatus(userId);
        if (OnboardingStatus.done == onboardingStatus) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.onboarding);
        }
      }
    }
  }
}
