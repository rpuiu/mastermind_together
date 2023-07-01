import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/routes.dart';

class GroupCard extends GetView<GroupController> {
  final GroupModel group;

  const GroupCard({super.key, required this.group});

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
              Text(group.meetingTime),
              Text(group.meetingUrl),
              Text('Max Members: ${group.maxMembers}'),
              Text('Current Members: ${group.currentMembers}'),
              ElevatedButton(
                child: Text('Join'),
                onPressed: () => controller.joinGroup(group.id),
              ),
              ElevatedButton(
                child: Text('Leave group'),
                onPressed: () => controller.leaveGroup(group.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
