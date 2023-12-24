import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/supa/goal_message_service.dart'; // Use GoalMessageService
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalMessageController extends GetxController {
  final String goalId;
  final GoalMessageService _goalMessageService = Get.find<GoalMessageService>(); // Use GoalMessageService
  final ScrollController scrollController = ScrollController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxInt messageCount = 0.obs;

  bool isFirstLoad = true;

  GoalMessageController({required this.goalId});

  @override
  void onInit() {
    super.onInit();
    try {
      loadMessages(goalId).then((_) => subscribeToNewMessages());
    } catch (e) {
      showErrorSnackBar(message: "Unable to load messages");
    }
  }

  Future<void> subscribeToNewMessages() async {
    _goalMessageService.subscribeToNewMessages(goalId, (newMessage) {
      // Use GoalMessageService
      messages.add(newMessage);
      messageCount.value++;
      SchedulerBinding.instance.addPostFrameCallback((_) => scrollToEnd());
    });
    await updateMessageCount();
  }

  Future<void> loadMessages(String goalId) async {
    try {
      final fetchedMessages = await _goalMessageService.getGoalMessages(goalId);
      messages.value = fetchedMessages;
      messageCount.value = fetchedMessages.length;
    } catch (e) {
      showErrorSnackBar(message: "Unable to load new messages. $e");
    }
  }

  Future<void> sendMessage(String goalId, String userId, String sender, String content) async {
    try {
      await _goalMessageService.sendMessage(goalId, userId, sender, content);
    } catch (e, s) {
      showErrorSnackBar(message: "Unable to send message. Please try again");
    }
  }

  Future<void> updateMessageCount() async {
    try {
      messageCount.value = await _goalMessageService.countGoalMessages(goalId);
    } catch (e) {
      showErrorSnackBar(message: "Unable to update message count");
    }
  }

  void scrollToEnd() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    _goalMessageService.cancelSubscription(); // Use GoalMessageService
    super.onClose();
  }
}
