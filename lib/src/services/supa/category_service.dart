import 'package:get/get.dart';
import 'package:mastermind_together/src/categories/category_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<List<CategoryModel>> getAllCategories(String tenantId) async {
    try {
      final List<dynamic> data = await _client.from('categories').select().eq('tenant_id', tenantId);
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e, s) {
      Log().e("Error while getting categories:", e, s);
      rethrow;
    }
  }

  Future<void> addCategory(String tenantId, String name) async {
    try {
      await _client.from('categories').insert({'tenant_id': tenantId, 'name': name});
    } catch (e, s) {
      Log().e("Error while adding category:", e, s);
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
