import 'package:get/get.dart';
import 'package:mastermind_together/src/dbops/supa/user_group_service.dart';
import 'package:mastermind_together/src/groups/group_model.dart';

class GroupController extends GetxController {
  final UserGroupService _groupService = Get.find<UserGroupService>();
  final RxList<GroupModel> groups = RxList<GroupModel>();
  final GroupModel group = GroupModel.empty();
  final isLoading = Rx<bool>(true);

  @override
  void onInit() {
    fetchGroups();
    super.onInit();
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
}
