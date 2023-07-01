import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/routes.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onJoin;

  GroupCard({required this.group, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Get.toNamed(Routes.groupRoute(group.id)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(group.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              Text(group.category),
              Text('Max Members: ${group.maxMembers}'),
              Text('Current Members: ${group.currentMembers}'),
              ElevatedButton(
                child: Text('Join'),
                onPressed: onJoin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
