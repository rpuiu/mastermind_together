import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';

class AllGroupsScreen extends GetView<GroupController> {
  const AllGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Groups'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) return Center(child: CircularProgressIndicator());

                  return ListView.builder(
                    itemCount: controller.groups.value.length,
                    itemBuilder: (_, index) {
                      final group = controller.groups.value[index];
                      return GroupCard(group: group);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.createGroup);
              },
              child: Text('Create New Group'),
            ),
          ],
        ),
      ),
    );
  }
}
