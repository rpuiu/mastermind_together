import 'dart:convert';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String currentUser = 'currentUser';
  static const String originalRouteKey = 'originalRoute';
  static const String tenant = 'tenant';

  SharedPreferences prefs = Get.find<SharedPreferences>();

  Future<void> saveUser(UserModel userModel) async {
    Map<String, dynamic> userJson = userModel.toJson();
    await prefs.setString(currentUser, jsonEncode(userJson));
  }

  UserModel? getUser() {
    String? userJson = prefs.getString(currentUser);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  removeUser() async {
    await prefs.remove(currentUser);
  }

  Future<void> clear() async {
    await prefs.clear();
  }

  void setOriginalRoute(String route) async {
    await prefs.setString(originalRouteKey, route);
  }

  String? getOriginalRoute() {
    return prefs.getString(originalRouteKey);
  }

  void clearOriginalRoute() async {
    await prefs.remove(originalRouteKey);
  }

  Future<void> setLogoUrl(String url, bool isLight) async {
    String key = isLight ? 'lightLogoUrl' : 'darkLogoUrl';
    await prefs.setString(key, url);
  }

  String? getLogoUrl(bool isLight) {
    String key = isLight ? 'lightLogoUrl' : 'darkLogoUrl';
    return prefs.getString(key);
  }

  Future<void> setTenant(String tenantJson) async {
    await prefs.setString(tenant, tenantJson);
  }

  String? getTenant() {
    return prefs.getString(tenant);
  }
}
