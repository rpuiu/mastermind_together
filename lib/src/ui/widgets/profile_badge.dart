import 'package:flutter/material.dart';
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
          radius: 14,
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
