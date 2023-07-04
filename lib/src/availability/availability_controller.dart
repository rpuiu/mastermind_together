import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/availability_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';

class AvailabilityController extends GetxController {
  final _availabilityService = Get.find<AvailabilityService>();
  final AuthService _authService = Get.find<AuthService>();
  final TimezoneService _tzService = Get.find<TimezoneService>();
  final UsersExtendedService _ueService = Get.find<UsersExtendedService>();
  final RxList<DayModel> days = RxList<DayModel>();

  final RxString selectedTimezone = ''.obs;
  final RxList<String> allTimezones = <String>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    initDays();
    fetchTimeZones();
    await fetchAvailability();
  }

  Future<void> fetchAvailability() async {
    final availability = await _availabilityService.getAvailability(_authService.getCurrentUser().id);

    // Replace the current days with the fetched data
    for (var day in availability) {
      final index = days.indexWhere((d) => d.dayName == day.dayName);
      if (index != -1) {
        var fetchedDay = DayModel.fromDayModel(day);

        // Convert the times from UTC to the user's timezone
        if (day.fromTime != null) {
          fetchedDay.fromTime = await _tzService.convertFromUTC(day.fromTime!, selectedTimezone.value);
        }
        if (day.toTime != null) {
          fetchedDay.toTime = await _tzService.convertFromUTC(day.toTime!, selectedTimezone.value);
        }

        days[index] = fetchedDay;
      }
    }
  }

  void saveAvailability() async {
    String userId = _authService.getCurrentUser().id;
    await _ueService.updateTimezone(userId, selectedTimezone.value);

    for (var day in days) {
      try {
        // Create a copy of the day model to avoid changing the times in the UI.
        var dayToSave = DayModel.fromDayModel(day);

        // Convert the times to UTC using the selected timezone.
        dayToSave.fromTime = await _tzService.convertToUTC(day.fromTime, selectedTimezone.value);
        dayToSave.toTime = await _tzService.convertToUTC(day.toTime, selectedTimezone.value);

        // If day.id is not null, set it to dayToSave.id
        if (day.id != null) {
          dayToSave.id = day.id;
        }

        await _availabilityService.saveAvailability(userId, dayToSave);
      } catch (e) {
        print(e);
        Get.snackbar('Error saving availability', e.toString(), snackPosition: SnackPosition.BOTTOM); //TODO refactor
      }
    }

    // Fetch current availability data after making updates
    await fetchAvailability();

    Get.snackbar('Success', 'Your availability has been updated', snackPosition: SnackPosition.BOTTOM);
  }

  void initDays() {
    final tempDays = List.generate(7, (index) => DayModel(dayName: getDayName(index)));
    days.addAll(tempDays);
  }

  void fetchTimeZones() async {
    final user = _authService.getCurrentUser();

    String dbTimezone = await _ueService.readTimezone(user.id);
    if (dbTimezone.isEmpty) {
      selectedTimezone.value = await _tzService.getCurrentTimezoneWithOffset();
      _ueService.updateTimezone(user.id, selectedTimezone.value);
    } else {
      selectedTimezone.value = dbTimezone;
    }

    allTimezones.value = _tzService.getAllTimeZonesWithOffset();
  }

  Future<bool> checkMatchingAvailability(String userId, GroupModel group) async {
    // Fetch user availability
    List<DayModel> availabilityList = await _availabilityService.getAvailability(userId);

    // Fetch group meeting time
    var groupMeetingTime = group.meetingTime;

    // Convert the group meeting time to user's local timezone
    var userTimezone = await _ueService.readTimezone(userId);
    TimeOfDay groupMeetingLocalTime = await _tzService.convertFromUTC(groupMeetingTime, userTimezone);

    // Get the day of the week of the meeting
    var meetingDay = group.meetingDay;

    // Find the availability for that day
    DayModel? dayAvailability = availabilityList.firstWhereOrNull((day) => day.dayName == meetingDay);

    // If there's no availability for that day, the group doesn't match
    if (dayAvailability == null) {
      return false;
    }

    // Convert the user's availability times to user's local timezone
    var fromTimeLocal = await _tzService.convertFromUTC(dayAvailability.fromTime!, userTimezone);
    var toTimeLocal = await _tzService.convertFromUTC(dayAvailability.toTime!, userTimezone);

    // If the group's meeting time is not within the user's availability time, the group doesn't match
    if (groupMeetingLocalTime.hour < fromTimeLocal.hour || groupMeetingLocalTime.hour > toTimeLocal.hour) {
      return false;
    }

    // The group's meeting time matches the user's availability
    return true;
  }
}
