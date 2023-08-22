import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/add_goal_modal.dart';
import 'package:mastermind_together/src/goal/goal_card.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/ui/custom_page_indicator.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class GoalsSection extends GetView<GoalController> {
  const GoalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double viewportFraction = MediaQuery.of(context).size.width > 600 ? 0.5 : 0.7;
    final PageController pageController = PageController(viewportFraction: viewportFraction);

    return SizedBox(
      height: 310,
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
              () => controller.goals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10), // Spacer
                          const Text('You haven\'t set any goals yet.'),
                          CustomButton(
                            onPressed: () {
                              AddGoalModal.show(context);
                            },
                            label: 'Set a Goal',
                            labelTextStyle: buttonTextStyle,
                            backgroundColor: buttonBackgroundColor,
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
            ],
          )
        ],
      ),
    );
  }
}
