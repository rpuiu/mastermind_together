import 'package:flutter/material.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class MemberList extends StatelessWidget {
  final List<UserModel> members;
  final String? adminId;

  const MemberList({super.key, required this.members, this.adminId});

  @override
  Widget build(BuildContext context) {
    if (adminId == null) {
      throw ArgumentError('Admin ID cannot be null');
    }

    // Sorting the list to make admin the first entry
    members.sort((a, b) => a.id == adminId ? -1 : 1);

    return ListView(
      children: members
          .map((member) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Icon(Icons.person, size: 24.0),
                    const SizedBox(width: 2),
                    Text(
                      '${member.username}${member.id == adminId ? " (Admin)" : ""}',
                      style: member.id == adminId ? labelText.copyWith(fontWeight: FontWeight.bold) : labelText,
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
