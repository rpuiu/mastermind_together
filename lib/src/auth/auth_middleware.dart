import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthService authService = Get.find<AuthService>();
    final user = authService.getUser();

    if (user == null) {
      return const RouteSettings(name: Routes.login);
    } else {
      return null; // continue routing normally if user is not null
    }
  }
}
