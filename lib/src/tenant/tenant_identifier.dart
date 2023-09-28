import 'dart:html' as html;

import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';
import 'package:mastermind_together/src/tenant/tenant_model.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TenantIdentifier extends GetxService {
  final TenantService _tenantService = Get.find<TenantService>();

  Rx<Tenant> tenant = Tenant.empty().obs;

  @override
  onInit() async {
    super.onInit();
    tenant.value = await _getTenantByHostName();
  }

  Future<String> getTenantId() async {
    try {
      if (tenant.value.tenantId.isEmpty) {
        tenant.value = await _getTenantByHostName();
      }
      return tenant.value.tenantId;
    } catch (e) {
      showErrorSnackBar(message: 'Unable to identify your tenant. Please contact us for support');
      throw Exception("Unable to identify tenant");
    }
  }

  Future<Tenant> _getTenantByHostName() async {
    try {
      final hostname = html.window.location.hostname;
      Tenant tenant = await _tenantService.getTenantByHostName(hostname!);
      return tenant;
    } catch (e) {
      throw Exception("Unable to identify tenant");
    }
  }
}
