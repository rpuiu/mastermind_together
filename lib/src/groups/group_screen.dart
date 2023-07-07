import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/chat/chat_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';

class GroupScreen extends GetView<GroupController> {
  final String groupId = Get.parameters['groupId']!;

  GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // change this as needed
          onPressed: () => Get.back(),
        ),
        title: Text('Group'),
      ),
      body: FutureBuilder<GroupModel>(
        future: controller.fetchGroup(groupId),
        builder: (context, groupSnapshot) {
          if (groupSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (groupSnapshot.hasError) {
            return Center(child: Text('Error: ${groupSnapshot.error}'));
          } else {
            final group = groupSnapshot.data!;
            return FutureBuilder<List<UserModel>>(
              future: controller.getGroupMembers(groupId),
              builder: (context, membersSnapshot) {
                if (membersSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (membersSnapshot.hasError) {
                  return Center(child: Text('Error: ${membersSnapshot.error}'));
                } else {
                  final members = membersSnapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          children: <Widget>[
                            Text(group.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                            Text('Category: ${group.category}'),
                            Text('${group.meetingDay}: ${group.meetingTimeLocal.format(context)}'),
                            Text('Meeting URL: ${group.meetingUrl}'),
                            Divider(),
                          ],
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.all(16.0),
                                children: [
                                  Text(
                                    'Members: ${group.currentMembers} / ${group.maxMembers}',
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                  ...members
                                      .map((member) => ListTile(
                                            title: Text(member.email),
                                            // Add more details about the member as needed
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                            VerticalDivider(),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Text('Chat:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: ChatWidget(groupId: groupId),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
