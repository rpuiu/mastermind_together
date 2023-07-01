import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersExtendedService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<List<Map<String, dynamic>>> createUserExtended(String userId, String email) async {
    List<Map<String, dynamic>> responseExtended = await _client.from('users_extended').insert({
      'user_id': userId,
      'email': email,
      'timezone': '', // Set timezone to an empty string for now.
    }).select();
    return responseExtended;
  }

  Future<String> readTimezone(String userId) async {
    Map<String, dynamic> response = await _client.from('users_extended').select('timezone').eq('user_id', userId).single();
    return response['timezone'];
  }

  Future<void> updateTimezone(String userId, String value) async {
    final userExtResponse = await _client.from('users_extended').update({
      'timezone': value,
    }).eq('user_id', userId);
  }
}
