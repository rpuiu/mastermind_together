import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/supa/message_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class MessageController extends GetxController {
  final String groupId = Get.parameters['groupId']!;
  final MessageService _messageService = Get.find<MessageService>();

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  final ScrollController scrollController = ScrollController();

  bool isFirstLoad = true;

  @override
  void onInit() {
    super.onInit();
    try {
      loadMessages(groupId);
      _messageService.subscribeToNewMessages(groupId, _onNewMessage);
    } catch (e) {
      showErrorSnackBar(message: "Unable to load messages");
    }
  }

  void _onNewMessage(MessageModel newMessage) {
    messages.add(newMessage);
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> loadMessages(String groupId) async {
    try {
      final fetchedMessages = await _messageService.getGroupMessages(groupId);
      messages.value = fetchedMessages;
    } catch (e) {
      showErrorSnackBar(message: "Unable to load new messages. $e");
    }
  }

  Future<void> sendMessage(String groupId, String userId, String sender, String content) async {
    try {
      await _messageService.sendMessage(groupId, userId, sender, content);
    } catch (e, s) {
      showErrorSnackBar(message: "Unable to send message. Please try again");
    }
  }

  @override
  void onClose() {
    _messageService.cancelSubscription();
    super.onClose();
  }
}
