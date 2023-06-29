import 'package:get/get.dart';
import 'package:mastermind_together/src/dbops/supa/category_service.dart';
import 'package:mastermind_together/src/dbops/supa/user_group_service.dart';
import 'package:mastermind_together/src/goal/category_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';

class GroupController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  final RxList<GroupModel> groups = RxList<GroupModel>();
  final GroupModel group = GroupModel.empty();
  final isLoading = Rx<bool>(true);

  RxList<String> categories = <String>[].obs;
  RxString? selectedCategory = 'Please select...'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    fetchCategories();
  }

  // This will be called when the 'Create Group' button is pressed
  Future<void> createGroup() async {
    try {
      await _groupService.createGroup(group);
      Get.snackbar(
        'Group Created',
        'The group has been successfully created!',
        snackPosition: SnackPosition.BOTTOM,
      );
      update();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error creating group',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void fetchGroups() async {
    isLoading(true);
    try {
      final response = await _groupService.readAllGroups();
      if (response != null) {
        groups.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchCategories() async {
    try {
      List<CategoryModel> allCategories = await _categoryService.getAllCategories();
      categories.assignAll(['Please select...']);
      categories.addAll(allCategories.map((c) => c.name));
    } catch (e) {
      print('Error fetching goal areas: $e');
      // Handle error as needed.
    }
  }
}
