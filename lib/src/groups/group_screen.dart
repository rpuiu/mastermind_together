import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';

class GroupScreen extends GetView<GroupController> {
  final String groupId = Get.parameters['groupId']!;

  GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group'),
      ),
      body: FutureBuilder<GroupModel>(
        future: controller.fetchGroup(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final group = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Text(group.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                Text('Category: ${group.category}'),
                Text(group.meetingTime),
                Text(group.meetingUrl),
                Text('Max Members: ${group.maxMembers}'),
                Text('Current Members: ${group.currentMembers}'),
                // Add more details about the group as needed
              ],
            );
          }
        },
      ),
    );
  }
}
