import 'package:flutter/material.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/join_group_button.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class SharedGroupScreen extends StatelessWidget {
  final GroupModel group;

  const SharedGroupScreen({required this.group, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: oneColContentWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSharedGroupInfo(),
            xSpace,
            JoinGroupButton(group: group),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedGroupInfo() {
    return Card(
      elevation: 1.0,
      shape: customBorder,
      child: Padding(
        padding: const EdgeInsets.all(fontSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(group.name, style: headingText),
            halfSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: const BoxDecoration(color: categoryBgColor),
                child: Text(group.category, style: labelText),
              ),
            ),
            xSpace,
            Text(
              '${group.meetingDay}: ${group.meetingTimeLocal.hour}:${group.meetingTimeLocal.minute}',
              style: bodyRegular,
            ),
            xSpace,
            Text(
              'Description: ${group.description ?? ''}',
              style: bodyRegular,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
