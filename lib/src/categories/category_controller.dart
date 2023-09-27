import 'package:get/get.dart';
import 'package:mastermind_together/src/categories/category_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/category_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = Get.find<CategoryService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<String> categoryNames = <String>[].obs;

  @override
  void onInit() async{
    super.onInit();
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      String tenantId = _authService.getUser()!.tenantId;
      final List<CategoryModel> allCategories = await _categoryService.getAllCategories(tenantId);
      categories.clear();
      categories.addAll(allCategories);

      categoryNames.clear();
      categoryNames.addAll(allCategories.map((c) => c.name));
    } catch (e, s) {
      Log().e('Error fetching categories ', e, s);
      showErrorSnackBar(message: 'Error fetching categories: $e');
    }
  }

  void deleteCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      fetchCategories();
    } catch (e) {
      showErrorSnackBar(message: 'Error deleting category: $e');
    }
  }

  void addCategory(String name) async {
    try {
      String tenantId = _authService.getUser()!.id;
      await _categoryService.addCategory(tenantId, name);
      fetchCategories(); // Refresh the categories
    } on PostgrestException catch (e) {
      if (e.message.contains('duplicate key value violates unique constraint')) {
        showErrorSnackBar(message: "Category $name already exists");
      }
    } catch (e) {
      showErrorSnackBar(message: 'Error adding category: $e');
    }
  }

  void updateCategory(int id, String name) async {
    try {
      await _categoryService.updateCategory(id, name);
      fetchCategories(); // Refresh the categories
    } catch (e) {
      showErrorSnackBar(message: 'Error updating category: $e');
    }
  }
}
