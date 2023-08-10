import 'package:flutter/material.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_model.dart';

class GroupCardsRow extends StatelessWidget {
  final List<GroupModel> groups;

  const GroupCardsRow({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: List.generate(groups.length, (index) {
          final group = groups[index];
          return GroupCard(group);
        }),
      ),
    );
  }
}
