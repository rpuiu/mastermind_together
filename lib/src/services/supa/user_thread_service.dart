import 'package:get/get.dart';
import 'package:mastermind_together/src/assistants/user_thread_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserThreadService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<UserThreadModel?> getUserThread(String userId) async {
    try {
      final response = await _client.from('user_threads').select().eq('user_id', userId).maybeSingle();
      return response == null ? response : UserThreadModel.fromJson(response);
    } catch (e, s) {
      Log().e("Error while getting user AI thread:", e, s);
      rethrow;
    }
  }

  Future<UserThreadModel> addUserThread(String userId, String threadId) async {
    try {
      final List<Map<String, dynamic>> response = await _client.from('user_threads').insert({'user_id': userId, 'ai_thread_id': threadId}).select();
      return UserThreadModel.fromJson(response[0]);
    } catch (e, s) {
      Log().e("Error while adding user AI thread:", e, s);
      rethrow;
    }
  }

  Future<void> updateCategory(int id, String name) async {
    try {
      await _client.from('categories').update({'name': name}).eq('id', id);
    } catch (e, s) {
      Log().e("Error while updating category:", e, s);
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _client.from('categories').delete().eq('id', id);
    } catch (e, s) {
      Log().e("Error while deleting category:", e, s);
      rethrow;
    }
  }
}
