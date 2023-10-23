import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class PasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  bool isAuthenticated() {
    return _authService.isAuthenticated();
  }

  Future<void> updatePassword() async {
    isLoading.value = true;
    try {
      await _authService.updatePassword(newPasswordController.text);
      showSuccessSnackBar(message: "Password changed successfully! Please log in with the new password.");
      Get.toNamed(Routes.home);
    } catch (e, s) {
      newPasswordController.clear();
      confirmPasswordController.clear();
      Log().e("Error while resetting password:", e, s);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}
