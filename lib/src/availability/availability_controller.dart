import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
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
    List<DayModel> availability;
    try {
      String userId = _authService.getCurrentUser().id;
      availability = await _availabilityService.getAvailability(userId);
    } catch (e, s) {
      showErrorSnackBar(message: 'Error fetching availability: ${e.toString()}');
      return;
    }

    // Replace the current days with the fetched data
    for (var day in availability) {
      //TODO refactor!
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
    try {
      String userId = _authService.getCurrentUser().id;
      await _ueService.updateTimezone(userId, selectedTimezone.value);

      for (var day in days) {
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
      }

      // Fetch current availability data after making updates
      await fetchAvailability();
    } catch (e, s) {
      print('$e $s');;
      showErrorSnackBar(message: 'Error saving availability: ${e.toString()}');
    }
    showSuccessSnackBar(message: 'Your availability has been updated');
  }

  void initDays() {
    final tempDays = List.generate(7, (index) => DayModel(dayName: getDayName(index)));
    days.addAll(tempDays);
  }

  void fetchTimeZones() async {
    try {
      final user = _authService.getCurrentUser();

      String dbTimezone = await _ueService.readTimezone(user.id);
      if (dbTimezone.isEmpty) {
        selectedTimezone.value = await _tzService.getCurrentTimezoneWithOffset();
        _ueService.updateTimezone(user.id, selectedTimezone.value);
      } else {
        selectedTimezone.value = dbTimezone;
      }

      allTimezones.value = _tzService.getAllTimeZonesWithOffset();
    } catch (e, s) {
      showErrorSnackBar(message: 'Unable to fetch your timezone. Please try again');
    }
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
    DayModel? dayAvailability = availabilityList.firstWhereOrNull((day) => day.dayName == meetingDay); //TODO day.fromTime?

    // If there's no availability for that day, the group doesn't match
    if (dayAvailability == null || dayAvailability.fromTime == null || dayAvailability.toTime == null) {
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
