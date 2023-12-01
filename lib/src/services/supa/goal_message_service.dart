import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalMessageService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  late RealtimeChannel _goalChatChannel;

  void subscribeToNewMessages(String goalId, void Function(MessageModel) onNewMessage) {
    try {
      _goalChatChannel = _client.channel('public:goal_messages:goal_id=eq.$goalId').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'INSERT', schema: 'public', table: 'goal_messages', filter: 'goal_id=eq.$goalId'),
        (payload, [ref]) {
          Log().i('Goal message received: ${payload.toString()}');
          MessageModel newMessage = MessageModel.fromJson(payload['new']);
          onNewMessage(newMessage);
        },
      );

      _goalChatChannel.subscribe();
    } catch (e, s) {
      Log().e("Error while subscribing to new messages in goal $goalId:", e, s);
      rethrow;
    }
  }

  Future<void> cancelSubscription() async {
    try {
      await _client.removeChannel(_goalChatChannel);
    } catch (e, s) {
      Log().e("Error while removing goal messages subscription: ", e, s);
    }
  }

  Future<List<MessageModel>> getGoalMessages(String goalId) async {
    try {
      final List<dynamic> response = await _client.from('goal_messages').select().eq('goal_id', goalId).order('timestamp', ascending: true);
      return response.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e, s) {
      Log().e("Error while fetching goal messages for goal $goalId:", e, s);
      rethrow;
    }
  }

  Future<void> sendMessage(String goalId, String userId, String sender, String content) async {
    try {
      await _client.from('goal_messages').insert({
        'goal_id': goalId,
        'user_id': userId,
        'sender': sender,
        'content': content,
      });
    } catch (e, s) {
      Log().e("Error while sending a message by $userId for goal $goalId:", e, s);
      rethrow;
    }
  }
}
