import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mastermind_together/src/assistants/ai_message_model.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/util/color_util.dart';

class AIMessageBubble extends StatelessWidget {
  final TimezoneService _tzService = Get.find<TimezoneService>();

  final AIMessageModel message;
  final bool isMe;

  AIMessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final localTime = _tzService.convertUTCDateTimeToLocalZone(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(right: fontSize),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.grey[300],
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(0),
                  ),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Text(
                  'Serenity Guide',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getColorFromUsername('Serenity Guide'),
                  ),
                ),
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                DateFormat('h:mm a').format(localTime),
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
