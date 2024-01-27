import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  @override
  RouteSettings? redirect(String? route) {
    final AuthService authService = Get.find<AuthService>();
    final user = authService.getUser();

    if (user == null) {
      if (route != "/splash") {
        _localStorage.setOriginalRoute(route!);
      }
      return const RouteSettings(name: Routes.login);
    }

    return super.redirect(route);
  }
}
