import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/availability_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';

class AvailabilityController extends GetxController {
  final AvailabilityService _availabilityService = Get.find<AvailabilityService>();
  final AuthService _authService = Get.find<AuthService>();
  final TimezoneService _tzService = Get.find<TimezoneService>();
  final UsersExtendedService _ueService = Get.find<UsersExtendedService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final RxList<DayModel> days = RxList<DayModel>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  final RxString selectedTimezone = ''.obs;
  final RxList<String> allTimezones = <String>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _initDays();
    await _fetchTimeZones();
    await _fetchAvailability();
  }

  Future<bool> saveAvailability() async {
    UserModel? currentUser = _authService.getUser();
    if (currentUser == null) {
      return false;
    }

    try {
      await _updateTimezone(currentUser.id);
      for (var day in days) {
        await _saveDayAvailability(currentUser.id, day);
      }
      await _fetchAvailability();
    } catch (e, s) {
      Log().e("Error while subscribing to goal changes:", e, s);
      return false;
    }
    _analytics.track('AVAILABILITY_SET', properties: {
      'user': currentUser.toJson(),
      'availability': jsonEncode(days.map((day) => day.toJson()).toList()),
    });

    return true;
  }

  Future<bool> checkMatchingAvailability(String userId, GroupModel group) async {
    List<DayModel> availabilityList = await _availabilityService.getAvailability(userId);

    // Find the availability for that day
    var meetingDay = group.meetingDay;
    DayModel? dayAvailability = availabilityList.firstWhereOrNull((day) => day.dayName == meetingDay);

    // If there's no availability for that day, the group doesn't match
    if (dayAvailability == null || dayAvailability.fromTime == null || dayAvailability.toTime == null) {
      return false;
    }

    // User's availability times are in UTC
    var fromTimeUTC = dayAvailability.fromTime!;
    var toTimeUTC = dayAvailability.toTime!;

    TimeOfDay groupMeetingTimeUTC = group.meetingTimeUTC;

    // Subtract 30 minutes from the user's end time
    TimeOfDay endTimeMinus30 = _subtract30Min(toTimeUTC);

    // If the group's meeting time is not within the user's availability time, the group doesn't match
    return _isMeetingWithinAvailability(fromTimeUTC, endTimeMinus30, groupMeetingTimeUTC);
  }

  Future<void> _fetchAvailability() async {
    UserModel? user = _authService.getUser();
    if (user == null) {
      showErrorSnackBar(message: 'Please login to fetch availability');
      return;
    }
    List<DayModel> availability;
    try {
      availability = await _availabilityService.getAvailability(user.id);
    } catch (e, s) {
      Log().e("Unable to fetch availability: ", e, s);
      return;
    }
    _updateAvailabilityWithFetchedData(availability);
  }

  void _updateAvailabilityWithFetchedData(List<DayModel> availability) {
    for (var day in availability) {
      if (day.fromTime != null && day.toTime != null) {
        Log().d("Updating availability: ${day.fromTime} ${day.toTime}");
        final index = days.indexWhere((d) => d.dayName == day.dayName);
        if (index != -1) {
          days[index] = _convertDayTimesFromUTC(day, selectedTimezone.value);
        }
      }
    }
  }

  DayModel _convertDayTimesFromUTC(DayModel day, String timezone) {
    if (day.fromTime != null) {
      day.fromTime = _tzService.convertFromUTC(day.fromTime!, timezone);
    }
    if (day.toTime != null) {
      day.toTime = _tzService.convertFromUTC(day.toTime!, timezone);
    }
    return day;
  }

  Future<void> _saveDayAvailability(String userId, DayModel day) async {
    // Create a copy of the day model to avoid changing the times in the UI.
    var dayToSave = DayModel.fromDayModel(day);

    // Convert the times to UTC using the selected timezone.
    dayToSave.fromTime = _tzService.convertToUTC(day.fromTime, selectedTimezone.value);
    dayToSave.toTime = _tzService.convertToUTC(day.toTime, selectedTimezone.value);

    // If day.id is not null, set it to dayToSave.id
    if (day.id != null) {
      dayToSave.id = day.id;
    }

    await _availabilityService.saveAvailability(userId, dayToSave);
  }

  void _initDays() {
    final tempDays = List.generate(7, (index) => DayModel(dayName: getDayName(index)));
    days.addAll(tempDays);
  }

  Future<void> _fetchTimeZones() async {
    UserModel? user = _authService.getUser();
    if (user == null) {
      showErrorSnackBar(message: 'Please login to fetch timezones');
      return;
    }
    try {
      String dbTimezone = await _ueService.readTimezone(user.id);
      if (dbTimezone.isEmpty) {
        selectedTimezone.value = await _tzService.getCurrentTimezoneWithOffset();
        await _updateTimezone(user.id);
      } else {
        selectedTimezone.value = dbTimezone;
      }
      allTimezones.value = _tzService.getAllTimeZonesWithOffset();
    } catch (e) {
      showErrorSnackBar(message: 'Unable to fetch your timezone. Please try again');
    }
  }

  Future<void> _updateTimezone(String userId) async {
    try {
      UserModel updatedUser = await _ueService.updateTimezone(userId, selectedTimezone.value);
      _localStorage.saveUser(updatedUser);
    } catch (e) {
      showErrorSnackBar(message: 'Unable to update your timezone. Please try again');
    }
  }

  TimeOfDay _subtract30Min(TimeOfDay time) {
    int newMinute = time.minute - 30;
    int newHour = time.hour;
    if (newMinute < 0) {
      newHour -= 1;
      newMinute += 60;
    }
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  bool _isMeetingWithinAvailability(TimeOfDay fromTime, TimeOfDay endTimeMinus30, TimeOfDay meetingTime) {
    return !(meetingTime.hour < fromTime.hour ||
        (meetingTime.hour == fromTime.hour && meetingTime.minute < fromTime.minute) ||
        meetingTime.hour > endTimeMinus30.hour ||
        (meetingTime.hour == endTimeMinus30.hour && meetingTime.minute > endTimeMinus30.minute));
  }
}
