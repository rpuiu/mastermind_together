import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DreamHostMailService {
  final String baseUrl = dotenv.env['DREAMHOST_EDGE_FUNCTION']!;
  final String token = dotenv.env['SUPABASE_ANON_KEY']!;

  DreamHostMailService();

  Future<bool> sendMail(Map<String, dynamic> data) async {
    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;  // Adjust as necessary based on the response from your server
    } else {
      throw Exception('Failed to send email. StatusCode: ${response.statusCode}');
    }
  }
}
