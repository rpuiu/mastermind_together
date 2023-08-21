import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/base_drawer.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/drawer_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return BaseDrawer(
      onLogout: authController.logout,
      children: [
        DrawerButton(text: 'Home', iconName: 'home', onTap: () => Get.toNamed(Routes.home)),
        const SizedBox(height: fontSize),
        DrawerButton(text: 'Groups', iconName: 'profile2user', onTap: () => Get.toNamed(Routes.allGroups)),
        const SizedBox(height: fontSize),
        DrawerButton(text: 'Goals', iconName: 'award', onTap: () => Get.toNamed(Routes.goals)),
        const SizedBox(height: fontSize),
        DrawerButton(text: 'Availability', iconName: 'calendar2', onTap: () => Get.toNamed(Routes.availability)),
        const SizedBox(height: fontSize),
        DrawerButton(text: 'Notifications', iconName: 'notification', onTap: () => Get.toNamed(Routes.home)), //TODO MAIN-T-57
        const SizedBox(height: fontSize),
        DrawerButton(text: 'Feedback', iconName: 'message', onTap: () => Get.toNamed(Routes.feedback)),
        const SizedBox(height: fontSize),
        DrawerButton(text: 'Settings', iconName: 'settings2', onTap: () => Get.toNamed(Routes.userProfile)),
      ],
    );
  }
}
