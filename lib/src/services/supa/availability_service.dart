import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailabilityService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  AvailabilityService();

  Future<List<DayModel>> getAvailability(String userId) async {
    try {
      final List<dynamic> data = await _client.from('availability').select().eq('user_id', userId);
      return data.map((json) => DayModel.fromJson(json)).toList();
    } catch (e, s) {
      Log().e("Error getting availability for $userId:", e, s);
      rethrow;
    }
  }

  Future<void> saveAvailability(String userId, DayModel dayModel) async {
    try {
      final response = await _availabilityExists(userId, dayModel);
      if (response == null) {
        await _insertAvailability(dayModel, userId);
      } else {
        await _updateAvailability(dayModel, userId);
      }
    } catch (e, s) {
      Log().e("Error setting availability for $userId:", e, s);
      return;
    }
  }

  Future<void> _updateAvailability(DayModel dayModel, String userId) async {
    try {
      await _client.from('availability').update(dayModel.toJson()..['user_id'] = userId).eq('user_id', userId).eq('day', dayModel.dayName);
    } catch (e, s) {
      Log().e("Error while updating availabilty for $userId: ", e, s);
      rethrow;
    }
  }

  Future<dynamic> _insertAvailability(DayModel dayModel, String userId) async {
    try {
      return await _client.from('availability').insert(dayModel.toJson()..['user_id'] = userId);
    } catch (e, s) {
      Log().e("Error while inserting availability of $userId", e, s);
      rethrow;
    }
  }

  Future<dynamic> _availabilityExists(String userId, DayModel dayModel) async {
    try {
      return await _client.from('availability').select().eq('user_id', userId).eq('day', dayModel.dayName).maybeSingle();
    } catch (e, s) {
      Log().e("Error while checking if $userId is available: ", e, s);
      rethrow;
    }
  }
}
