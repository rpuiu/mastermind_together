import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_message_controller.dart';
import 'package:mastermind_together/src/groups/chat/chat_input_field.dart';
import 'package:mastermind_together/src/groups/chat/message_bubble_widget.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalChatWidget extends StatelessWidget {
  final String goalId;
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxBool showScrollButton = false.obs;

  GoalChatWidget({super.key, required this.goalId}) {
    Get.put(GoalMessageController(goalId: goalId), tag: goalId);
  }

  @override
  Widget build(BuildContext context) {
    final GoalMessageController controller = Get.find(tag: goalId);
    final ScrollController scrollController = controller.scrollController;

    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.position.pixels < scrollController.position.maxScrollExtent - 50) {
          // Show button if the user is 50 pixels away from the max scroll extent
          showScrollButton.value = true;
        } else {
          showScrollButton.value = false;
        }
      }
    });

    return Card(
      color: hoverMenuTextColor,
      shape: customBorder,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              } else {
                if (controller.isFirstLoad) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    controller.isFirstLoad = false;
                  });
                }

                return ListView.builder(
                  controller: scrollController,
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
          Obx(() => showScrollButton.value ? _buildScrollToBottomButton(scrollController) : SizedBox.shrink()),
          Container(
            padding: const EdgeInsets.all(fontSize / 2),
            child: Row(
              children: [
                Expanded(
                  child: ChatInputField(
                    controller: textController,
                    onSendPressed: () => _handleSendButtonPress(controller, scrollController),
                    focusNode: focusNode,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildScrollToBottomButton(ScrollController scrollController) {
    return FloatingActionButton(
      mini: true,
      elevation: 0,
      backgroundColor: hoverMenuTextColor,
      child: AppIcons.getIcon("arrowDownSquare", IconState.hoverState),
      onPressed: () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      },
    );
  }

  void _handleSendButtonPress(GoalMessageController controller, ScrollController scrollController) {
    // Modify the sendMessage call to match the goal message controller's method
    final user = authService.getUser();
    final trimmedText = textController.text.trim();
    if (trimmedText.isEmpty) return;

    if (user != null) {
      controller.sendMessage(goalId, user.id, user.username, trimmedText);
      textController.clear();
      if (scrollController.hasClients) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    } else {
      showErrorSnackBar(message: 'You are not logged in. Please log in to send a message.');
    }
  }
}
