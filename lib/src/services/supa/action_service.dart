import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/action_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActionService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  static const String actionsTable = 'actions';
  static const String goalIdField = 'goal_id';
  static const String descriptionField = 'description';
  static const String statusField = 'status';
  static const String idField = 'id';

  Future<T> _runQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, s) {
      Log().e("Error while executing query: $query:", e, s);
      rethrow;
    }
  }

  Future<List<ActionModel>> readActionsForGoal(String goalId) async {
    return _runQuery(() async {
      final List<dynamic> data = await _client.from(actionsTable).select().eq(goalIdField, goalId);
      return data.map((e) => ActionModel.fromJson(e)).toList();
    });
  }

  Future<ActionModel> createAction(String goalId, String description, String status) async {
    return _runQuery(() async {
      final List<Map<String, dynamic>> actionResponse = await _client.from(actionsTable).insert({
        goalIdField: goalId,
        descriptionField: description,
        statusField: status,
      }).select();
      if (actionResponse.isNotEmpty) {
        return ActionModel.fromJson(actionResponse[0]);
      } else {
        throw Exception('Error creating action');
      }
    });
  }

  Future<void> updateActionStatus(String actionId, String newStatus) async {
    return _runQuery(() async {
      await _client.from(actionsTable).update({statusField: newStatus}).eq(idField, actionId);
    });
  }

  Future<void> updateActionDescription(String actionId, String newDescription) async {
    return _runQuery(() async {
      await _client.from(actionsTable).update({descriptionField: newDescription}).eq(idField, actionId);
    });
  }

  Future<void> deleteAction(String actionId) async {
    return _runQuery(() async {
      await _client.from(actionsTable).delete().eq(idField, actionId);
    });
  }
}
