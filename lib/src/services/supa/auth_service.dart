import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  final UsersExtendedService _userExtendedService = Get.find<UsersExtendedService>();
  final TimezoneService _timezoneService = Get.find<TimezoneService>();

  //TODO handle errors //TODO wrap in UserModel
  User getCurrentUser() {
    final User? user = _client.auth.currentUser; //TODO user null?
    return user!;
  }

  Future<void> signUp(String email, String password) async {
    try {
      final AuthResponse response = await _client.auth.signUp(email: email, password: password);
      final User user = response.user!;

      String timezone = await _timezoneService.getCurrentTimezoneWithOffset();
      await _userExtendedService.createUserExtended(user.id, user.email!, timezone); //TODO move into controller.
    } on AuthException catch (err, s) {
      print(err);
      throw ('Failed to register $email: ${err.message}');
    } catch (err, s) {
      print(err);
      throw ('An unexpected error occurred when registering $email, please try again');
    }
  }

  Future<String> signInWithPassword(String email, String password) async {
    try {
      AuthResponse authResponse = await _client.auth.signInWithPassword(email: email, password: password);
      return authResponse.user!.id;
    } on AuthException catch (err, s) {
      print(err);
      throw ('Failed to login $email: ${err.message}');
    } catch (e, srr) {
      throw ('An unexpected error occurred when logging in $email, please try again');
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e, s) {
      print('$e $s');
      throw ('An error occurred: ${e.message}');
    } catch (e, s) {
      print('$e $s');
      throw ('An error occurred, please try again');
    }
  }
}
