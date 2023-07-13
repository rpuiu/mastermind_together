import 'dart:convert';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String currentUser = 'currentUser';

  SharedPreferences prefs = Get.find<SharedPreferences>();

  void saveUser(UserModel userModel) {
    Map<String, dynamic> userJson = userModel.toJson();
    prefs.setString(currentUser, jsonEncode(userJson));
  }

  UserModel? getUser() {
    String? userJson = prefs.getString(currentUser);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  void clear() {
    prefs.clear();
  }
}
