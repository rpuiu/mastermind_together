import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mastermind_together/src/services/log/logger_service.dart';

class AIService extends GetxService {
  String aiServiceUrl = dotenv.env['AI_SERVICE_URL']!;

  Future<String?> createNewThread() async {
    try {
      final response = await http.post(
        Uri.parse('$aiServiceUrl/create_thread'),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['thread_id'];
      } else {
        Log().e('Server error: ${response.statusCode}, ${response.body}');
      }
    } catch (e, s) {
      Log().e('Unable to query AI service due to error: ${e}', s);
    }
    return null;
  }

  Future<String?> sendMessage(String threadId, String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$aiServiceUrl/ask'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        },
        body: json.encode({
          'thread_id': threadId,
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        Log().e('Server error: ${response.statusCode}, ${response.body}');
      }
    } catch (e, s) {
      Log().e('Error sending message to AI service: ${e}', s);
    }
    return null;
  }
}
