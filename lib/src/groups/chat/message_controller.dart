import 'package:get/get.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/supa/message_service.dart';

class MessageController extends GetxController {
  final String groupId = Get.parameters['groupId']!;
  final MessageService _messageService = Get.find<MessageService>();

  final RxList<MessageModel> messages = <MessageModel>[].obs;

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
