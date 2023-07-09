import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    if (authService.currentUser == null) {
      // If the user is not authenticated, redirect them to the Login page
      return RouteSettings(name: Routes.login);
    } else {
      // If the user is authenticated, allow the navigation
      return null;
    }
  }
}
