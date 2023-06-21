import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalController extends GetxController {
  final SupabaseClient client = Get.find();

  // This is just a placeholder. You might want to fetch these from your database.
  final List<String> goalAreas = ['Please select...', 'Health', 'Career', 'Education', 'Others'];

  RxString? selectedArea = 'Please select...'.obs;
  RxBool autoSelectGroup = false.obs;

  StreamSubscription? _goalsSubscription;
  final RxList<Goal> goals = <Goal>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGoals();
    listenToGoalChanges();
  }

  void fetchUserGoals() async {
    final User? user = client.auth.currentUser;
    final List<dynamic> data = await client.from('goals').select().eq('user_id', user!.id);
    goals.value = data.map((e) => Goal.fromJson(e)).toList();
  }

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

  void listenToGoalChanges() {
    client.channel('public:goals').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'INSERT', schema: 'public', table: 'goals'),
      (payload, [ref]) {
        print('Change received: ${payload.toString()}');
        goals.add(Goal.fromJson(payload["new"]));
      },
    ).subscribe();
  }

  @override
  void onClose() {
    _goalsSubscription?.cancel(); // Stop listening to changes
    super.onClose();
  }
}
