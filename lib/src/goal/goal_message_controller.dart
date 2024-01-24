import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/supa/goal_message_service.dart'; // Use GoalMessageService
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalMessageController extends GetxController {
  final String goalId;
  final GoalMessageService _goalMessageService = Get.find<GoalMessageService>(); // Use GoalMessageService

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxInt messageCount = 0.obs;

  bool isFirstLoad = true;

  GoalMessageController({required this.goalId});

  @override
  void onReady() async {
    super.onReady();
    try {
      loadMessages(goalId).then((_) async => await subscribeToNewMessages());
    } catch (e) {
      showErrorSnackBar(message: "Unable to load messages");
    }
  }

  Future<void> subscribeToNewMessages() async {
    _goalMessageService.subscribeToNewMessages(goalId, (newMessage) {
      // Use GoalMessageService
      messages.add(newMessage);
      messageCount.value++;
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

  @override
  void onClose() {
    _goalMessageService.cancelSubscription(); // Use GoalMessageService
    super.onClose();
  }
}
