import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_card.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/custom_page_indicator.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

class GoalsSection extends GetView<GoalController> {
  GoalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double viewportFraction = MediaQuery.of(context).size.width > 600 ? 0.5 : 0.7;
    final PageController pageController = PageController(viewportFraction: viewportFraction);

    return Expanded(
      child: Column(
        children: [
          const Text("My Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Obx(
              () => controller.goals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10), // Spacer
                          const Text('You haven\'t set any goals yet.'),
                          CustomButton(
                            onPressed: () {
                              Get.toNamed(Routes.createGoal);
                            },
                            child: const Text('Set a Goal'),
                          ),
                        ],
                      ),
                    )
                  : PageView.builder(
                      controller: pageController,
                      itemCount: controller.goals.length,
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      itemBuilder: (_, index) {
                        final goal = controller.goals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: fontSize),
                          child: GoalCard(goal: goal, index: index),
                        );
                      },
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.goals.isNotEmpty
                  ? Container(
                      height: 24,
                      child: CustomPageIndicator(
                        pageController: pageController,
                        itemCount: controller.goals.length,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 4 * fontSize),
            ],
          )
        ],
      ),
    );
  }
}
