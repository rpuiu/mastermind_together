import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/drawer_button.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class TenantDrawer extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  TenantDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(fontSize / 2, fontSize, fontSize / 2, fontSize),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Drawer(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.only(left: 1.5 * fontSize, right: 1.5 * fontSize),
              decoration: BoxDecoration(
                color: drawerBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: drawerBorderColor, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SvgPicture.asset(width: 212, height: 18, 'assets//images/logo/logo-small.svg'),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //TODO Icons
                        DrawerButton(text: 'Home', icon: AppIcons.home, onTap: () => Get.toNamed(Routes.tenantDashboard)),
                        const SizedBox(height: fontSize),
                        DrawerButton(
                            text: 'Terms of Service & Privacy Policy',
                            icon: const Icon(
                              Icons.policy_outlined,
                              color: iconColor,
                            ), //TODO change icon
                            onTap: () => Get.toNamed(Routes.editTerms)),
                        const SizedBox(height: fontSize),
                        DrawerButton(
                            text: 'Goal & Group Categories',
                            icon: const Icon(
                              Icons.category_outlined,
                              color: iconColor,
                            ), //TODO change icon
                            onTap: () => Get.toNamed(Routes.categories)),
                        // const SizedBox(height: fontSize),
                        // DrawerButton(text: 'Logo & Colors', icon: const Icon(Icons.color_lens), onTap: () => {}), //TODO
                      ],
                    ),
                  ),
                  const SizedBox(height: 2 * fontSize),
                  DrawerButton(text: 'Logout', icon: AppIcons.logout, onTap: _authController.logout),
                  const SizedBox(height: 2 * fontSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
