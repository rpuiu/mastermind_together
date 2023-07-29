import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  late Rx<UserModel?> user;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user = _authService.getUser().obs;
  }

  Future<void> updateUser(UserModel newUser) async {
    try {
      await _authService.updateUser(newUser);
      user.value = newUser;
    } catch (e) {
      showErrorSnackBar(message: "Failed to update user: $e");
    }
  }

  Future<void> changePassword() async {
    try {
      if (newPasswordController.text != confirmPasswordController.text) {
        throw Exception('The new password does not match the confirmation password');
      }
      await _authService.changePassword(oldPasswordController.text, newPasswordController.text, confirmPasswordController.text);
      showSuccessSnackBar(message: "Password changed successfully!");
    } on AuthException catch (e) {
      showErrorSnackBar(message: "Failed to change password: ${e.message}");
    } catch (e) {
      showErrorSnackBar(message: "Failed to change password. Please try again");
    }
  }

  void clearForm() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please confirm your new password';
    } else if (value != newPasswordController.text) {
      return 'The new password does not match the confirmation password';
    }
    return null;
  }

  String? validateIfEmpty(String value, String message) {
    if (value.isEmpty) {
      return message;
    }
    return null;
  }
}
