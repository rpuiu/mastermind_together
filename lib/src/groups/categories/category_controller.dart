import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/services/supa/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = Get.find<CategoryService>();
  final RxList<String> categories = <String>[].obs;

  void fetchCategories() async {
    try {
      final allCategories = await _categoryService.getAllCategories();
      categories.clear(); // clear the list before adding new items
      categories.addAll(allCategories.map((c) => c.name));
    } catch (e, s) {
      showErrorSnackBar(message: 'Error fetching categories: $e');
    }
  }
}
