import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  String getTenantId() {
    String? tenantIdParam = Get.parameters['tenantId'];
    String tenantId;
    if (tenantIdParam == ":tenantId" || tenantIdParam == null) {
      tenantId = dotenv.env['MMT_TENANT_ID']!;
    } else {
      tenantId = tenantIdParam;
    }
    return tenantId;
  }

  Future<void> register(String username, String email, String password) async {
    try {
      UserModel user = await _authService.signUp(getTenantId(), username, email, password);
      _analytics.track('USER_REGISTERED', properties: {'user': '${user.toJson()}'});
      _analytics.setUserProperties(user.id, "\$email", user.email);
      _analytics.setUserProperties(user.id, "\$name", user.username);

      showSuccessSnackBar(message: 'Congratulations, your account has been successfully created');
      Get.offAllNamed(Routes.login);
    } on AuthException catch (e) {
      showErrorSnackBar(message: "Registration failed: ${e.message}");
    } catch (e) {
      showErrorSnackBar(message: "Registration failed with an unexpected error, please try again or contact us for support");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserModel user = await _authService.signInWithPassword(email, password);
      _analytics.identify(user.id);
      _analytics.track('USER_AUTHENTICATED', properties: {'user': '${user.toJson()}'});
      _redirect();
    } on AuthException catch (e) {
      if (e.message == 'Invalid login credentials') {
        showErrorSnackBar(message: "Invalid credentials. Please try again");
      }
    } catch (e) {
      showErrorSnackBar(message: "Error while authenticating [$email]. Please try again or contact us for support.");
      await _authService.signOut(); // on sign-in failure, sign out the user
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

  void _redirect() {
    String? originalRoute = _localStorage.getOriginalRoute();

    if (originalRoute != null) {
      Get.offAllNamed(originalRoute);
      _localStorage.clearOriginalRoute(); // Clear the original route after using it
    } else {
      if (_authService.isTenant()) {
        Get.offAllNamed(Routes.tenantDashboard);
      } else {
        if (_localStorage.isOnboardingComplete()) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.onboarding);
        }
      }
    }
  }
}
