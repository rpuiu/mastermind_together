import 'package:get/get.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TenantService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<String> createTenant(String tenantName) async {
    try {
      final response = await _client.from('tenants').insert({
        'name': tenantName,
      }).select();

      if (response.isNotEmpty) {
        final newTenantId = response[0]['tenant_id'];

        if (newTenantId != null) {
          return newTenantId;
        } else {
          throw Exception('Error obtaining id of the newly created tenant');
        }
      } else {
        throw Exception('Error creating new tenant: $response');
      }
    } catch (e, s) {
      Log().e("Error while creating tenant:", e, s);
      rethrow;
    }
  }
}
