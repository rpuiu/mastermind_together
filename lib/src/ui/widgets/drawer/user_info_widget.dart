import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/profile/profile_pic_widget.dart';
import 'package:mastermind_together/src/profile/user_profile_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/custom_tooltip.dart';

class UserInfoWidget extends GetView<UserProfileController> {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isHovering = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isHovering,
      builder: (context, hover, child) {
        return MouseRegion(
          onEnter: (_) => isHovering.value = true,
          onExit: (_) => isHovering.value = false,
          child: Container(
            padding: const EdgeInsets.all(fontSize),
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isHovering.value ? hoverMenuIconColor : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
      child: Obx(() {
        return Row(
          children: [
            ProfilePictureWidget(
              size: 52,
              allowEditing: false,
              imageUrl: controller.signedAvatarUrl.value,
            ),
            wXSpace,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTooltip(
                    message: controller.user.value!.username,
                    child: Text(
                      controller.user.value!.username,
                      style: bodyMedium.copyWith(color: hoverMenuTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  CustomTooltip(
                    message: controller.user.value!.email,
                    child: Text(
                      controller.user.value!.email,
                      style: labelText.copyWith(color: defaultMenuTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
