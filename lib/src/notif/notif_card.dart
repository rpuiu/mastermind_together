import 'package:flutter/material.dart';
import 'package:mastermind_together/src/notif/notif_controller.dart';
import 'package:mastermind_together/src/notif/notif_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final NotificationController controller;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Type: ${notification.type}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (notification.readStatus)
                    const Text(
                      'Status: Read',
                      style: TextStyle(color: Colors.green),
                    )
                  else
                    const Text(
                      'Status: Unread',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller.markAsRead(notification.id);
                  },
                  child: const Text('Mark as Read'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await controller.deleteNotification(notification.id);
                  },
                  child: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
