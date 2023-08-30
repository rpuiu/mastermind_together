import 'package:flutter/material.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class GroupCardsRow extends StatelessWidget {
  final List<GroupModel> groups;

  const GroupCardsRow({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: groupCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return GroupCard(group);
        },
      ),
    );
  }
}
