import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/custom_drawer_button.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/drawer_state_controller.dart';

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
    Get.put(DrawerStateController());

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SvgPicture.asset(width: 212, height: 18, 'assets/images/logo/logo-small-white.svg'),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: children,
                    ),
                  ),
                  xxSpace,
                  CustomDrawerButton(text: 'Logout', iconName: 'logout', onTap: onLogout),
                  xxSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
