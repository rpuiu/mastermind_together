import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
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

  late final StreamSubscription<AuthState> _authStateSubscription;
  late String? role;

  @override
  void onInit() {
    super.onInit();
    _authStateSubscription = _client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        _localStorage.clear();
        Get.offAllNamed(Routes.login);
      }
    });
  }

  @override
  void onClose() {
    _authStateSubscription.cancel();
  }

  UserModel? getUser() {
    final user = _client.auth.currentUser;
    if (user != null) {
      return _localStorage.getUser();
    } else {
      return null;
    }
  }

  Future<UserModel> signUp(String username, String email, String password) async {
    String? tenantIdParam = Get.parameters['tenantId'];
    try {
      final AuthResponse response = await _client.auth.signUp(email: email, password: password);
      final User user = response.user!;

      String timezone = await _timezoneService.getCurrentTimezoneWithOffset();
      String tenantId;
      if (tenantIdParam == ":tenantId" || tenantIdParam == null) {
        tenantId = '3a4663f6-0e39-4095-b9aa-38449255910f'; //TODO remove this in production.
      } else {
        tenantId = tenantIdParam;
      }

      UserModel userModel = await _userExtendedService.createUserExtended(user.id, username, user.email!, timezone, tenantId);
      currentUser = userModel;
      _localStorage.saveUser(userModel);

      return userModel;
    } on AuthException catch (e, s) {
      Log().e("Error while registering $email:", e, s, tenantIdParam!);
      rethrow;
    } catch (e, s) {
      Log().e("An unexpected error occurred when registering $email", e, s, tenantIdParam!);
      rethrow;
    }
  }

  Future<UserModel> signInWithPassword(String email, String password) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(email: email, password: password);
      final User user = response.user!;
      _setRole(user);
      UserModel userModel = await _userExtendedService.readUserExtended(user.id);
      _localStorage.saveUser(userModel);
      currentUser = userModel;

      return userModel;
    } on AuthException catch (e, s) {
      Log().e("Error while authenticating [$email]:", e, s);
      rethrow;
    } catch (e, s) {
      Log().e("An unexpected error occured while authenticating $email:", e, s);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      currentUser = null;
    } on AuthException catch (e, s) {
      Log().e("Error while logging out ${currentUser!.id}:", e, s, currentUser!.tenantId);
      rethrow;
    } catch (e, s) {
      Log().e("An unexpected error occurred while logging out ${currentUser!.id}:", e, s, currentUser!.tenantId);
      rethrow;
    }
  }

  bool isUserLoggedIn() {
    User? supabaseUser = _client.auth.currentUser;
    UserModel? localStorageUser = _localStorage.getUser();
    return supabaseUser != null && localStorageUser != null;
  }

  updateUser(UserModel newUser) {
    try {
      // UserAttributes userAttributes = UserAttributes(email: newUser.email);
      // _client.auth.updateUser(userAttributes); //Changing the user's email will send an email to both email addresses.

      _userExtendedService.updateUser(newUser);
      _localStorage.saveUser(newUser);
      currentUser = newUser;
    } catch (e, s) {
      Log().e("An unexpected error occurred while updating your details out ${currentUser!.id}:", e, s, currentUser!.tenantId);
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword, String confirmNewPassword) async {
    try {
      if (newPassword != confirmNewPassword) {
        throw Exception("New password entries do not match");
      }

      final AuthResponse response = await _client.auth.signInWithPassword(email: currentUser!.email, password: oldPassword);
      final UserAttributes userAttributes = UserAttributes(password: newPassword);
      await _client.auth.updateUser(userAttributes);
    } on AuthException catch (e) {
      if (e.message == "Invalid login credentials") {
        throw const AuthException("Incorrect old password");
      }
    } catch (e, s) {
      Log().e("An error occurred while changing the password for user ${currentUser!.id}:", e, s, currentUser!.tenantId);
      rethrow;
    }
  }

  bool isTenant() {
    return role == 'tenant';
  }

  void _setRole(User user) {
    if (user.userMetadata != null) {
      role = user.userMetadata!['role'];
    } else {
      role = 'user';
    }
  }
}
