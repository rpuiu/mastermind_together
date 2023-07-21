import 'dart:async';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/routes.dart';
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
    try {
      final AuthResponse response = await _client.auth.signUp(email: email, password: password);
      final User user = response.user!;

      String timezone = await _timezoneService.getCurrentTimezoneWithOffset();
      String tenantId;
      String? tenantIdParam = Get.parameters['tenantId'];
      if (tenantIdParam == ":tenantId" || tenantIdParam == null) {
        tenantId = '3a4663f6-0e39-4095-b9aa-38449255910f'; //TODO remove this in production.
      } else {
        tenantId = tenantIdParam;
      }

      UserModel userModel = await _userExtendedService.createUserExtended(user.id, username, user.email!, timezone, tenantId);
      currentUser = userModel;
      _localStorage.saveUser(userModel);

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
      UserModel userModel = await _userExtendedService.readUserExtended(user.id);
      _localStorage.saveUser(userModel);
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

  bool isUserLoggedIn() {
    User? supabaseUser = _client.auth.currentUser;
    UserModel? localStorageUser = _localStorage.getUser();
    return supabaseUser != null && localStorageUser != null;
  }
}
