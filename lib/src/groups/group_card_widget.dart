import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/Mcustom_button.dart';
import 'package:mastermind_together/src/ui/widgets/profile_badge.dart';

class GroupCard extends GetView<GroupController> {
  final GroupModel group;

  const GroupCard(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool userIsMember = controller.isUserMemberOfGroup(group.id);

      return InkWell(
        onTap: () => Get.toNamed(Routes.groupRoute(group.id)),
        customBorder: customBorder,
        child: Card(
          shape: customBorder,
          elevation: 1,
          child: Container(
            width: groupCardWidth,
            height: groupCardHeight,
            padding: const EdgeInsets.only(
              top: 1.5 * fontSize,
              left: fontSize,
              right: fontSize,
              bottom: fontSize,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 43,
                      child: Image.asset("assets/images/img.png"),
                    ),
                  ],
                ),
                buildTitleSection(),
                const SizedBox(height: fontSize),
                Text(
                  '${group.meetingDay}: ${group.meetingTimeLocal.hour}:${group.meetingTimeLocal.minute}',
                  style: bodyRegular,
                ),
                const SizedBox(height: fontSize),
                buildParticipantsSection(),
                const SizedBox(height: fontSize),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: userIsMember
                      ? const CustomButton(
                          label: 'Joined',
                          labelTextStyle: bodyMediumInactive,
                          backgroundColor: buttonInactiveBackgroundColor,
                          isEnabled: false,
                        )
                      : CustomButton(
                          label: 'Join Group',
                          labelTextStyle: bodyMediumInactive.copyWith(color: bodyButtonActiveTextColor),
                          backgroundColor: buttonActiveBackgroundColor,
                          isEnabled: true,
                          onPressed: () => controller.joinGroup(group.id),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildTitleSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: fontSize),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: const BoxDecoration(color: categoryBgColor),
          child: Text(group.category, style: labelText),
        ),
        const SizedBox(height: 0.5 * fontSize),
        Text(group.name, style: bodySemiBold),
      ],
    );
  }

  Widget buildParticipantsSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${group.currentMembers}/${group.maxMembers}', style: bodyRegular),
        const SizedBox(width: 0.5 * fontSize),
        const SizedBox(
          width: 120,
          height: 30,
          child: ProfileBadges(),
        ),
      ],
    );
  }
}

class ProfileBadges extends StatelessWidget {
  const ProfileBadges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        ProfileBadge(leftOffset: 80, imagePath: "assets/images/img.png"),
        ProfileBadge(leftOffset: 60, imagePath: "assets/images/img.png"),
        ProfileBadge(leftOffset: 40, imagePath: "assets/images/img.png"),
        ProfileBadge(leftOffset: 20, imagePath: "assets/images/img.png"),
        ProfileBadge(leftOffset: 0, imagePath: "assets/images/img.png"),
      ],
    );
  }
}
