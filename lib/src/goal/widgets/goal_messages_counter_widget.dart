import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_message_controller.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class GoalMessagesCounterWidget extends GetView<GoalMessageController> {
  final String goalId;


  const GoalMessagesCounterWidget(this.goalId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final GoalMessageController messageGoalController = Get.find<GoalMessageController>(tag: goalId);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcons.comments(messageGoalController.messageCount > 0 ? IconState.hoverState : IconState.defaultState),
          const SizedBox(width: 4),
          Text("${messageGoalController.messageCount}", style: bodyRegular),
        ],
      );
    });
  }
}
