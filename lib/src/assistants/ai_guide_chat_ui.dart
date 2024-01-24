import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/assistants/ai_message_bubble_widget.dart';
import 'package:mastermind_together/src/assistants/assistant_chat_controller.dart';
import 'package:mastermind_together/src/assistants/loading_bubble.dart';
import 'package:mastermind_together/src/groups/chat/chat_input_field.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class AIGuideChatWidget extends GetView<AssistantChatController> {
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxBool showScrollButton = false.obs;

  AIGuideChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    controller.subscribeToNewMessages(scrollController);

    // Listener for scroll position changes
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
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              } else {
                if (controller.isLoading.value) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    controller.isLoading.value = false;
                  });
                } else {
                  _scrollToEnd(scrollController);
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isMe = authService.getUser()?.id == message.sender;
                    return AIMessageBubble(message: message, isMe: isMe);
                  },
                );
              }
            }),
          ),
          Obx(() {
            if (controller.isMessageLoading.value) {
              return const LoadingBubble();
            } else {
              return const SizedBox();
            }
          }),
          Obx(
            () => showScrollButton.value ? _buildScrollToBottomButton(scrollController) : const SizedBox.shrink(),
          ),
          Container(
            padding: const EdgeInsets.all(fontSize / 2),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () {
                      return ChatInputField(
                        controller: textController,
                        onSendPressed: () => _handleSendButtonPress(scrollController),
                        focusNode: focusNode,
                        enabled: !controller.isMessageLoading.value,
                      );
                    },
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

  void _handleSendButtonPress(ScrollController scrollController) {
    final user = authService.getUser();
    final trimmedText = textController.text.trim();
    if (trimmedText.isEmpty) {
      return;
    }
    if (user != null) {
      controller.sendMessage(trimmedText);
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

  void _scrollToEnd(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
