import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_card.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/custom_page_indicator.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class GoalsSection extends GetView<GoalController> {
  const GoalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double viewportFraction = MediaQuery.of(context).size.width > 600 ? 0.6 : 0.8; // Adjust this to make cards wider
    final PageController pageController = PageController(viewportFraction: viewportFraction);

    return SizedBox(
      height: 325,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text("Ready for an awesome day?", style: headingText),
          ),
          const SizedBox(
            height: 2 * fontSize,
          ),
          Expanded(
            child: Obx(
              () => PageView.builder(
                controller: pageController,
                itemCount: controller.goals.length,
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                itemBuilder: (_, index) {
                  final goal = controller.goals[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: fontSize / 2),
                    child: GoalCard(goal: goal, index: index),
                  );
                },
              ),
            ),
          ),
          xSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                child: CustomPageIndicator(
                  pageController: pageController,
                  itemCount: controller.goals.length,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
