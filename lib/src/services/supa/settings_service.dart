import 'package:get/get.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
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

  Future<Map<String, dynamic>> fetchSettings(String tenantId) async {
    try {
      final Map<String, dynamic> response = await _client.from('settings').select().eq('tenant_id', tenantId).single();
      return response;
    } catch (e, s) {
      Log().e('Failed to fetch settings: ', e, s);
      rethrow;
    }
  }

  Future<void> updateSettings(String tenantId, String termsOfService, String privacyPolicy) async {
    try {
      final response = await _client
          .from('settings')
          .update({
            'terms_of_service': termsOfService,
            'privacy_policy': privacyPolicy,
          })
          .eq('tenant_id', tenantId)
          .select();
    } catch (e, s) {
      Log().e('Failed to update settings: ', e, s);
      rethrow;
    }
  }

  Future<void> updateLogoUrl(String tenantId, String newLogoUrl, bool isLight) async {
    final String column = isLight ? 'light_logo_url' : 'dark_logo_url';
    try {
      final response = await _client.from('settings').update({column: newLogoUrl}).eq('tenant_id', tenantId).select();
    } catch (e, s) {
      Log().e('Failed to update logo URL: ', e, s);
      rethrow;
    }
  }

  Future<String?> fetchLogoUrl(String tenantId, bool isLight) async {
    final String column = isLight ? 'light_logo_url' : 'dark_logo_url';
    try {
      final response = await _client.from('settings').select(column).eq('tenant_id', tenantId).single();
      return response[column];
    } catch (e, s) {
      Log().e('Failed to fetch logo URL: ', e, s);
      rethrow;
    }
  }

  Future<void> updateFaviconUrl(String tenantId, String newFaviconUrl) async {
    try {
      final response = await _client.from('settings').update({'favicon_url': newFaviconUrl}).eq('tenant_id', tenantId).select();
    } catch (e, s) {
      Log().e('Failed to update favicon URL: ', e, s);
      rethrow;
    }
  }

  Future<String?> fetchFaviconUrl(String tenantId) async {
    try {
      final response = await _client.from('settings').select('favicon_url').eq('tenant_id', tenantId).single();
      return response['favicon_url'];
    } catch (e, s) {
      Log().e('Failed to fetch favicon URL: ', e, s);
      rethrow;
    }
  }
}
