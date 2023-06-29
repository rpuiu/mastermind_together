import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/dbops/supa/auth_service.dart';
import 'package:mastermind_together/src/dbops/supa/availability_service.dart';
import 'package:mastermind_together/src/dbops/supa/user_extended_service.dart';
import 'package:mastermind_together/src/timezone/timezone_service.dart';

class AvailabilityController extends GetxController {
  final _availabilityService = Get.find<AvailabilityService>();
  final AuthService _authService = Get.find<AuthService>();
  final TimezoneService _tzService = Get.find<TimezoneService>();
  final UserExtendedService _ueService = Get.find<UserExtendedService>();
  final RxList<DayModel> days = RxList<DayModel>();

  final RxString selectedTimezone = ''.obs;
  final RxList<String> allTimezones = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initDays();
    fetchTimeZones();
    fetchAvailability();
  }

  void fetchAvailability() async {
    final availability = await _availabilityService.getAvailability(_authService.getCurrentUser().id);

    // Replace the current days with the fetched data
    for (var day in availability) {
      final index = days.indexWhere((d) => d.dayName == day.dayName);
      if (index != -1) {
        days[index] = day;
      }
    }
  }

  void saveAvailability() async {
    String userId = _authService.getCurrentUser().id;
    await _ueService.updateTimezone(userId, selectedTimezone.value);
    for (var day in days) {
      try {
        await _availabilityService.saveAvailability(userId, day);
      } catch (e) {
        Get.snackbar('Error saving availability', e.toString(), snackPosition: SnackPosition.BOTTOM); //TODO refactor
      }
    }
    Get.snackbar('Success', 'Your availability has been updated', snackPosition: SnackPosition.BOTTOM);
  }

  void initDays() {
    final tempDays = List.generate(
      7,
      (index) => DayModel(
        dayName: DateFormat.E().format(DateTime(2022, 1, index + 1)), // Get weekday names
      ),
    );

    days.addAll(tempDays);
  }

  void fetchTimeZones() async {
    final user = _authService.getCurrentUser();

    String dbTimezone = await _ueService.readTimezone(user.id);
    if (dbTimezone.isEmpty) {
      selectedTimezone.value = await _tzService.getCurrentTimezoneWithOffset();
    } else {
      selectedTimezone.value = dbTimezone;
    }

    allTimezones.value = _tzService.getAllTimeZonesWithOffset();
  }
}
