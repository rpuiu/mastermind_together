import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/notif/notif_card.dart';
import 'package:mastermind_together/src/notif/notif_controller.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: <Widget>[
          xHalfSpace,
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Notifications", style: headingText),
            ],
          ),
          xHalfSpace,
          _buildNotificationList(),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.notifications.isEmpty) {
        return const Center(
          child: Text('No notifications available.'),
        );
      }

      return Flexible(
        child: ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return NotificationCard(
              notification: controller.notifications[index],
              controller: controller,
            );
          },
        ),
      );
    });
  }
}
