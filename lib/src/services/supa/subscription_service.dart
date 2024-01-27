import 'package:get/get.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  static const freeTier = 'Starter Plan';

  static const String subscriptionTable = 'subscription';
  static const String subscriptionFeaturesTable = 'subscription_features';
  static const String maxGroupsCreateField = 'max_groups_create';
  static const String maxGroupsJoinField = 'max_groups_join';
  static const String subscriptionIdField = 'subscription_id';
  static const String idField = 'id';
  static const String nameField = 'name';

  Future<T> _runQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, s) {
      Log().e("Error while executing query: $query:", e, s);
      rethrow;
    }
  }

  Future<int?> getGroupCreationLimit(String userId, String subscriptionId) async {
    return _runQuery(() async {
      final Map<String, dynamic> featureResponse =
          await _client.from(subscriptionFeaturesTable).select(maxGroupsCreateField).eq(subscriptionIdField, subscriptionId).single();

      return featureResponse[maxGroupsCreateField];
    });
  }

  Future<int?> getGroupJoiningLimit(String userId, String subscriptionId) async {
    return _runQuery(() async {
      final featureResponse = await _client.from(subscriptionFeaturesTable).select(maxGroupsJoinField).eq(subscriptionIdField, subscriptionId).single();

      return featureResponse[maxGroupsJoinField];
    });
  }

  Future<String> getFreeTierSubscriptionId() async {
    return _runQuery(() async {
      final Map<String, dynamic> freeTierResponse =
      await _client.from(subscriptionTable)
          .select(idField)
          .eq(nameField, freeTier)
          .single();
      return freeTierResponse[idField] as String;
    });
  }
}
