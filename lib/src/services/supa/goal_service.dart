import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  late RealtimeChannel insertGoalSubscription;

  Future<List<GoalModel>> readUserGoals(String userId) async {
    final List<dynamic> data = await _client.from('goals').select().eq('user_id', userId);
    return data.map((e) => GoalModel.fromJson(e)).toList();
  }

  Future<void> createGoal(String userId, String goal, String goalArea, bool autoSelectGroup) async {
    final response = await _client.from('goals').insert({
      'user_id': userId,
      'goal': goal,
      'goal_area': goalArea,
      'auto_select': autoSelectGroup,
    });
  }

  void subscribeToGoalChanges(Function(GoalModel) onNewGoal) {
    insertGoalSubscription = _client.channel('public:goals').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'INSERT', schema: 'public', table: 'goals'),
      (payload, [ref]) {
        print('Change received: ${payload.toString()}');
        onNewGoal(GoalModel.fromJson(payload["new"]));
      },
    );

    insertGoalSubscription.subscribe();
  }

  Future<void> unsubscribeFromGoalChanges() async {
    await _client.removeChannel(insertGoalSubscription);
  }
}
