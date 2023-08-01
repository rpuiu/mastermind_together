import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<void> createInitialSettings(String tenantId, String termsOfService, String privacyPolicy) async {
    try {
      await _client.from('settings').insert({
        'tenant_id': tenantId,
        'terms_of_service': termsOfService,
        'privacy_policy': privacyPolicy,
      });
    } catch (e) {
      throw Exception('Failed to create initial settings: $e');
    }
  }
}
