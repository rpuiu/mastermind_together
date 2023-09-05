import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/onboarding/onboard_controller.dart';
import 'package:mastermind_together/src/onboarding/onboard_page.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/custom_page_indicator.dart';

class OnBoardScreen extends StatelessWidget {
  OnBoardScreen({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardController>(
      init: OnBoardController(),
      builder: (controller) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 2 * fontSize),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) => controller.onPageChanged(index),
            children: const [
              OnboardPage(
                  color: Color(0XFFFEFEFE),
                  urlImage: 'assets/images/onboarding/onboard-1.png',
                  title: "Set Your Goal!",
                  subtitle:
                      "Start by defining what you want to achieve. Whether it's business, fitness, or personal growth, set a clear goal to get the most out of our platform."),
              OnboardPage(
                  color: Color(0XFFF1EDED),
                  urlImage: 'assets/images/onboarding/onboard-2.png',
                  title: "Let Us Know When You're Available",
                  subtitle:
                      "Set your availability so we can find the perfect group that fits into your schedule. Whether you're an early bird or a night owl, we've got you covered."),
              OnboardPage(
                  color: Color(0XFFFEFEFE),
                  urlImage: 'assets/images/onboarding/onboard-3.png',
                  title: "Join or Create Your Group",
                  subtitle: "Find groups that align with your goals and availability. Can't find the perfect fit? Create your own group and invite others!"),
            ],
          ),
        ),
        bottomSheet: controller.isLastPage
            ? Container(
                color: drawerBgColor,
                padding: const EdgeInsets.symmetric(horizontal: 2 * fontSize),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.restartOnboarding();
                        pageController.jumpToPage(0);
                      },
                      child: const Text('BACK', style: buttonTextStyle),
                    ),
                    TextButton(
                      onPressed: () => controller.getStarted(),
                      child: Text('GET STARTED', style: buttonTextStyle.copyWith(color: hoverMenuIconColor)),
                    ),
                  ],
                ),
              )
            : Container(
                color: drawerBgColor,
                padding: const EdgeInsets.symmetric(horizontal: 2 * fontSize),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => pageController.jumpToPage(2),
                      child: const Text('SKIP', style: buttonTextStyle),
                    ),
                    Center(
                      child: CustomPageIndicator(pageController: pageController, itemCount: 3, isDarkBackground: true),
                    ),
                    TextButton(
                      onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('NEXT', style: buttonTextStyle),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
