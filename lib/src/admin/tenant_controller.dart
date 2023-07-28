import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';

class TenantController extends GetxController {
  final TextEditingController tenantNameController = TextEditingController();
  final TenantService tenantService = Get.find<TenantService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  Future<void> registerTenant() async {
    final tenantName = tenantNameController.text.trim();
    if (tenantName.isNotEmpty) {
      try {
        String tenantId = await tenantService.createTenant(tenantName);
        _analytics.track('TENANT_REGISTERED', properties: {
          'tenantName': tenantName,
          'tenantId': tenantId,
        });

        Get.snackbar('Success', 'Tenant created with ID: $tenantId');
        tenantNameController.clear();
      } catch (e) {
        Get.snackbar('Error', 'Failed to create tenant: $e');
      }
    } else {
      Get.snackbar('Error', 'Tenant name cannot be empty');
    }
  }
}
