import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class AnalyticsService {
  final Mixpanel _mixpanel = Get.find<Mixpanel>();

  AnalyticsService();

  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    _mixpanel.track(eventName, properties: properties);
  }

  Future<void> setUserProperties(String userId, String key, String value) async {
    identify(userId);
    _mixpanel.getPeople().set(key, value);
  }

  void identify(String userId) {
    _mixpanel.identify(userId);
  }

  Future<void> flushData() async {
    await _mixpanel.flush();
  }
}
