import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  final UsersExtendedService _userExtendedService = Get.find<UsersExtendedService>();
  final TimezoneService _timezoneService = Get.find<TimezoneService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  UserModel? get currentUser => _currentUser.value;

  set currentUser(UserModel? user) => _currentUser.value = user;

  UserModel getCurrentUser() {
    User? user = _client.auth.currentUser;
    if (user != null) {
      String timezone = _localStorage.getUserTimezone();
      return UserModel(id: user.id, email: user.email!, timezone: timezone);
    } else {
      throw Exception('User is unexpectedly null.');
    }
  }

  Future<UserModel> signUp(String email, String password) async {
    try {
      final AuthResponse response = await _client.auth.signUp(email: email, password: password);
      final User user = response.user!;

      String timezone = await _timezoneService.getCurrentTimezoneWithOffset();
      await _userExtendedService.createUserExtended(user.id, user.email!, timezone);

      UserModel userModel = UserModel(id: user.id, email: user.email!, timezone: timezone);

      currentUser = userModel;
      return userModel;
    } on AuthException catch (err, s) {
      print(err);
      throw ('Failed to register $email: ${err.message}');
    } catch (err, s) {
      print(err);
      throw ('An unexpected error occurred when registering $email, please try again');
    }
  }

  Future<UserModel> signInWithPassword(String email, String password) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(email: email, password: password);
      final User user = response.user!;

      String timezone = await _userExtendedService.readTimezone(user.id);

      UserModel userModel = UserModel(id: user.id, email: user.email!, timezone: timezone);
      currentUser = userModel;

      return userModel;
    } on AuthException catch (err, s) {
      print(err);
      throw ('Failed to login $email: ${err.message}');
    } catch (err, s) {
      print(err);
      throw ('An unexpected error occurred when logging in $email, please try again');
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      currentUser = null;
    } on AuthException catch (e, s) {
      print('$e $s');
      throw ('An error occurred: ${e.message}');
    } catch (e, s) {
      print('$e $s');
      throw ('An error occurred, please try again');
    }
  }
}
