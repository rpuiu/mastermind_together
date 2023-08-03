import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TenantController extends GetxController {
  final TenantService tenantService = Get.find<TenantService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final SettingsService _settingsService = Get.find<SettingsService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxString termsOfService = ''.obs;
  final RxString privacyPolicy = ''.obs;

  final Rx<TextEditingController> tosController = TextEditingController().obs;
  final Rx<TextEditingController> ppController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  @override
  void onClose() {
    tosController.value.dispose();
    ppController.value.dispose();
    super.onClose();
  }

  Future<void> registerTenant(String tenantName, String adminEmail, String adminPassword) async {
    if (tenantName.isNotEmpty && adminEmail.isNotEmpty && adminPassword.isNotEmpty) {
      try {
        await tenantService.registerTenant(tenantName, adminEmail, adminPassword);

        _analytics.track('TENANT_REGISTERED', properties: {
          'tenantName': tenantName,
          'adminEmail': adminEmail,
        });
        Get.toNamed(Routes.login);
      } catch (e) {
        showErrorSnackBar(message: 'Failed to create tenant: $e');
      }
    } else {
      showErrorSnackBar(message: 'Name, email and password cannot be empty');
    }
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsService.fetchSettings(_authService.currentUser!.id);

      termsOfService.value = settings['terms_of_service'] as String;
      privacyPolicy.value = settings['privacy_policy'] as String;

      tosController.value = TextEditingController(text: settings['terms_of_service'] as String);
      ppController.value = TextEditingController(text: settings['privacy_policy'] as String);
    } catch (e, s) {
      Log().e('Failed to load settings', e, s);
      showErrorSnackBar(message: 'Failed to load settings');
    }
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
