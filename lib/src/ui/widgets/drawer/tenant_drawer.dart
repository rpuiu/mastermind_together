import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/base_drawer.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/custom_drawer_button.dart';

import '../../../auth/login_controller.dart';

class TenantDrawer extends StatelessWidget {
  const TenantDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    return BaseDrawer(
      onLogout: loginController.logout,
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
        // xSpace,
        // DrawerButton(text: 'Logo & Colors', icon: const Icon(Icons.color_lens), onTap: () => {}), //TODO
      ],
    );
  }
}
