import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/subscription/limit_alert_widget.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class JoinGroupButton extends GetView<GroupController> {
  final String groupId;

  const JoinGroupButton({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Join Group',
      labelTextStyle: bodyMediumInactive.copyWith(color: bodyButtonActiveTextColor),
      backgroundColor: buttonActiveBackgroundColor,
      isEnabled: true,
      onPressed: () {
        final localContext = context;
        controller.canJoin().then((joined) {
          if (!joined) {
            showLimitReachedAlert(localContext);
            return;
          }
          controller.joinGroup(groupId);
        });
      },
    );
  }
}
