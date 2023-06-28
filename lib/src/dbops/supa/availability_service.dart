import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:supabase/supabase.dart';

class AvailabilityService extends GetxService {
  final SupabaseClient _client = Get.find();

  AvailabilityService();

  Future<void> createAvailability(String userId, DayModel day) async {
    final Map<String, dynamic> data = day.toJson(); // Convert the day model to JSON
    data['user_id'] = userId; // Add the userId to the data

    final response = await _client.from('availability').insert(data);

    // if (response.error != null) {
    //   throw Exception('Failed to create availability: ${response.error!.message}');
    // } //TODO treat errors and show snackbar when success!
  }
}
