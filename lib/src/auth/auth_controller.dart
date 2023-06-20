import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/home/home_screen.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:supabase/supabase.dart';

class AuthController extends GetxController {
  final SupabaseClient _client;

  AuthController(this._client);

  Future<void> register(String email, String password) async {
    final AuthResponse response = await _client.auth.signUp(email: email, password: password);

    // if (response.error != null) {
    //   Get.snackbar('Error', response.error!.message);
    // } else if (response.data != null) {
    //   Get.snackbar('Success', 'Registered successfully. Please check your email for verification.');
    // }
    Get.offAllNamed(Routes.login);

  }

  Future<void> login(String email, String password) async {
    final AuthResponse response = await _client.auth.signInWithPassword(email: email, password: password);

    // if (response.error != null) {
    //   Get.snackbar('Error', response.error!.message);
    // } else if (response.data != null) {
    Get.snackbar('Success', 'Logged in successfully.');
    // You can use Get.offAll() to navigate to a new screen and remove all previous routes.
    Get.offAllNamed(Routes.home);
    // }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    Get.snackbar('Success', 'Logged out successfully.');
    // Redirect to login page after logging out
    Get.offAll(LoginScreen());
  }
}
