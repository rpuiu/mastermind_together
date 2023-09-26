import 'dart:html' as html;

import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TenantIdentifier extends GetxService {
  final TenantService _tenantService = Get.find<TenantService>();

  Future<String> getTenantId() async {
    try {
      final hostname = html.window.location.hostname;
      String tenantId = await _tenantService.getTenantIdByHostName(hostname!);
      return tenantId;
    } catch (e) {
      showErrorSnackBar(message: 'Unable to identify your tenant. Please contact us for support');
      throw Exception("Unable to identify tenant");
    }
  }
}
