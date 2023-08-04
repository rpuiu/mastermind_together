import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/onboarding/onboard_controller.dart';
import 'package:mastermind_together/src/onboarding/onboard_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardScreen extends StatelessWidget {
  OnBoardScreen({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardController>(
      init: OnBoardController(),
      builder: (controller) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) => controller.onPageChanged(index),
            children: [
              //TODO implement Onboarding UI
              OnboardPage(color: Colors.teal.shade100, urlImage: '', title: "Welcome", subtitle: "Welcome to our app!"),
              OnboardPage(color: Colors.teal.shade300, urlImage: '', title: "Welcome", subtitle: "Welcome to our app!"),
              OnboardPage(color: Colors.teal.shade900, urlImage: '', title: "Welcome", subtitle: "Welcome to our app!"),
            ],
          ),
        ),
        bottomSheet: controller.isLastPage
            ? Container(
                color: Colors.black12,
                padding: const EdgeInsets.symmetric(horizontal: 80),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.restartOnboarding();
                        pageController.jumpToPage(0);
                      },
                      child: const Text('BACK'),
                    ),
                    TextButton(
                      onPressed: () => controller.getStarted(),
                      child: const Text('GET STARTED'),
                    ),
                  ],
                ),
              )
            : Container(
                color: Colors.black12,
                padding: const EdgeInsets.symmetric(horizontal: 80),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => pageController.jumpToPage(2),
                      child: const Text('SKIP'),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: 3,
                        effect: JumpingDotEffect(
                          verticalOffset: 16,
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: Theme.of(context).colorScheme.primary,
                        ),
                        onDotClicked: (index) => pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('NEXT'),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
