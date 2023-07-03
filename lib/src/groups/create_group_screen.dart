import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';

class CreateGroupScreen extends GetView<GroupController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Category'),
                  value: controller.selectedCategory!.value,
                  items: controller.categories.map((area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategory!.value = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || value == 'Please select...') {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    controller.group.category = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) => controller.group.name = value!,
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Meeting Time'),
                  controller: TextEditingController(text: controller.group.meetingTime.format(context)),
                  onTap: () async {
                    final timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (timeOfDay != null) {
                      controller.group.meetingTime = timeOfDay;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a meeting time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Meeting URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a meeting URL';
                    }
                    return null;
                  },
                  onSaved: (value) => controller.group.meetingUrl = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Max Number of Members'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a maximum number of members';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (value) => controller.group.maxMembers = int.parse(value!),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Create Group'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      controller.createGroup();
                      Get.toNamed(Routes.allGroups);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
