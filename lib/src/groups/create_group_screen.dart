import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

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
                const SizedBox(height: 2 * fontSize),
                _buildNameField(),
                const SizedBox(height: 2 * fontSize),
                Row(
                  children: [
                    Expanded(child: _buildDayField()),
                    const SizedBox(height: 2 * fontSize),
                    Expanded(child: _buildTimeField(context)),
                    const SizedBox(height: 2 * fontSize),
                  ],
                ),
                const SizedBox(height: 2 * fontSize),
                _buildUrlField(),
                const SizedBox(height: 2 * fontSize),
                _buildMaxMembersField(),
                const SizedBox(height: 2 * fontSize),
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
        items: controller.categoryController.categoryNames,
        validator: (value) => FormValidators.validateEmpty(value, 'Please select a category'),
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
        validator: (value) => FormValidators.validateEmpty(value, 'Please select a meeting day'),
      ),
    );
  }

  CustomTextFormField _buildNameField() {
    return CustomTextFormField(
      controller: TextEditingController(),
      label: 'Name',
      hintText: 'Enter a name',
      validator: (value) => FormValidators.validateEmpty(value, 'Please enter a name'),
      onChanged: (value) => controller.group.value.name = value,
    );
  }

  Obx _buildTimeField(BuildContext context) {
    return Obx(
      () => CustomTextFormField(
        readOnly: true,
        controller: controller.meetingTimeController.value,
        label: 'Meeting Time',
        hintText: 'Please select a meeting time',
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
        validator: (value) => FormValidators.validateEmpty(value, 'Please select a meeting time'),
      ),
    );
  }

  CustomTextFormField _buildUrlField() {
    return CustomTextFormField(
      controller: TextEditingController(),
      label: 'Meeting URL',
      hintText: 'Enter the meeting URL',
      validator: (value) => FormValidators.validateEmpty(value, 'Please enter a meeting URL'),
      onChanged: (value) => controller.group.value.meetingUrl = value,
    );
  }

  CustomTextFormField _buildMaxMembersField() {
    return CustomTextFormField(
      controller: TextEditingController(),
      label: 'Max Number of Members',
      hintText: 'Enter the maximum number of members',
      validator: (value) => FormValidators.validateEmpty(value, 'Please enter a maximum number of members'),
      keyboardType: TextInputType.number,
      onChanged: (value) => controller.group.value.maxMembers = int.parse(value),
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
