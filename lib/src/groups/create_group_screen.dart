import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';

class CreateGroupScreen extends GetView<GroupController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
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
                const SizedBox(height: 16),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    return Obx(
      () => CustomDropDown(
        label: 'Category',
        selectedValue: controller.selectedCategory?.value,
        onChanged: (value) {
          if (value != null) {
            controller.group.value.category = value;
            controller.selectedCategory!.value = value;
          }
        },
        items: controller.categoryController.categories,
      ),
    );
  }

  Widget _buildDayField() {
    return Obx(
      () => CustomDropDown(
        label: 'Meeting Day',
        selectedValue: controller.selectedDay?.value,
        onChanged: (value) {
          if (value != null) {
            controller.group.value.meetingDay = value;
            controller.selectedDay!.value = value;
          }
        },
        items: ['Please select...'].followedBy(getWeekDaysNames()).toList(),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
      onSaved: (value) => controller.group.value.name = value!,
    );
  }

  Obx _buildTimeField(BuildContext context) {
    return Obx(
      () => TextFormField(
        readOnly: true,
        decoration: const InputDecoration(labelText: 'Meeting Time'),
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
      decoration: const InputDecoration(labelText: 'Meeting URL'),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a meeting URL' : null,
      onSaved: (value) => controller.group.value.meetingUrl = value!,
    );
  }

  TextFormField _buildMaxMembersField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Max Number of Members'),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a maximum number of members' : null,
      keyboardType: TextInputType.number,
      onSaved: (value) => controller.group.value.maxMembers = int.parse(value!),
    );
  }

  CustomButton _buildSubmitButton(BuildContext context) {
    return CustomButton(
      child: const Text('Create Group'),
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
