import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalController extends GetxController {
  final SupabaseClient client = Get.find();

  // This is just a placeholder. You might want to fetch these from your database.
  final List<String> goalAreas = ['Please select...', 'Health', 'Career', 'Education', 'Others'];
  RxString? selectedArea = 'Please select...'.obs;
  RxBool autoSelectGroup = false.obs;

  Future<void> saveGoal(String goal) async {
    final User? user = client.auth.currentUser;

    if (user != null) {
      final response = await client.from('goals').insert({
        'user_id': user.id,
        'goal': goal,
        'goal_area': selectedArea!.value,
        'auto_select': autoSelectGroup.value,
      });
      Get.toNamed(Routes.home);
    } else {
      Get.toNamed(Routes.login);
    }
  }
}
