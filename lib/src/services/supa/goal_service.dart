import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  late RealtimeChannel insertGoalSubscription;

  Future<List<GoalModel>> readUserGoals(String userId) async {
    final List<dynamic> data = await _client.from('goals').select().eq('user_id', userId);
    return data.map((e) => GoalModel.fromJson(e)).toList();
  }

  Future<GoalModel> createGoal(String userId, String goal, String category, bool autoSelectGroup, String tenantId) async {
    try {
      List<Map<String, dynamic>> goalResponse = await _client.from('goals').insert({
        'user_id': userId,
        'goal': goal,
        'category': category,
        'auto_select_group': autoSelectGroup,
        'tenant_id': tenantId,
      }).select();
      if (goalResponse.isNotEmpty) {
        return GoalModel.fromJson(goalResponse[0]);
      } else {
        throw Exception('Error creating goal');
      }
    } catch (e, s) {
      Log().e("Error while creating goal for $userId:", e, s, tenantId);
      rethrow;
    }
  }

  void subscribeToGoalChanges(Function(GoalModel) onNewGoal) {
    try {
      insertGoalSubscription = _client.channel('public:goals').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'INSERT', schema: 'public', table: 'goals'),
        (payload, [ref]) {
          Log().i('Goal change occurred: ${payload.toString()}');
          onNewGoal(GoalModel.fromJson(payload["new"]));
        },
      );

      insertGoalSubscription.subscribe();
    } catch (e, s) {
      Log().e("Error while subscribing to goal changes:", e, s);
      rethrow;
    }
  }

  Future<void> unsubscribeFromGoalChanges() async {
    try {
      await _client.removeChannel(insertGoalSubscription);
    } catch (e, s) {
      Log().e("Error while removing goal changes subscription:", e, s);
      rethrow;
    }
  }
}
