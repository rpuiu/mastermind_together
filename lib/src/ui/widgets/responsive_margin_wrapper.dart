import 'package:flutter/material.dart';

class ResponsiveMarginWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveMarginWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    EdgeInsets margin;

    if (screenWidth > 1200) {
      // Desktop
      margin = const EdgeInsets.symmetric(horizontal: 100, vertical: 20);
    } else if (screenWidth > 800) {
      // Tablet
      margin = const EdgeInsets.symmetric(horizontal: 50, vertical: 20);
    } else {
      // Mobile
      margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    }

    return Container(
      margin: margin,
      child: child,
    );
  }
}
