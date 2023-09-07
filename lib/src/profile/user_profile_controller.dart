import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/storage_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();
  late Rx<UserModel?> user;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxString signedAvatarUrl = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeUser();
  }

  void initializeUser() {
    user = _authService.getUser().obs;
    Future.microtask(() => updateSignedUrl(user.value!.avatarUrl ?? ''));
  }

  Future<void> updateUser(UserModel newUser) async {
    try {
      await _authService.updateUser(newUser);
      user.value = newUser;
    } catch (e, s) {
      handleException(e, s, "Failed to update user");
    }
  }

  Future<void> changePassword() async {
    try {
      validateNewPassword();
      await _authService.changePassword(oldPasswordController.text, newPasswordController.text, confirmPasswordController.text);
      showSuccessSnackBar(message: "Password changed successfully!");
    } catch (e, s) {
      handleException(e, s, "Failed to change password");
    }
  }

  void validateNewPassword() {
    if (newPasswordController.text != confirmPasswordController.text) {
      throw Exception('The new password does not match the confirmation password');
    }
  }

  void clearForm() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> pickImage() async {
    final XFile? image = await getImageFromGallery();
    if (image != null) {
      uploadImage(image);
    }
  }

  Future<XFile?> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadImage(XFile image) async {
    try {
      final Uint8List data = await image.readAsBytes();
      String newAvatarUrl = await _storageService.upsertAvatar(user.value!, data);

      final UserModel updatedUser = user.value!.copyWith(avatarUrl: newAvatarUrl);
      await updateUser(updatedUser);
      updateSignedUrl(newAvatarUrl);
    } catch (e, s) {
      handleException(e, s, "Failed to upload avatar");
    }
  }

  Future<void> updateSignedUrl(String avatarPath) async {
    try {
      if (avatarPath.isEmpty) {
        signedAvatarUrl.value = '';
        return;
      }
      String trimmedPath = avatarPath.substring('/avatars'.length);
      String signedUrl = await _storageService.createSignedUrl(trimmedPath);
      signedAvatarUrl.value = signedUrl;
    } catch (e, s) {
      handleException(e, s, "Unable to load avatar");
    }
  }

  void handleException(dynamic e, StackTrace s, String defaultMessage) {
    Log().e(defaultMessage, e, s);
    if (e is AuthException) {
      showErrorSnackBar(message: "$defaultMessage: ${e.message}");
    } else {
      showErrorSnackBar(message: "$defaultMessage. Please try again");
    }
  }
}
