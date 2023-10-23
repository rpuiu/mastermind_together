import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class ForgotPassController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final TextEditingController emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString successMessage = ''.obs;

  Future<void> resetPassword() async {
    isLoading.value = true;
    try {
      await _authService.resetPassword(emailController.text);
      successMessage.value =
          "An email has been sent. Follow the link and reset your password. \n\nIf it doesn't arrive in 5 minutes, please try again or contact us.";
    } catch (e) {
      showErrorSnackBar(message: "Unable to reset your password. Please try again or contact us for support");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }
}
