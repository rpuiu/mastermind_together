import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  late RealtimeChannel _chatChannel;

  void subscribeToNewMessages(String groupId, void Function(MessageModel) onNewMessage) {
    try {
      _chatChannel = _client.channel('public:messages:group_id=eq.$groupId').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'INSERT', schema: 'public', table: 'messages', filter: 'group_id=eq.$groupId'),
        (payload, [ref]) {
          Log().i('Message received: ${payload.toString()}');
          MessageModel newMessage = MessageModel.fromJson(payload['new']);
          onNewMessage(newMessage);
        },
      );

      _chatChannel.subscribe();
    } catch (e, s) {
      Log().e("Error while subscribing to new messages in $groupId:", e, s);
      rethrow;
    }
  }

  Future<void> cancelSubscription() async {
    try {
      await _client.removeChannel(_chatChannel);
    } catch (e, s) {
      Log().e("Error while removing messages subscription: ", e, s);
    }
  }

  Future<List<MessageModel>> getGroupMessages(String groupId) async {
    try {
      final List<dynamic> response = await _client.from('messages').select().eq('group_id', groupId).order('timestamp', ascending: true);
      return response.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e, s) {
      Log().e("Error while fetching group messages:", e, s);
      rethrow;
    }
  }

  Future<void> sendMessage(String groupId, String userId, String sender, String content) async {
    try {
      await _client.from('messages').insert({
        'group_id': groupId,
        'user_id': userId,
        'sender': sender,
        'content': content,
      });
    } catch (e, s) {
      Log().e("Error while sending a message by $userId in $groupId:", e, s);
      rethrow;
    }
  }
}
