import 'package:get/get.dart';
import 'package:mastermind_together/src/dbops/supa/message_service.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';

class MessageController extends GetxController {
  final String groupId = Get.parameters['groupId']!;
  final MessageService _messageService = Get.find<MessageService>();

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages(groupId);
    _messageService.subscribeToNewMessages(groupId, _onNewMessage);
  }

  void _onNewMessage(MessageModel newMessage) {
    messages.add(newMessage);
  }

  Future<void> loadMessages(String groupId) async {
    try {
      final fetchedMessages = await _messageService.getGroupMessages(groupId);
      messages.value = fetchedMessages;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> sendMessage(String groupId, String userId, String sender, String content) async {
    try {
      await _messageService.sendMessage(groupId, userId, sender, content);
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  void onClose() {
    _messageService.cancelSubscription();
    super.onClose();
  }
}
