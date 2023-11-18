import 'package:get/get.dart';
import 'package:mastermind_together/src/assistants/ai_message_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AIMessageService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  late RealtimeChannel _chatChannel;

  void subscribeToNewMessages(String threadId, void Function(AIMessageModel) onMessageReceived) {
    try {
      _chatChannel = _client.channel('public:ai_messages:user_thread_id=eq.$threadId').on(
          RealtimeListenTypes.postgresChanges, ChannelFilter(event: 'INSERT', schema: 'public', table: 'ai_messages', filter: 'user_thread_id=eq.$threadId'),
          (payload, [ref]) {
        Log().i('Message created or updated: ${payload.toString()}');
        AIMessageModel message = AIMessageModel.fromJson(payload['new']);
        onMessageReceived(message);
      }).on(RealtimeListenTypes.postgresChanges, ChannelFilter(event: 'UPDATE', schema: 'public', table: 'ai_messages', filter: 'user_thread_id=eq.$threadId'),
          (payload, [ref]) {
        Log().i('Message created or updated: ${payload.toString()}');
        AIMessageModel message = AIMessageModel.fromJson(payload['new']);
        onMessageReceived(message);
      });

      _chatChannel.subscribe();
    } catch (e, s) {
      Log().e("Error while subscribing to new messages in $threadId:", e, s);
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

  Future<AIMessageModel> save(String userId, String userThreadId, String sender, String content) async {
    try {
      final response = await _client.from('ai_messages').insert({
        'user_thread_id': userThreadId,
        'user_id': userId,
        'sender': sender,
        'content': content,
      }).select();
      return AIMessageModel.fromJson(response[0]);
    } catch (e, s) {
      Log().e("Error while saving a message on thread $userThreadId:", e, s);
      rethrow;
    }
  }

  Future<List<AIMessageModel>> getUserMessages(String threadId) async {
    try {
      final List<dynamic> response = await _client.from('ai_messages').select().eq('user_thread_id', threadId).order('timestamp', ascending: true);
      return response.map((json) => AIMessageModel.fromJson(json)).toList();
    } catch (e, s) {
      Log().e("Error while fetching group messages:", e, s);
      rethrow;
    }
  }
}
