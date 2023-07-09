import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';

class CreateGroupScreen extends GetView<GroupController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateGroupScreen({Key? key}) : super(key: key);

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
                _buildCategoryField(),
                _buildNameField(),
                Row(
                  children: [
                    Expanded(child: _buildDayField()),
                    Expanded(child: _buildTimeField(context)),
                  ],
                ),
                _buildUrlField(),
                _buildMaxMembersField(),
                SizedBox(height: 16),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildCategoryField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Category'),
      value: controller.selectedCategory!.value,
      items: controller.categoryController.categories.map((area) {
        return DropdownMenuItem<String>(
          value: area,
          child: Text(area),
        );
      }).toList(),
      onChanged: (value) => controller.selectedCategory!.value = value!,
      validator: (value) => (value == null || value.isEmpty || value == 'Please select...') ? 'Please select a category' : null,
      onSaved: (value) => controller.group.value.category = value!,
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
      onSaved: (value) => controller.group.value.name = value!,
    );
  }

  DropdownButtonFormField<String> _buildDayField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Meeting Day'),
      value: controller.selectedDay!.value,
      items: ['Please select...'].followedBy(getWeekDaysNames()).map((day) {
        return DropdownMenuItem<String>(
          value: day,
          child: Text(day),
        );
      }).toList(),
      onChanged: (value) => controller.selectedDay!.value = value!,
      validator: (value) => (value == null || value.isEmpty || value == 'Please select...') ? 'Please select a day' : null,
      onSaved: (value) => controller.group.value.meetingDay = value!,
    );
  }

  Obx _buildTimeField(BuildContext context) {
    return Obx(
      () => TextFormField(
        readOnly: true,
        decoration: InputDecoration(labelText: 'Meeting Time'),
        controller: controller.meetingTimeController.value,
        onTap: () async {
          final timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (timeOfDay != null) {
            controller.group.value.meetingTimeUTC = timeOfDay;
            controller.meetingTimeController.value.text = timeOfDay.format(context);
          }
        },
        validator: (value) => (value == null || value.isEmpty) ? 'Please select a meeting time' : null,
      ),
    );
  }

  TextFormField _buildUrlField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Meeting URL'),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a meeting URL' : null,
      onSaved: (value) => controller.group.value.meetingUrl = value!,
    );
  }

  TextFormField _buildMaxMembersField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Max Number of Members'),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a maximum number of members' : null,
      keyboardType: TextInputType.number,
      onSaved: (value) => controller.group.value.maxMembers = int.parse(value!),
    );
  }

  ElevatedButton _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      child: Text('Create Group'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          controller.createGroup();
          Get.toNamed(Routes.allGroups);
        }
      },
    );
  }
}
