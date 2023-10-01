import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/group_operations_controller.dart';
import 'package:mastermind_together/src/groups/group_screen_controller.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/groups/widgets/conditional_edit_button.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';
import 'package:mastermind_together/src/ui/widgets/custom_tooltip.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';

class GroupInfoCard extends StatelessWidget {
  final GroupScreenController controller;
  final GroupModel group;

  final MembersController _membersController = Get.find<MembersController>();
  final GroupOperationsController _groupOperationsController = Get.find<GroupOperationsController>();

  GroupInfoCard({required this.group, Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = _membersController.isUserAdmin(group);
    return Card(
      elevation: 1.0,
      shape: customBorder,
      child: Padding(
        padding: const EdgeInsets.all(fontSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupNameAndCategory(isAdmin),
            xSpace,
            _buildMeetingDetails(isAdmin),
            xSpace,
            _buildMeetingUrl(isAdmin),
            xSpace,
            _buildGroupDescription(isAdmin),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupNameAndCategory(bool isAdmin) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(controller.group.value.name, style: headingText),
              _conditionalEditButton(
                isAdmin,
                'Edit Group Name',
                'Group Name',
                'Enter the name of the group',
                controller.group.value.name,
                (newName) => controller.updateGroupName(controller.group.value.id, newName),
              ),
            ],
          ),
          _buildCategory(),
        ],
      );
    });
  }

  Widget _buildCategory() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: const BoxDecoration(color: categoryBgColor),
        child: Text(controller.group.value.category, style: labelText),
      ),
    );
  }

  Widget _buildMeetingDetails(bool isAdmin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '${controller.group.value.meetingDay}: ${formatTimeOfDay(controller.group.value.meetingTimeLocal)}',
              style: bodyRegular,
            ),
            if (isAdmin) EditBtn(onPressed: _showDayAndTimePicker),
          ],
        ),
        _buildLocation(isAdmin),
      ],
    );
  }

  Widget _buildLocation(bool isAdmin) {
    return Row(
      children: [
        Text('Location: ${controller.group.value.location ?? ''}', style: bodyRegular),
        _conditionalEditButton(
          isAdmin,
          'Edit Group Location',
          'Group Location',
          'Enter the new location name',
          controller.group.value.location ?? '',
          (newLocation) => controller.updateGroupLocation(controller.group.value.id, newLocation),
        ),
      ],
    );
  }

  Widget _buildMeetingUrl(bool isAdmin) {
    return Row(
      children: [
        _buildRichTextMeetingUrl(),
        _conditionalEditButton(
          isAdmin,
          'Edit Meeting URL',
          'Meeting URL',
          'Enter the new URL',
          controller.group.value.meetingUrl ?? '',
          (newMeetingUrl) => controller.updateMeetingUrl(controller.group.value.id, newMeetingUrl),
        ),
      ],
    );
  }

  Widget _buildRichTextMeetingUrl() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: 'Meeting URL: ', style: bodyRegular),
          TextSpan(
            text: controller.group.value.meetingUrl,
            style: bodyRegular.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => controller.launchMeetingUrl(controller.group.value),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupDescription(bool isAdmin) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomTooltip(
                message: 'Description: ${controller.group.value.description ?? ''}',
                child: Text(
                  'Description: ${controller.group.value.description ?? ''}',
                  style: bodyRegular,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _conditionalEditButton(
                isAdmin,
                'Edit Group Description',
                'Group Description',
                'Enter the new description',
                controller.group.value.description ?? '',
                (newDescription) => controller.updateGroupDescription(controller.group.value.id, newDescription),
              ),
            ],
          ),
        ),
        if (!isAdmin) _buildLeaveGroupBtn()
      ],
    );
  }

  Padding _buildLeaveGroupBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: fontSize / 2),
      child: TextButton(
        onPressed: () async {
          bool shouldLeave = await _showLeaveGroupConfirmation();
          if (shouldLeave) {
            _groupOperationsController.leaveGroup(group.id);
            Get.toNamed(Routes.home);
          }
        },
        child: Text(
          "Leave Group",
          style: linkTextStyle.copyWith(color: errorColor),
        ),
      ),
    );
  }

  Widget _conditionalEditButton(bool condition, String title, String label, String hintText, String initialValue, Function(String) onSave) {
    return ConditionalEditButton(
      condition: condition,
      title: title,
      label: label,
      hintText: hintText,
      initialValue: initialValue,
      onSave: onSave,
    );
  }

  void _showDayAndTimePicker() async {
    String? initialDay = controller.group.value.meetingDay;
    TimeOfDay? initialTime = controller.group.value.meetingTimeLocal;
    String? selectedDay;

    await Get.dialog(
      AlertDialog(
        title: const Text("Update the meeting day"),
        content: SizedBox(
          height: 100,
          child: CustomDropDown(
            label: "Select a day",
            selectedValue: initialDay,
            items: days,
            onChanged: (selectedValue) {
              selectedDay = selectedValue;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: selectedDay);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    final selectedTime = await showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
    );

    if (selectedDay != null && selectedTime != null) {
      controller.group.value.meetingDay = selectedDay!;
      controller.group.value.meetingTimeLocal = selectedTime;
      controller.updateMeetingDetails(controller.group.value.id, selectedDay!, selectedTime);
    }
  }

  Future<bool> _showLeaveGroupConfirmation() async {
    return await showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm Action"),
              content: const Text("Are you sure you want to leave this group?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Leave"),
                ),
              ],
            );
          },
        ) ??
        false; // The ?? false is to handle the case where the dialog is dismissed
  }
}
