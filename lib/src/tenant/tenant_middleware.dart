import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';

class TenantMiddleware extends GetMiddleware {
  @override
  int? get priority => 2; // runs after AuthMiddleware

  @override
  RouteSettings? redirect(String? route) {
    final AuthService authService = Get.find<AuthService>();

    if (!authService.isTenant()) {
      return const RouteSettings(name: Routes.home); // Redirect to home if user is not a tenant
    } else {
      return null; // continue routing normally if user is a tenant
    }
  }
}
