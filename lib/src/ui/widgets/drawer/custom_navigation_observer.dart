import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/drawer_state_controller.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    _updateDrawerState(route);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateDrawerState(route);
  }

  void _updateDrawerState(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName != null) {
      final drawerStateController = Get.find<DrawerStateController>();
      if (routeName.contains(Routes.group) ||
          routeName.contains(Routes.goal) ||
          routeName.contains(Routes.userProfile) ||
          routeName.contains(Routes.createGroup)) {
        drawerStateController.clearActiveButton();
      }
    }
  }
}
