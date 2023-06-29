import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class TimezoneService extends GetxService {
  List<String> getAllTimeZonesWithOffset() {
    final allLocations = tz.timeZoneDatabase.locations.keys.toList();
    List<String> allLocationsWithOffset = [];

    for(var locationName in allLocations) {
      final location = tz.getLocation(locationName);
      final currentTime = tz.TZDateTime.now(location);
      final offsetHours = currentTime.timeZoneOffset.inHours;
      final offsetMinutes = currentTime.timeZoneOffset.inMinutes.remainder(60);

      allLocationsWithOffset.add('UTC${offsetHours > 0 ? '+' : ''}$offsetHours:$offsetMinutes $locationName');
    }

    print('All timezones with offset: $allLocationsWithOffset');
    return allLocationsWithOffset;
  }


  Future<String> getCurrentTimezoneWithOffset() async {
    final currentTimeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    final currentTimezoneLocation = tz.getLocation(currentTimeZoneName);
    final currentTime = tz.TZDateTime.now(currentTimezoneLocation);
    final offsetHours = currentTime.timeZoneOffset.inHours;
    final offsetMinutes = currentTime.timeZoneOffset.inMinutes.remainder(60);

    final currentTimeZone = 'UTC${offsetHours > 0 ? '+' : ''}$offsetHours:$offsetMinutes $currentTimeZoneName';
    return currentTimeZone;
  }

}
