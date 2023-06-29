import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserExtendedService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<List<Map<String, dynamic>>> createUserExtended(String userId) async {
    List<Map<String, dynamic>> responseExtended = await _client.from('user_extended').insert({
      'user_id': userId,
      'timezone': '', // Set timezone to an empty string for now.
    }).select();
    return responseExtended;
  }

  Future<String> readTimezone(String userId) async {
    Map<String, dynamic> response = await _client.from('user_extended').select('timezone').eq('user_id', userId).single();
    return response['timezone'];
  }

  Future<void> updateTimezone(String userId, String value) async {
    final userExtResponse = await _client.from('user_extended').update({
      'timezone': value,
    }).eq('user_id', userId);
  }
}
