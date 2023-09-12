import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';

class ProfilePictureWidget extends StatelessWidget {
  final bool allowEditing;
  final double size;
  final String? imageUrl;
  final VoidCallback? onEdit;

  const ProfilePictureWidget({
    Key? key,
    this.allowEditing = false,
    this.size = 50.0,
    this.imageUrl,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String avatarPath = imageUrl ?? '';

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: hoverMenuTextColor,
          child: avatarPath.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: avatarPath,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => buildProfileIcon(),
                  ),
                )
              : buildProfileIcon(),
        ),
        if (allowEditing && onEdit != null)
          Positioned(
            bottom: -10,
            right: -10,
            child: EditBtn(
              onPressed: onEdit!,
            ),
          ),
      ],
    );
  }

  Widget buildProfileIcon() {
    return SvgPicture.asset(
      'assets/icons/profile.svg',
      colorFilter: const ColorFilter.mode(
        headingTextColor,
        BlendMode.srcIn,
      ),
      width: size / 2,
      height: size / 2,
    );
  }
}
