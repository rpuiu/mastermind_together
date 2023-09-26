import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/tenant/tenant_identifier.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TermsController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();
  final AuthService _authService = Get.find<AuthService>();
  final TenantIdentifier _tenantIdentifier = Get.find<TenantIdentifier>();
  final RxString termsOfService = ''.obs;
  final RxString privacyPolicy = ''.obs;

  final Rx<TextEditingController> tosController = TextEditingController().obs;
  final Rx<TextEditingController> ppController = TextEditingController().obs;

  @override
  onInit() async {
    super.onInit();
    String tenantIdParam = await _tenantIdentifier.getTenantId();
    await _loadTerms(tenantIdParam);

    if (_authService.currentUser != null) {
      await _loadTerms(_authService.currentUser!.id);
      _loadSettingsForEditing();
    }
  }

  @override
  void onClose() {
    tosController.value.dispose();
    ppController.value.dispose();
    super.onClose();
  }

  Future<void> _loadTerms(String tenantId) async {
    try {
      final settings = await _settingsService.fetchSettings(tenantId);
      termsOfService.value = settings['terms_of_service'] as String;
      privacyPolicy.value = settings['privacy_policy'] as String;
    } catch (e) {
      showErrorSnackBar(message: 'Failed to load tenant terms');
    }
  }

  Future<void> _loadSettingsForEditing() async {
    tosController.value = TextEditingController(text: termsOfService.value);
    ppController.value = TextEditingController(text: privacyPolicy.value);
  }

  Future<void> updateTerms() async {
    try {
      await _settingsService.updateSettings(_authService.currentUser!.id, tosController.value.text, ppController.value.text);
      showSuccessSnackBar(message: 'Settings updated successfully');
    } catch (e) {
      showErrorSnackBar(message: 'Failed to update settings');
    }
  }
}
