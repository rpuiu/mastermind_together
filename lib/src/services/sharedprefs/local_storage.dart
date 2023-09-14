import 'dart:convert';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/onboarding/onboarding_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String currentUser = 'currentUser';
  static const String onboardingSeen = 'onboardingSeen';
  static const String onboardingStep = 'onboardingStep';
  static const String originalRouteKey = 'originalRoute';

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

  void setOnboardingStep(OnboardingStep step) {
    final stepStr = step.toString().split('.').last;
    prefs.setString(onboardingStep, stepStr);
  }

  OnboardingStep? getOnboardingStep() {
    final stepStr = prefs.getString(onboardingStep);
    if (stepStr == null) return null;
    return OnboardingStep.values.firstWhere((e) => e.toString().split('.').last == stepStr);
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
}
