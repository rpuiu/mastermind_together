import 'dart:convert';
import 'dart:html' as html;

import 'package:get/get.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/tenant_id_service.dart';
import 'package:mastermind_together/src/tenant/tenant_model.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TenantIdentifier extends GetxService {
  final TenantIdService _tenantService = Get.find<TenantIdService>();
  final LocalStorageService _localStorageService = Get.find<LocalStorageService>();

  Rx<Tenant> tenant = Tenant.empty().obs;

  Future<String> getTenantId() async {
    // tenant.value.tenantId = "7e8a7b50-d86b-453d-8601-e51868add06f"; //For debugging in prod
    try {
      if (tenant.value.tenantId.isEmpty) {
        String? cachedTenantJson = _localStorageService.getTenant();
        if (cachedTenantJson != null) {
          tenant.value = Tenant.fromJson(jsonDecode(cachedTenantJson));
        } else {
          tenant.value = await _getTenantByHostName();
          await _localStorageService.setTenant(jsonEncode(tenant.value.toJson()));
        }
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
      tenant.value = await _tenantService.getTenantByHostName(hostname!);
      return tenant.value;
    } catch (e) {
      throw Exception("Unable to identify tenant");
    }
  }

  Future<void> initialize() async {
    await getTenantId();
  }
}
