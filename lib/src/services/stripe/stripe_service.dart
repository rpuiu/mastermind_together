import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StripeService {
  final String baseUrl = dotenv.env['STRIPE_CHECKOUT_EDGE_FUNCTION']!;
  final String token = dotenv.env['SUPABASE_ANON_KEY']!;

  StripeService();

  Future<String> checkout(Map<String, dynamic> data) async {
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
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['url']; // Assuming the edge function returns a URL
    } else {
      // Optionally parse error message from response
      throw Exception('Failed to create Stripe Checkout. StatusCode: ${response.statusCode}. Message: ${response.body}');
    }
  }
}
