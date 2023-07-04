import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/routes.dart';

class GroupCard extends GetView<GroupController> {
  final GroupModel group;

  const GroupCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool userIsMember = controller.isUserMemberOfGroup(group.id);

    return Card(
      child: InkWell(
        onTap: () => Get.toNamed(Routes.groupRoute(group.id)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group.name,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    group.category,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Center(
                child: Text('${group.meetingDay}: ${group.meetingTime.format(context)}',
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Members: ${group.currentMembers} / ${group.maxMembers}'),
                  userIsMember
                      ? ElevatedButton(
                          child: Text('Leave group'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => controller.leaveGroup(group.id),
                        )
                      : ElevatedButton(
                          child: Text('Join'),
                          onPressed: () => controller.joinGroup(group.id),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
