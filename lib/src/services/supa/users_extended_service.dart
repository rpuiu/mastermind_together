import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersExtendedService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  static const String _usersExtendedTable = 'users_extended';
  static const String _userIdField = 'user_id';
  static const String _timezoneField = 'timezone';
  static const String _emailField = 'email';
  static const String _userNameField = 'username';
  static const String _tenantIdField = 'tenant_id';
  static const String _subscriptionIdField = 'subscription_id';

  Future<T> _runQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, s) {
      Log().e("Error while executing query: $query:", e, s);
      rethrow;
    }
  }

  Future<UserModel> createUserExtended(String userId, String username, String email, String timezone, String tenantId, String subscriptionId) async {
    return _runQuery(() async { //TODO userModel.toJson
      final userExtended = await _client.from(_usersExtendedTable).insert({
        _userIdField: userId,
        _emailField: email,
        _userNameField: username,
        _timezoneField: timezone,
        _tenantIdField: tenantId,
        _subscriptionIdField: subscriptionId,
      }).select();

      if (userExtended.isNotEmpty) {
        return UserModel.fromJson(userExtended[0]);
      } else {
        throw Exception('Error creating user details');
      }
    });
  }

  Future<String> readTimezone(String userId) async {
    return _runQuery(() async {
      final response = await _client.from(_usersExtendedTable).select(_timezoneField).eq(_userIdField, userId).single();
      return response[_timezoneField];
    });
  }

  Future<UserModel> updateTimezone(String userId, String value) async {
    return _runQuery(() async {
      final response = await _client.from(_usersExtendedTable).update({_timezoneField: value}).eq(_userIdField, userId).single();
      return UserModel.fromJson(response);
    });
  }

  Future<UserModel> readUserExtended(String userId) async {
    return _runQuery(() async {
      final response = await _client.from(_usersExtendedTable).select().eq(_userIdField, userId).single();
      return UserModel.fromJson(response);
    });
  }

  Future<UserModel> updateUser(UserModel newUser) async {
    return _runQuery(() async {
      final response = await _client
          .from(_usersExtendedTable)
          .update({
            _emailField: newUser.email,
            _userNameField: newUser.username,
            _timezoneField: newUser.timezone,
          })
          .eq(_userIdField, newUser.id)
          .select();

      return UserModel.fromJson(response[0]);
    });
  }

  Future<String> getSubscriptionId(String userId) async {
    return _runQuery(() async {
      final response = await _client.from(_usersExtendedTable).select(_subscriptionIdField).eq(_userIdField, userId).single();
      return response[_subscriptionIdField] as String;
    });
  }
}
