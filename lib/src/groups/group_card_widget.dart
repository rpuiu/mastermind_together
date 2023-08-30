import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/join_group_button.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/custom_tooltip.dart';
import 'package:mastermind_together/src/ui/widgets/label_categ_widget.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';

import 'widgets/profile_badges.dart';

class GroupCard extends GetView<GroupController> {
  final GroupModel group;

  const GroupCard(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(fontSize / 2),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.groupRoute(group.id)),
        customBorder: customBorder,
        child: Card(
          shape: customBorder,
          elevation: 1,
          child: Container(
            width: groupCardWidth,
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
                      backgroundColor: hoverMenuTextColor,
                      radius: 43,
                      child: SizedBox(
                        width: 43,
                        height: 43,
                        child: SvgPicture.asset(
                          'assets/icons/profile-2user.svg',
                          colorFilter: const ColorFilter.mode(headingTextColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
                buildTitleSection(),
                xSpace,
                Text(
                  '${group.meetingDay}: ${formatTimeOfDay(group.meetingTimeLocal)}',
                  style: bodyRegular,
                ),
                xSpace,
                buildParticipantsSection(),
                xSpace,
                JoinGroupButton(groupId: group.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        xSpace,
        LabelCategoryWidget(label: group.category),
        halfSpace,
        CustomTooltip(
          message: group.name,
          child: Text(group.name, style: bodySemiBold, overflow: TextOverflow.ellipsis),
        )
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
        wHalfSpace,
        SizedBox(
          width: 120,
          height: 30,
          child: ProfileBadges(numberOfMembers: group.currentMembers),
        ),
      ],
    );
  }
}
