import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/assistants/ai_message_model.dart';
import 'package:mastermind_together/src/services/ai/ai_service.dart';
import 'package:mastermind_together/src/services/supa/ai_messages_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class AssistantChatController extends GetxController {
  final AIService aiService = Get.find<AIService>();
  final AIMessageService aiMsgService = Get.find<AIMessageService>();
  final AuthService authService = Get.find<AuthService>();

  final String threadId = Get.parameters['id']!;

  final RxList<AIMessageModel> messages = <AIMessageModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isMessageLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      loadMessages();
    } catch (e) {
      showErrorSnackBar(message: "Unable to load messages");
    }
  }

  Future<void> loadMessages() async {
    try {
      final fetchedMessages = await aiMsgService.getUserMessages(threadId);
      messages.value = fetchedMessages;
    } catch (e) {
      showErrorSnackBar(message: "Unable to load new messages. $e");
    }
  }

  Future<String?> sendMessage(String trimmedText) async {
    isMessageLoading.value = true;
    try {
      String userId = authService.getUser()!.id;
      AIMessageModel message = await aiMsgService.save(userId, threadId, userId, trimmedText);
      String? response = await aiService.sendMessage(threadId, trimmedText);
      if (response != null) {
        AIMessageModel? aiMessageModel = await aiMsgService.save(userId, threadId, threadId, response);
      }
      return response;
    } catch (e) {
      showErrorSnackBar(message: "Unable to send message. Please try again.");
    } finally {
      isMessageLoading.value = false;
    }
  }

  void subscribeToNewMessages(ScrollController scrollController) {
    aiMsgService.subscribeToNewMessages(threadId, (message) {
      _onMessageReceived(message, scrollController);
    });
  }

  void _onMessageReceived(AIMessageModel message, ScrollController scrollController) {
    messages.add(message);
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void onClose() {
    aiMsgService.cancelSubscription();
    super.onClose();
  }
}
