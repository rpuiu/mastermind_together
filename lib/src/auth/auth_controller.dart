import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  Future<void> register(String username, String email, String password) async {
    try {
      UserModel user = await _authService.signUp(username, email, password);
      _analytics.track('USER_REGISTERED', properties: {'user': '${user.toJson()}'});
      _analytics.setUserProperties(user.id, "\$email", user.email);
      _analytics.setUserProperties(user.id, "\$name", user.username);

      showSuccessSnackBar(message: 'Congratulations, your account has been successfully created');
      Get.offAllNamed(Routes.login);
    } on AuthException catch (e) {
      showErrorSnackBar(message: "Registration failed: ${e.message}");
    } catch (e){
      showErrorSnackBar(message: "Registration failed with an unexpected error, please try again or contact us for support");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserModel user = await _authService.signInWithPassword(email, password);
      _analytics.identify(user.id);
      _analytics.track('USER_AUTHENTICATED', properties: {'user': '${user.toJson()}'});
      showSuccessSnackBar(message: 'Logged in successfully');
      Get.offAllNamed(Routes.home);
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
}
