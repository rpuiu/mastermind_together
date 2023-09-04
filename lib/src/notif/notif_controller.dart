import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/notif/notif_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/notif_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = Get.find<NotificationService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<NotificationModel> notifications = RxList<NotificationModel>();
  final isLoading = Rx<bool>(true);

  @override
  void onInit() {
    super.onInit();
    _fetchNotifications();
    UserModel user = _authService.getUser()!;
    _notificationService.subscribeToNotificationChanges(user.id, (eventType, changedNotification) {
      switch (eventType) {
        case 'INSERT':
          notifications.add(changedNotification);
          break;
        case 'UPDATE':
          int index = notifications.indexWhere((notification) => notification.id == changedNotification.id);
          if (index != -1) {
            notifications[index] = changedNotification;
          }
          break;
        case 'DELETE':
          notifications.removeWhere((notification) => notification.id == changedNotification.id);
          break;
        default:
          break;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _notificationService.unsubscribeFromNotificationChanges();
  }

  Future<void> _fetchNotifications() async {
    isLoading(true);
    try {
      UserModel user = _authService.getUser()!;
      final response = await _notificationService.readNotifications(user.id);
      notifications.value = response;
    } catch (e) {
      Log().e("Error while fetching notifications:", e);
    } finally {
      isLoading(false);
    }
  }

  void _subscribeToNotificationChanges() {
    UserModel user = _authService.getUser()!;
    _notificationService.subscribeToNotificationChanges(user.id, (eventType, changedNotification) {
      switch (eventType) {
        case 'INSERT':
          notifications.add(changedNotification);
          break;
        case 'UPDATE':
          int index = notifications.indexWhere((notif) => notif.id == changedNotification.id);
          if (index != -1) {
            notifications[index] = changedNotification;
          }
          break;
        case 'DELETE':
          notifications.removeWhere((notif) => notif.id == changedNotification.id);
          break;
        default:
          break;
      }
    });
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      notifications.removeWhere((notification) => notification.id == notificationId);
    } catch (e) {
      Log().e("Error while marking notification as read:", e);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      notifications.removeWhere((notification) => notification.id == notificationId);
    } catch (e) {
      Log().e("Error while deleting notification:", e);
    }
  }
}
