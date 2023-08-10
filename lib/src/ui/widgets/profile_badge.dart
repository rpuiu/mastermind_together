import 'package:flutter/material.dart';

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
      child: Container(
        width: 30,
        height: 30,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
          shape: const OvalBorder(
            side: BorderSide(width: 2, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
