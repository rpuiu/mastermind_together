import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/base_drawer.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/custom_drawer_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return BaseDrawer(
      onLogout: authController.logout,
      children: [
        xSpace,
        CustomDrawerButton(text: 'Home', iconName: 'home', onTap: () => Get.toNamed(Routes.home)),
        xSpace,
        CustomDrawerButton(text: 'Groups', iconName: 'profile2user', onTap: () => Get.toNamed(Routes.allGroups)),
        xSpace,
        CustomDrawerButton(text: 'Goals', iconName: 'award', onTap: () => Get.toNamed(Routes.goals)),
        xSpace,
        CustomDrawerButton(text: 'Availability', iconName: 'calendar2', onTap: () => Get.toNamed(Routes.availability)),
        xSpace,
        CustomDrawerButton(text: 'Notifications', iconName: 'notification', onTap: () => Get.toNamed(Routes.notifications)),
        xSpace,
        CustomDrawerButton(text: 'Contact Us', iconName: 'message', onTap: () => Get.toNamed(Routes.feedback)),
        // xSpace,
        // CustomDrawerButton(text: 'Settings', iconName: 'settings2', onTap: () => Get.toNamed(Routes.userProfile)),
      ],
    );
  }
}
