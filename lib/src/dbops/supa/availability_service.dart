import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailabilityService extends GetxService {
  final SupabaseClient _client = Get.find();

  AvailabilityService();

  Future<List<DayModel>> getAvailability(String userId) async {
    try {
      final List<dynamic> data = await _client.from('availability').select().eq('user_id', userId);

      // if (response.error != null) {
      //   throw Exception('Error fetching availability: ${response.error!.message}');
      // } //TODO handle errors

      return data.map((json) => DayModel.fromJson(json)).toList();
    } catch (e) {
      // Handle exception
      rethrow;
    }
  }

  Future<void> saveAvailability(String userId, DayModel dayModel) async {
    try {
      await _client.from('availability').upsert(
            dayModel.toJson()..['user_id'] = userId,
            onConflict: 'id',
          );
    } catch (e) {
      //TODO handle errors
      // Get.snackbar('Error', 'Error saving availability: $e',
      //     backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
      rethrow;
    }
  }
}
