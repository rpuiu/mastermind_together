import 'package:flutter/material.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/home/sections/group_cards_row.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class HorizontalGroupList extends StatelessWidget {
  final List<GroupModel> groups;
  final String heading;
  final String subHeading;

  const HorizontalGroupList({Key? key, required this.groups, required this.heading, required this.subHeading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: headingText),
        halfSpace,
        Text(subHeading, style: bodyRegular),
        xxSpace,
        GroupCardsRow(groups: groups),
      ],
    );
  }
}
