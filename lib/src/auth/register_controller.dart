import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/notif/email/email_notif_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/tenant/tenant_identifier.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final TenantIdentifier _tenantIdentifier = Get.find<TenantIdentifier>();
  final EmailController _emailController = Get.find<EmailController>();

  final RxBool isLoading = false.obs;
  final RxString tenantIdObs = ''.obs;

  @override
  onInit() async {
    super.onInit();
    tenantIdObs.value = await _tenantIdentifier.getTenantId();
  }

  Future<void> register(String username, String email, String password) async {
    isLoading.value = true;
    try {
      UserModel user = await _authService.signUp(tenantIdObs.value, username, email, password);
      _analytics.track('USER_REGISTERED', properties: {'user': '${user.toJson()}'});
      _analytics.setUserProperties(user.id, "\$email", user.email);
      _analytics.setUserProperties(user.id, "\$name", user.username);

      notifyMMTOnNewRegister(user.username);

      showSuccessSnackBar(message: 'Congratulations, your account has been successfully created');
      //todo add confirmation email message
      await _authService.signInWithPassword(email, password);
      _analytics.identify(user.id);
      _analytics.track('USER_AUTHENTICATED', properties: {'user': '${user.toJson()}'});

      isLoading.value = false;
      _redirect();
    } on AuthException catch (e) {
      showErrorSnackBar(message: "Registration failed: ${e.message}");
      isLoading.value = false;
    } catch (e) {
      showErrorSnackBar(message: "Registration failed with an unexpected error, please try again or contact us for support");
      isLoading.value = false;
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
        Get.offAllNamed(Routes.onboarding);
      }
    }
  }

  Future<void> notifyMMTOnNewRegister(String username) async {
    String subject = 'New user has registered: [ $username ]';
    String body = 'User $username has registered. ';

    await _emailController.sendEmail('mastermindtogether@gmail.com', subject, body);
  }
}
