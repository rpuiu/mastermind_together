import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/widgets/images/right_side_image_widget.dart';

class MobileAwareLayout extends StatelessWidget {
  final Widget child;

  const MobileAwareLayout({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      body: isMobile
          ? child
          : Row(
        children: [
          Expanded(child: child),
          const RightSideImage(),
        ],
      ),
    );
  }
}
