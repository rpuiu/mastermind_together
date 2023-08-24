import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/space.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/drawer_btn_controller.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/drawer_state_controller.dart';

class CustomDrawerButton extends StatelessWidget {
  final String iconName;
  final String text;
  final VoidCallback onTap;

  const CustomDrawerButton({
    Key? key,
    required this.iconName,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerStateController stateController = Get.find<DrawerStateController>();
    final DrawerButtonController buttonController = Get.put(DrawerButtonController(), tag: text);

    return InkWell(
      onTap: () {
        onTap.call();
        stateController.setActiveButton(text);
      },
      onHover: (hovering) {
        buttonController.setHovered(hovering);
      },
      child: Obx(() {
        final bool isActive = stateController.activeButton.value == text;
        final bool isHovered = buttonController.isHovered.value;

        IconState state;
        if (isHovered) {
          state = IconState.hoverState;
        } else if (isActive) {
          state = IconState.activeState;
        } else {
          state = IconState.defaultState;
        }

        Widget iconWidget = AppIcons.getIcon(iconName, state);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: fontSize / 2, vertical: 0),
          title: Row(
            children: [
              iconWidget,
              wXSpace,
              Flexible(
                  child: Text(
                text,
                style: menuBtnTextRegular.copyWith(
                  color: isHovered ? hoverMenuTextColor : (isActive ? hoverMenuTextColor : defaultMenuTextColor),
                ),
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        );
      }),
    );
  }
}
