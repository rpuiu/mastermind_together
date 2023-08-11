import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class ResponsiveMarginWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveMarginWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontal = calculateHorizontalMargin(screenWidth);
    double vertical = calculateVerticalMargin(screenWidth);

    EdgeInsets margin = EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    return Container(
      margin: margin,
      child: child,
    );
  }
}
