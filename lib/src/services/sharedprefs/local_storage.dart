import 'dart:convert';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String currentUser = 'currentUser';
  static const String onboardingSeen = 'onboardingSeen';

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

  Future<void> completeOnboarding() async {
    await prefs.setBool(onboardingSeen, true);
  }

  bool isOnboardingComplete() {
    return prefs.getBool(onboardingSeen) ?? false;
  }
}
