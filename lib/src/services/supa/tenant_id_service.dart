import 'package:get/get.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/tenant/tenant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TenantIdService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<Tenant> getTenantByHostName(String hostname) async {
    try {
      final response = await _client.from('tenants').select().eq('hostname', hostname).single();
      return Tenant.fromJson(response);
    } catch (e, s) {
      Log().e('Failed to get tenant id: ', e, s);
      rethrow;
    }
  }
}
