import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/space.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/base_drawer.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/custom_drawer_button.dart';

class TenantDrawer extends StatelessWidget {
  const TenantDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return BaseDrawer(
      onLogout: authController.logout,
      children: [
        CustomDrawerButton(text: 'Home', iconName: 'home', onTap: () => Get.toNamed(Routes.tenantDashboard)),
        xSpace,
        CustomDrawerButton(
          text: 'Terms of Service & Privacy Policy',
          iconName: 'privacy-policy',
          onTap: () => Get.toNamed(Routes.editTerms),
        ),
        xSpace,
        CustomDrawerButton(
          text: 'Goal & Group Categories',
          iconName: 'categories',
          onTap: () => Get.toNamed(Routes.categories),
        ),
        // const SizedBox(height: fontSize),
        // DrawerButton(text: 'Logo & Colors', icon: const Icon(Icons.color_lens), onTap: () => {}), //TODO
      ],
    );
  }
}
