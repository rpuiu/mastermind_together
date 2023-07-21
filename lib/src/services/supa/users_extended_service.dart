import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersExtendedService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<UserModel> createUserExtended(String userId, String username, String email, String timezone, String tenantId) async {
    try {
      List<Map<String, dynamic>> userExtended = await _client.from('users_extended').insert({
        'user_id': userId,
        'email': email,
        'username': username,
        'timezone': timezone,
        'tenant_id': tenantId,
      }).select();

      if (userExtended.isNotEmpty) {
        return UserModel.fromJson(userExtended[0]);
      } else {
        throw Exception('Error creating extended user');
      }
    } catch (e, s) {
      print('$e $s');
      rethrow;
    }
  }

  Future<String> readTimezone(String userId) async {
    try {
      Map<String, dynamic> response = await _client.from('users_extended').select('timezone').eq('user_id', userId).single();
      return response['timezone'];
    } catch (e, s) {
      print('$e $s');
      rethrow;
    }
  }

  Future<UserModel> updateTimezone(String userId, String value) async {
    try {
      Map<String, dynamic> response =
          await _client.from('users_extended').update({'timezone': value}).eq('user_id', userId).select<Map<String, dynamic>>().single();
      return UserModel.fromJson(response);
    } catch (e, s) {
      print('$e $s');
      rethrow;
    }
  }

  Future<UserModel> readUserExtended(String userId) async {
    try {
      final Map<String, dynamic> response = await _client.from('users_extended').select().eq('user_id', userId).single();
      return UserModel.fromJson(response);
    } catch (e, s) {
      print('$e $s');
      rethrow;
    }
  }
}
