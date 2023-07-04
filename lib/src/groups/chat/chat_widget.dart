import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_controller.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';

class ChatWidget extends GetView<MessageController> {
  final String groupId;
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController textController = TextEditingController();

  ChatWidget({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.messages.isEmpty) {
              return Center(child: Text('No messages yet.'));
            } else {
              return ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: '${message.sender}: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: message.content,
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(message.timestamp.toString()),
                  );
                },
              );
            }
          }),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  controller.sendMessage(
                    groupId,
                    authService.getCurrentUser().id,
                    authService.getCurrentUser().email!,
                    textController.text,
                  );
                  textController.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
