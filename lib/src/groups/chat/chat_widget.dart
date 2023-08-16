import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/chat_input_field.dart';
import 'package:mastermind_together/src/groups/chat/message_bubble_widget.dart';
import 'package:mastermind_together/src/groups/chat/message_controller.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class ChatWidget extends GetView<MessageController> {
  final String groupId;
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController textController = TextEditingController();

  ChatWidget({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: menuBtnColor,
      shape: customBorder,
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              } else {
                // If it's the first load of the chat, scroll to the latest message
                if (controller.isFirstLoad) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.scrollController.jumpTo(controller.scrollController.position.maxScrollExtent);
                  });
                  controller.isFirstLoad = false;
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isMe = authService.getUser()?.id == message.userId;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              }
            }),
          ),
          Container(
            padding: const EdgeInsets.all(fontSize / 2),
            child: Row(
              children: [
                Expanded(
                  child: ChatInputField(controller: textController, onSendPressed: _handleSendButtonPress),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendButtonPress() {
    final user = authService.getUser();
    final trimmedText = textController.text.trim();
    if (trimmedText.isEmpty) {
      // showErrorSnackBar(message: 'Message cannot be empty.');
      return;
    }
    if (user != null) {
      controller.sendMessage(groupId, user.id, user.username, trimmedText);
      textController.clear();
      controller.scrollController.jumpTo(controller.scrollController.position.maxScrollExtent);
    } else {
      showErrorSnackBar(message: 'You are not logged in. Please log in to send a message.');
    }
  }
}
