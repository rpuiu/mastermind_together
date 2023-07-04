import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailabilityService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

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
      final response = await availabilityExists(userId, dayModel);

      if (response == null) {
        await insertAvailability(dayModel, userId);
      } else {
        await updateAvailability(dayModel, userId);
      }
    } catch (e) {
      //TODO handle errors
      // Get.snackbar('Error', 'Error saving availability: $e',
      //     backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
      rethrow;
    }
  }

  Future<void> updateAvailability(DayModel dayModel, String userId) async {
    await _client.from('availability').update(dayModel.toJson()..['user_id'] = userId).eq('user_id', userId).eq('day', dayModel.dayName);
  }

  Future<dynamic> insertAvailability(DayModel dayModel, String userId) async =>
      await _client.from('availability').insert(dayModel.toJson()..['user_id'] = userId);

  Future<dynamic> availabilityExists(String userId, DayModel dayModel) async =>
      await _client.from('availability').select().eq('user_id', userId).eq('day', dayModel.dayName).maybeSingle();
}
