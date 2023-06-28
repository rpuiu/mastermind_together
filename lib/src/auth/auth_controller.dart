import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/dbops/supa/auth_service.dart';
import 'package:mastermind_together/src/routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  Future<void> register(String email, String password) async {
    await _authService.signUp(email, password);
    Get.offAllNamed(Routes.login);
  }

  Future<void> login(String email, String password) async {
    await _authService.signInWithPassword(email, password);
    Get.offAllNamed(Routes.home);
  }

  Future<void> logout() async {
    await _authService.signOut();
    Get.snackbar('Success', 'Logged out successfully.');
    // Redirect to login page after logging out
    Get.offAll(LoginScreen());
  }
}
