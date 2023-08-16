import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class ResponsivePaddingWrapper extends StatelessWidget {
  final Widget child;

  const ResponsivePaddingWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontal = calculateHorizontalMargin(screenWidth);
    double vertical = calculateVerticalMargin(screenWidth);

    EdgeInsets padding = EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
