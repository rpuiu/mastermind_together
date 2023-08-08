import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_model.dart'; // Import the GoalModelort 'package:mastermind_together/src/ui/widgets/goal_card.dart'; // Import the GoalCard
import 'package:mastermind_together/src/home/goals_carousel_controller.dart';
import 'package:mastermind_together/src/ui/widgets/goal_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GoalsCarousel extends GetView<GoalsCarouselController> {
  final List<GoalModel> goals;

  GoalsCarousel({required this.goals, super.key});

  final keyResults = ['Result 1', 'Result 2', 'Result 2', 'Result 2', 'Result 2'];

  @override
  Widget build(BuildContext context) {
    final PageController pageController = controller.pageController;

    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Obx(
              () => SizedBox(
                height: controller.height.value,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GoalCard(
                        index: index,
                        goalModel: goals[index],
                        keyResults: keyResults,
                        onExpansionChanged: (expanded, numberOfKeyResults) => controller.updateHeight(expanded, keyResults.length),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.resetHeight();
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Positioned(
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  controller.resetHeight();
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothPageIndicator(
              controller: pageController,
              count: goals.length,
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
        ),
      ],
    );
  }
}
