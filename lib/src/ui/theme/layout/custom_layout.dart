import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/layout/responsive_layout.dart';

class CustomLayout extends StatelessWidget {
  final Widget content;

  const CustomLayout({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(content: content);
  }
}
