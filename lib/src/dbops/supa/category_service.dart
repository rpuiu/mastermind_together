import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<int> createCategory(String name) async {
    final response = await _client.from('categories').insert({'name': name});
    return response;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final List<dynamic> data = await _client.from('categories').select();
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<void> updateCategory(int id, String newName) async {
    final response = await _client.from('categories').update({'name': newName}).eq('id', id);
  }

  Future<void> deleteCategory(int id) async {
    final response = await _client.from('categories').delete().eq('id', id);
  }
}
