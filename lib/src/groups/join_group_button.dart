import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/group_operations_controller.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/subscription/limit_alert_widget.dart';
import 'package:mastermind_together/src/subscription/subscription_controller.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_loading_button.dart';

class JoinGroupButton extends GetView<GroupOperationsController> {
  final GroupModel group;
  final SubscriptionController _subscriptionController = Get.find<SubscriptionController>();
  final MembersController _membersController = Get.find<MembersController>();

  JoinGroupButton({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isLoading(group.id) && _membersController.isUserMemberOfGroup(group.id)) {
        return CustomButton(
          label: 'Joined',
          labelTextStyle: bodyMediumInactive,
          backgroundColor: buttonInactiveBackgroundColor,
          isEnabled: false,
        );
      } else {
        if (group.currentMembers == group.maxMembers) {
          return CustomButton(
            label: "Group Full",
            backgroundColor: buttonInactiveBackgroundColor,
            labelTextStyle: bodyMediumInactive,
            isEnabled: false,
          );
        }
        if (controller.isLoading(group.id)) {
          return const CustomLoadingButton(
            labelTextStyle: buttonTextStyle,
            backgroundColor: buttonActiveBackgroundColor,
            onPressed: null,
          );
        }
        return CustomButton(
          label: 'Join Group',
          labelTextStyle: bodyMediumInactive.copyWith(color: bodyButtonActiveTextColor),
          backgroundColor: buttonActiveBackgroundColor,
          isEnabled: true,
          onPressed: () async {
            final localContext = context;
            await _subscriptionController.canUserJoinGroup().then((joined) async {
              if (!joined) {
                showLimitReachedAlert(
                    localContext, 'You\'ve reached the limit of groups you can join on the free tier. Please contact us to upgrade your subscription.');
                return;
              }
              await controller.joinGroup(group.id, onJoined: () {
                Get.offAllNamed(Routes.groupRoute(group.id));
              });
            });
          },
        );
      }
    });
  }
}
