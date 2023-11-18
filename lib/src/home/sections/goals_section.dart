import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/assistants/ai_guide_msg_controller.dart';
import 'package:mastermind_together/src/goal/goal_card.dart';
import 'package:mastermind_together/src/goal/goals_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class GoalsSection extends GetView<GoalsController> {
  GoalsSection({Key? key}) : super(key: key);

  final AIThreadMessageController aiThreadController = Get.find<AIThreadMessageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Ready for an awesome day?", style: headingText),
              ),
              wXSpace,
              Obx(
                () {
                  if (aiThreadController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return Container(
                      width: 200,
                      height: 50,
                      child: CustomButton(
                        icon: AppIcons.serenityGuide(),
                         onPressed: () async {
                          String? userThreadId = await aiThreadController.createNewThread();
                          if (userThreadId != null) {
                            Get.toNamed(Routes.aiChatRoute(userThreadId));
                          } else {
                            showErrorSnackBar(message: "Unable to start conversation. Please try again");
                          }
                        },
                        label: 'Serenity Guide',
                        labelTextStyle: bodyMediumInactive.copyWith(color: bodyButtonActiveTextColor),
                        backgroundColor: buttonActiveBackgroundColor,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 2 * fontSize,
          ),
          Expanded(
            child: Obx(
              () {
                final goal = controller.goals.isNotEmpty ? controller.goals[0] : null;
                return goal != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: fontSize / 2),
                        child: GoalCard(goal: goal, index: 0),
                      )
                    : const Center(child: Text('No goals available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
