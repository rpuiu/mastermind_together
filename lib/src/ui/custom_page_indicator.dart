import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomPageIndicator extends StatelessWidget {
  final PageController pageController;
  final int itemCount;
  final bool isDarkBackground;

  const CustomPageIndicator({
    super.key,
    required this.pageController,
    required this.itemCount,
    this.isDarkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) => AnimatedBuilder(
          animation: pageController,
          builder: (context, _) {
            double selectedPage = pageController.page ?? 0;
            Color circleColor;
            if (selectedPage.round() == index) {
              circleColor = hoverMenuIconColor;
            } else {
              circleColor = isDarkBackground ? whiteColor : drawerBgColor;
            }
            return GestureDetector(
              onTap: () => pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
