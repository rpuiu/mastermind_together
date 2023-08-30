import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/profile_badge.dart';

class ProfileBadges extends StatelessWidget {
  final int numberOfMembers;

  const ProfileBadges({Key? key, required this.numberOfMembers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxBadges = 6;
    bool showEllipsis = numberOfMembers > maxBadges;

    List<Widget> badges = List.generate(
      showEllipsis ? maxBadges : numberOfMembers,
      (index) => ProfileBadge(
        leftOffset: 20.0 * index.toDouble(),
        imagePath: "assets/icons/profile.svg",
      ),
    );

    if (showEllipsis) {
      badges.add(
        Positioned(
          left: 20.0 * maxBadges.toDouble(),
          child: const Text('...', style: headingText),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: badges,
    );
  }
}
