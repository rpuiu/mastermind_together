import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GroupMembershipMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthService authService = Get.find<AuthService>();
    final GroupController groupController = Get.find<GroupController>();

    final user = authService.getUser();
    final groupId = route?.split('/').last;

    if (user != null) {
      if (!groupController.isUserMemberOfGroup(groupId!)) {
        showErrorSnackBar(message: 'You cannot access a group that you are not a member of.');
        return const RouteSettings(name: Routes.accessDenied);
      }
    } else {
      return const RouteSettings(name: Routes.login);
    }

    return super.redirect(route);
  }
}
