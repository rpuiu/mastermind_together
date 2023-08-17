import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/drawer_button.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();

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
                        DrawerButton(text: 'Home', icon: AppIcons.home, onTap: () => Get.toNamed(Routes.home)),
                        const SizedBox(height: fontSize),
                        DrawerButton(text: 'Groups', icon: AppIcons.profile2user, onTap: () => Get.toNamed(Routes.allGroups)),
                        const SizedBox(height: fontSize),
                        DrawerButton(text: 'Goals', icon: AppIcons.award, onTap: () => Get.toNamed(Routes.goals)),
                        const SizedBox(height: fontSize),
                        DrawerButton(text: 'Availability', icon: AppIcons.calendar2, onTap: () => Get.toNamed(Routes.availability)),
                        const SizedBox(height: fontSize),
                        DrawerButton(text: 'Notifications', icon: AppIcons.notification, onTap: () => Get.toNamed(Routes.home)), //TODO MAIN-T-57
                        const SizedBox(height: fontSize),
                        DrawerButton(text: 'Feedback', icon: AppIcons.message, onTap: () => Get.toNamed(Routes.feedback)),
                        const SizedBox(height: fontSize),
                        DrawerButton(text: 'Settings', icon: AppIcons.settings2, onTap: () => Get.toNamed(Routes.userProfile)),
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
