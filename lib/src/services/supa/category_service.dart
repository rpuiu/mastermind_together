import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
//TODO MAIN-T-32
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final List<dynamic> data = await _client.from('categories').select();
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e, s) {
      print('$e $s');
      rethrow;
    }
  }
}
