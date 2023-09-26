import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TenantController extends GetxController {
  final TenantService tenantService = Get.find<TenantService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  Future<void> registerTenant(String tenantName, String adminEmail, String adminPassword, String hostName) async {
    if (tenantName.isNotEmpty && adminEmail.isNotEmpty && adminPassword.isNotEmpty) {
      try {
        await tenantService.registerTenant(tenantName, adminEmail, adminPassword, hostName);

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
}
