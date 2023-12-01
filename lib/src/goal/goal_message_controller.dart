import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/supa/goal_message_service.dart'; // Use GoalMessageService
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalMessageController extends GetxController {
  final String goalId;
  final GoalMessageService _goalMessageService = Get.find<GoalMessageService>(); // Use GoalMessageService

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  bool isFirstLoad = true;

  GoalMessageController({required this.goalId});

  @override
  void onInit() {
    super.onInit();
    try {
      loadMessages(goalId); // Load messages related to the goal
    } catch (e) {
      showErrorSnackBar(message: "Unable to load messages");
    }
  }

  void subscribeToNewMessages(ScrollController scrollController) {
    _goalMessageService.subscribeToNewMessages(goalId, (newMessage) { // Use GoalMessageService
      _onNewMessage(newMessage, scrollController);
    });
  }

  void _onNewMessage(MessageModel newMessage, ScrollController scrollController) {
    messages.add(newMessage);
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> loadMessages(String goalId) async {
    try {
      final fetchedMessages = await _goalMessageService.getGoalMessages(goalId);
      messages.value = fetchedMessages;
    } catch (e) {
      showErrorSnackBar(message: "Unable to load new messages. $e");
    }
  }

  Future<void> sendMessage(String goalId, String userId, String sender, String content) async { // Send goal message
    try {
      await _goalMessageService.sendMessage(goalId, userId, sender, content); // Use GoalMessageService
    } catch (e, s) {
      showErrorSnackBar(message: "Unable to send message. Please try again");
    }
  }

  @override
  void onClose() {
    _goalMessageService.cancelSubscription(); // Use GoalMessageService
    super.onClose();
  }
}
