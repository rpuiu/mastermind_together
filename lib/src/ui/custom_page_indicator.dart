import 'package:flutter/material.dart';

class CustomPageIndicator extends StatelessWidget {
  final PageController pageController;
  final int itemCount;

  CustomPageIndicator({
    required this.pageController,
    required this.itemCount,
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
                  color: selectedPage.round() == index ? Theme.of(context).colorScheme.primary : Colors.black26,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
