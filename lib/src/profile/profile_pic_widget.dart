import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/profile/user_profile_controller.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';

class ProfilePictureWidget extends GetView<UserProfileController> {
  final bool allowEditing;

  const ProfilePictureWidget({Key? key, this.allowEditing = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      var avatarPath = controller.signedAvatarUrl.value;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: hoverMenuTextColor,
            child: avatarPath.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: avatarPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => buildProfileIcon(),
                    ),
                  )
                : buildProfileIcon(),
          ),
          if (allowEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: EditBtn(
                onPressed: () => controller.pickImage(),
              ),
            ),
        ],
      );
    });
  }

  Widget buildProfileIcon() {
    return SvgPicture.asset(
      'assets/icons/profile.svg',
      colorFilter: const ColorFilter.mode(
        headingTextColor,
        BlendMode.srcIn,
      ),
      width: 50,
      height: 50,
    );
  }
}
