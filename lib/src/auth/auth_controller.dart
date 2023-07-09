import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final UsersExtendedService _userExtendedService = Get.find<UsersExtendedService>();

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
      String userId = _authService.getCurrentUser().id; //Throws exception if the user is null

      showSuccessSnackBar(message: 'Logged in successfully');

      String timezone = await _userExtendedService.readTimezone(userId);
      _localStorage.saveUserTimezone(timezone);
      Get.offAllNamed(Routes.home);
    } catch (e, s) {
      showErrorSnackBar(message: e.toString());
      logout();
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
