import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  Future<void> register(String username, String email, String password) async {
    try {
      await _authService.signUp(username, email, password);
      showSuccessSnackBar(message: 'Congratulations, your account has been successfully created');
      Get.offAllNamed(Routes.login);
    } catch (e) {
      showErrorSnackBar(message: "Registration failed, please try again or contact us for support");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _authService.signInWithPassword(email, password);
      showSuccessSnackBar(message: 'Logged in successfully');
      Get.find<Mixpanel>().track("$email logged in successfully");
      Get.offAllNamed(Routes.home);
    } catch (e) {
      showErrorSnackBar(message: "Error while authenticating [$email]. Please try again or contact us for support.");
      await _authService.signOut(); // on sign-in failure, sign out the user
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      showSuccessSnackBar(message: 'Logged out successfully');
    } catch (e) {
      showErrorSnackBar(message: "Error while logging out. Please try again or contact us for support");
    }
  }
}
