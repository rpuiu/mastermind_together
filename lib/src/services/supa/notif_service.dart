import 'package:get/get.dart';
import 'package:mastermind_together/src/notif/notif_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  late RealtimeChannel notificationSubscription;

  static const String _notificationTable = 'notifications';
  static const String _userIdField = 'user_id';
  static const String _tenantIdField = 'tenant_id';
  static const String _messageField = 'message';
  static const String _typeField = 'type';
  static const String _readStatusField = 'read_status';

  Future<T> _runQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, s) {
      Log().e("Error while executing query: $query:", e, s);
      rethrow;
    }
  }

  Future<NotificationModel> createNotification(String userId, String tenantId, String message, String type) async {
    return _runQuery(() async {
      final notification = await _client.from(_notificationTable).insert({
        _userIdField: userId,
        _tenantIdField: tenantId,
        _messageField: message,
        _typeField: type,
      }).select();

      if (notification.isNotEmpty) {
        return NotificationModel.fromJson(notification[0]);
      } else {
        throw Exception('Error creating notification');
      }
    });
  }

  Future<List<NotificationModel>> readNotifications(String userId) async {
    return _runQuery(() async {
      final List<dynamic> response = await _client.from(_notificationTable).select().eq(_userIdField, userId);
      return response.map((json) => NotificationModel.fromJson(json)).toList();
    });
  }

  Future<NotificationModel> markAsRead(String notificationId) async {
    return _runQuery(() async {
      final List<dynamic> response = await _client.from(_notificationTable).update({_readStatusField: true}).eq('id', notificationId).select();
      if (response[0] != null) {
        return NotificationModel.fromJson(response[0]);
      } else {
        throw Exception('Unable to mark notification as read');
      }
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    return _runQuery(() async {
      await _client.from(_notificationTable).delete().eq('id', notificationId);
    });
  }

  void subscribeToNotificationChanges(String userId, Function(String, NotificationModel) onNotificationChanges) {
    notificationSubscription = _client.channel('public:notifications:user_id=eq.$userId').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: _notificationTable, filter: 'user_id=eq.$userId'),
      (payload, [ref]) {
        Log().i('Notification change received: ${payload.toString()}');

        NotificationModel changedNotification = NotificationModel.fromJson(payload['new']);

        switch (payload['eventType']) {
          case 'INSERT':
          case 'UPDATE':
          case 'DELETE':
            onNotificationChanges(payload['eventType'], changedNotification);
            break;
          default:
            break;
        }
      },
    );

    notificationSubscription.subscribe();
  }

  Future<void> unsubscribeFromNotificationChanges() async {
    await _client.removeChannel(notificationSubscription);
  }
}
