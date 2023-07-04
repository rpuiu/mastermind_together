import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/chat/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  late RealtimeChannel _chatChannel;

  void subscribeToNewMessages(String groupId, void Function(MessageModel) onNewMessage) {
    _chatChannel = _client.channel('public:messages:group_id=eq.$groupId').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'INSERT', schema: 'public', table: 'messages'),
      (payload, [ref]) {
        print('Message received: ${payload.toString()}');
        MessageModel newMessage = MessageModel.fromJson(payload['new']);
        onNewMessage(newMessage);
      },
    );

    _chatChannel.subscribe();
  }

  Future<void> cancelSubscription() async {
    await _client.removeChannel(_chatChannel);
  }

  Future<List<MessageModel>> getGroupMessages(String groupId) async {
    final List<dynamic> response = await _client.from('messages').select().eq('group_id', groupId).order('timestamp', ascending: true);

    // if (response.error != null) {
    //   throw Exception('Failed to load messages: ${response.error!.message}');
    // }

    return response.map((json) => MessageModel.fromJson(json)).toList();
  }

  Future<void> sendMessage(String groupId, String userId, String sender, String content) async {
    final response = await _client.from('messages').insert({
      'group_id': groupId,
      'user_id': userId,
      'sender': sender,
      'content': content,
    });

    // if (response.error != null) {
    //   throw Exception('Failed to send message: ${response.error!.message}');
    // }
  }
}
