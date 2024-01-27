import 'package:get/get.dart';
import 'package:mastermind_together/src/checkout/checkout_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TenantController extends GetxController {
  final TenantService tenantService = Get.find<TenantService>();
  final AuthService authService = Get.find<AuthService>();
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final String? priceId = Get.parameters['priceId'];
  final String successURL = "https://app.mastermindtogether.com/dashboard";

  Future<void> registerTenant(String tenantName, String adminEmail, String adminPassword, String hostName) async {
    if (tenantName.isNotEmpty && adminEmail.isNotEmpty && adminPassword.isNotEmpty) {
      try {
        await tenantService.registerTenant(tenantName, adminEmail, adminPassword, hostName);

        _analytics.track('TENANT_REGISTERED', properties: {
          'tenantName': tenantName,
          'adminEmail': adminEmail,
        });

        await checkout(adminEmail, adminPassword);
      } catch (e) {
        showErrorSnackBar(message: 'Failed to create tenant: $e');
      }
    } else {
      showErrorSnackBar(message: 'Name, email and password cannot be empty');
    }
  }

  Future<void> checkout(String adminEmail, String adminPassword) async {
    if (priceId != null) {
      try {
        await authService.signInWithPassword(adminEmail, adminPassword);
        await checkoutController.initiateCheckout(priceId: priceId!, successURL: successURL);
      } catch (e) {
        showErrorSnackBar(message: "Unable to automatically log in. Please try again or contact us for support");
        Get.toNamed(Routes.login);
      }
    }
  }
}
