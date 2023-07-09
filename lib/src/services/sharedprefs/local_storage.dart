import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userTimeZone = 'userTimezone';

  SharedPreferences prefs = Get.find<SharedPreferences>();

  Future<void> saveUserTimezone(String userTimezone) async {
    await prefs.setString(userTimeZone, userTimezone);
  }

  String getUserTimezone() {
    return prefs.getString(userTimeZone) ?? '';
  }
}
