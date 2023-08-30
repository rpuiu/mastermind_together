import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class ProfileBadge extends StatelessWidget {
  const ProfileBadge({
    super.key,
    required this.leftOffset,
    required this.imagePath,
  });

  final double leftOffset;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: leftOffset,
      child: CircleAvatar(
        radius: 15,
        backgroundColor: whiteColor,
        child: CircleAvatar(
          radius: 13,
          backgroundColor: hoverMenuTextColor,
          child: SvgPicture.asset(
            'assets/icons/profile.svg',
            colorFilter: const ColorFilter.mode(headingTextColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
