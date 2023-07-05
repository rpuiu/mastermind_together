import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  Future<void> register(String email, String password) async {
    try {
      await _authService.signUp(email, password);
      showSuccessSnackBar(message: 'Congratulations, your account has been successfully created');
      Get.offAllNamed(Routes.login);
    } catch (e, s) {
      showErrorSnackBar(message: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _authService.signInWithPassword(email, password);
      showSuccessSnackBar(message: 'Logged in successfully');
      Get.offAllNamed(Routes.home);
    } catch (e, s) {
      showErrorSnackBar(message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      showSuccessSnackBar(message: 'Logged out successfully');
      Get.offAll(LoginScreen());
    } catch (e, s) {
      showErrorSnackBar(message: e.toString());
    }
  }
}
