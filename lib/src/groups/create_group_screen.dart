import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/widgets/category_dropdown_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/subscription/limit_alert_widget.dart';
import 'package:mastermind_together/src/subscription/subscription_controller.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/scrollable_custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/date_time_util.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class CreateGroupScreen extends GetView<GroupController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubscriptionController _subscriptionController = Get.find<SubscriptionController>();

  CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableCustomScaffold(
      body: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              xHalfSpace,
              const Text("Create a New Group", style: headingText),
              halfSpace,
              const Text("Bring together like-minded individuals and achieve your goals.", style: bodyRegular),
              xxxSpace,
              CategoryDropdown(
                selectedCategory: controller.selectedCategory,
                onCategoryChanged: (String newValue) {
                  controller.group.value.category = newValue;
                  controller.selectedCategory!.value = newValue;
                },
              ),
              xxSpace,
              _buildNameField(),
              xxSpace,
              _buildDayField(),
              xxSpace,
              _buildTimeField(context),
              xxSpace,
              _buildUrlField(),
              xxSpace,
              _buildMaxMembersField(),
              xxxSpace,
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayField() {
    return Obx(
      () => CustomDropDown(
        label: 'Meeting Day',
        hint: 'Please select...',
        selectedValue: controller.selectedDay?.value,
        onChanged: (value) {
          if (value != null) {
            controller.group.value.meetingDay = value;
            controller.selectedDay!.value = value;
          }
        },
        items: days,
        validator: (value) => FormValidators.validateEmpty(value, 'Please select a meeting day'),
      ),
    );
  }

  CustomTextFormField _buildNameField() {
    return CustomTextFormField(
      controller: TextEditingController(),
      label: 'Name',
      hintText: 'E.g. Fitness Enthusiasts',
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
        hintText: 'Please select...',
        onTap: () async {
          final timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (timeOfDay != null) {
            controller.group.value.meetingTimeUTC = timeOfDay;
            controller.meetingTimeController.value.text = formatTimeOfDay(timeOfDay);
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
      hintText: 'E.g. https://zoom.us/j/123456789',
      validator: (value) => FormValidators.validateUrl(value),
      onChanged: (value) => controller.group.value.meetingUrl = value,
    );
  }

  CustomTextFormField _buildMaxMembersField() {
    return CustomTextFormField(
      controller: TextEditingController(),
      label: 'Group Capacity',
      hintText: 'E.g. 10',
      validator: (value) => FormValidators.validateMaxMembers(value),
      keyboardType: TextInputType.number,
      onChanged: (value) => controller.group.value.maxMembers = int.parse(value),
    );
  }

  CustomButton _buildSubmitButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final localContext = context;
          _subscriptionController.canUserCreateGroup().then((canCreate) {
            if (!canCreate) {
              showLimitReachedAlert(localContext);
              return;
            }
            _formKey.currentState!.save();
            controller.createGroup();
            Get.toNamed(Routes.allGroups);
          });
        }
      },
      label: 'Create Group',
      labelTextStyle: buttonTextStyle,
      backgroundColor: buttonBackgroundColor,
    );
  }
}
