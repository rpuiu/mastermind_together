import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:timezone/timezone.dart' as tz;

class TimezoneService extends GetxService {
  List<String> getAllTimeZonesWithOffset() {
    final allLocations = tz.timeZoneDatabase.locations.keys.toList();
    List<String> allLocationsWithOffset = [];

    for (var locationName in allLocations) {
      final location = tz.getLocation(locationName);
      final currentTime = tz.TZDateTime.now(location);
      final offsetHours = currentTime.timeZoneOffset.inHours;
      final offsetMinutes = currentTime.timeZoneOffset.inMinutes.remainder(60).abs();

      final minutesString = offsetMinutes < 10 ? '0$offsetMinutes' : '$offsetMinutes';

      allLocationsWithOffset.add('$locationName (UTC${offsetHours >= 0 ? '+' : ''}$offsetHours:$minutesString)');
    }

    return allLocationsWithOffset;
  }

  Future<String> getCurrentTimezoneWithOffset() async {
    final currentTimeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    final currentTimezoneLocation = tz.getLocation(currentTimeZoneName);
    final currentTime = tz.TZDateTime.now(currentTimezoneLocation);
    final offsetHours = currentTime.timeZoneOffset.inHours;
    final offsetMinutes = currentTime.timeZoneOffset.inMinutes.remainder(60).abs();

    final minutesString = offsetMinutes < 10 ? '0$offsetMinutes' : '$offsetMinutes';

    final currentTimeZone = '$currentTimeZoneName (UTC${offsetHours >= 0 ? '+' : ''}$offsetHours:$minutesString)';
    return currentTimeZone;
  }

  TimeOfDay? convertToUTC(TimeOfDay? time, String timezone) {
    if (time == null) return null;

    // Get the offset in minutes for the timezone.
    final offsetMinutes = _getOffsetMinutesForTimezone(timezone);

    // Convert the time to DateTime using today's date
    var dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);

    // Subtract the offset
    dateTime = dateTime.subtract(Duration(minutes: offsetMinutes));

    // Return the time part
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  TimeOfDay convertFromUTC(TimeOfDay utcTime, String timezone) {
    // Get the offset in minutes for the timezone.
    final offsetMinutes = "UTC (UTC+0:00)" == timezone ? 0 : _getOffsetMinutesForTimezone(timezone);

    // Convert the TimeOfDay to a DateTime object for today's date.
    var utcDate = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, utcTime.hour, utcTime.minute);

    // Add the offset
    utcDate = utcDate.add(Duration(minutes: offsetMinutes));

    // Return the time part
    return TimeOfDay(hour: utcDate.hour, minute: utcDate.minute);
  }

  int _getOffsetMinutesForTimezone(String timezone) {
    // Split the timezone string to get the offset part.
    final parts = timezone.split(' ');

    // Error checking: if there is no offset part in the input, throw an exception.
    if (parts.length < 2) {
      throw FormatException('The input timezone string does not contain an offset: $timezone');
    }

    // The second part is the offset part, not the first one.
    String offsetPart = parts[1];

    // Remove 'UTC' and parentheses from the start of the offsetPart
    if (offsetPart.startsWith('(UTC')) {
      offsetPart = offsetPart.substring(4);
      offsetPart = offsetPart.substring(0, offsetPart.length - 1); // Remove the closing parenthesis
    }

    // Split the offset part to get hours and minutes.
    final offsetParts = offsetPart.split(':');

    if (offsetParts.length != 2) {
      throw FormatException('Invalid timezone offset format: $offsetPart');
    }

    final offsetHours = double.tryParse(offsetParts[0])?.round();
    final offsetMinutes = double.tryParse(offsetParts[1])?.round();

    // Error checking: if parsing failed, throw an exception.
    if (offsetHours == null || offsetMinutes == null) {
      throw FormatException('Invalid timezone offset values: $offsetPart');
    }

    // Calculate the total offset in minutes.
    final totalOffsetMinutes = offsetHours * 60 + (offsetHours.isNegative ? -offsetMinutes : offsetMinutes);

    return totalOffsetMinutes;
  }

  TimeOfDay convertToLocalTime(TimeOfDay utcTime) {
    String userTimezone = Get.find<LocalStorageService>().getUser()!.timezone;
    TimeOfDay userTime = convertFromUTC(utcTime, userTimezone);
    return userTime;
  }

  TimeOfDay convertLocalTimeToUTC(TimeOfDay localTime) {
    String userTimezone = Get.find<LocalStorageService>().getUser()!.timezone;
    TimeOfDay utcTime = convertToUTC(localTime, userTimezone)!;
    return utcTime;
  }
}
