import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_operations_controller.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/subscription/limit_alert_widget.dart';
import 'package:mastermind_together/src/subscription/subscription_controller.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class JoinGroupButton extends GetView<GroupOperationsController> {
  final String groupId;
  final SubscriptionController _subscriptionController = Get.find<SubscriptionController>();
  final MembersController _membersController = Get.find<MembersController>();

  JoinGroupButton({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_membersController.isUserMemberOfGroup(groupId)) {
        return CustomButton(
          label: 'Joined',
          labelTextStyle: bodyMediumInactive,
          backgroundColor: buttonInactiveBackgroundColor,
          isEnabled: false,
        );
      } else {
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
              await controller.joinGroup(groupId, onJoined: () {
                Get.offAllNamed(Routes.groupRoute(groupId));
              });
            });
          },
        );
      }
    });
  }
}
