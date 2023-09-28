import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/custom_drawer_button.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/user_info_widget.dart';
import 'package:mastermind_together/src/ui/widgets/logo/logo_controller.dart';
import 'package:mastermind_together/src/ui/widgets/logo/tenant_logo.dart';

class BaseDrawer extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback onLogout;

  const BaseDrawer({
    Key? key,
    required this.children,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LogoController logoController = Get.find<LogoController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(fontSize / 2, fontSize, fontSize / 2, fontSize),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Drawer(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              padding: const EdgeInsets.only(left: 1.5 * fontSize, right: 1.5 * fontSize),
              decoration: BoxDecoration(
                color: drawerBgColor,
                borderRadius: borderRadius,
                border: Border.all(color: drawerBorderColor, width: 1),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double availableHeight = constraints.maxHeight;
                  return Obx(() {
                    final double aspectRatio = logoController.aspectRatio.value;
                    double headerHeight;
                    if (aspectRatio > 1.2) {
                      headerHeight = availableHeight * 0.3; // 30% of available height for rectangular logos
                    } else {
                      headerHeight = availableHeight * 0.35; // 35% of available height for square logos
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: headerHeight,
                          child: DrawerHeader(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                xxSpace,
                                const TenantLogo(width: 212, height: 18, squareHeight: 100, isLight: true),
                                xSpace,
                                InkWell(
                                  onTap: () => Get.toNamed(Routes.userProfile),
                                  child: const UserInfoWidget(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: children,
                            ),
                          ),
                        ),
                        xxSpace,
                        CustomDrawerButton(text: 'Logout', iconName: 'logout', onTap: onLogout),
                        xxSpace,
                      ],
                    );
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
