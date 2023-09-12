import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/scrollable_custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/close_button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class SetAvailabilityScreen extends GetView<AvailabilityController> {
  static const daysListHeightFactor = 8.0;
  static const daysListHeightMultiplier = 3.0;

  const SetAvailabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableCustomScaffold(
      body: Obx(
        () => controller.isLoading.value ? _buildLoadingState() : _buildContentState(context),
      ),
    );
  }

  Column _buildContentState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        xHalfSpace,
        const Text("Set Your Availability", style: headingText),
        halfSpace,
        const Text("We'll find groups that match your goal and fit your schedule.", style: bodyRegular),
        xxSpace,
        Center(
          child: SizedBox(
            width: oneColContentWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimezoneDropDown(context),
                xxSpace,
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Set Your Daily Availability", style: formLabelTextStyle),
                ),
                halfSpace,
                _buildDaysList(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimezoneDropDown(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
          label: "Timezone",
          icon: _buildInfoIcon(context),
          selectedValue: controller.selectedTimezone.value,
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.selectedTimezone.value = newValue;
            }
          },
          items: controller.allTimezones.value,
        ),
        xxSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text("All times are in ${controller.selectedTimezone.value} timezone", style: labelText),
        ),
      ],
    );
  }

  Widget _buildDaysList(BuildContext context) {
    return Column(
      children: List.generate(controller.days.length, (index) {
        final day = controller.days[index];
        return Card(
          elevation: 0,
          color: controller.isSet(day) ? doneColor.withOpacity(0.25) : null,
          child: ListTile(
            dense: true,
            title: Text(day.dayName.toUpperCase(), style: bodySemiBold),
            subtitle: controller.isSet(day) ? Text('From ${day.fromTime!.format(context)} to ${day.toTime!.format(context)}') : null,
            trailing: controller.isSet(day)
                ? CloseBtn(
                    onPressed: () => controller.resetAvailability(day),
                    iconState: IconState.defaultState,
                  )
                : null,
            onTap: () => _handleDayTap(context, day),
          ),
        );
      }).toList(),
    );
  }

  Center _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  IconButton _buildInfoIcon(BuildContext context) {
    return IconButton(
      icon: AppIcons.getIcon('info', IconState.hoverState),
      hoverColor: Colors.transparent,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Why is this important?"),
            content: const Text(
                "Your timezone helps us accurately match your availability with others. Ensure you select the correct timezone to prevent scheduling conflicts."),
            actions: [
              TextButton(
                child: const Text("Got it!"),
                onPressed: () => Get.back(),
              ),
            ],
            insetPadding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width - 450) / 2),
          ),
        );
      },
    );
  }

  Future<void> _handleDayTap(BuildContext context, DayModel day) async {
    BuildContext ctx = context;

    Future<TimeOfDay?> pickTime(TimeOfDay? initialTime, String helpText) {
      return showTimePicker(
        context: ctx,
        initialTime: initialTime ?? const TimeOfDay(hour: 8, minute: 0),
        helpText: helpText,
        initialEntryMode: TimePickerEntryMode.dialOnly,
      );
    }

    final fromTime = await pickTime(day.fromTime, 'From:');
    if (fromTime == null) return;

    final toTime = await pickTime(day.toTime, 'To:');
    if (toTime == null) return;

    final fromDuration = Duration(hours: fromTime.hour, minutes: fromTime.minute);
    final toDuration = Duration(hours: toTime.hour, minutes: toTime.minute);

    if (fromDuration.compareTo(toDuration) >= 0) {
      showErrorSnackBar(message: 'End time should be greater than start time');
      return;
    }

    day.fromTime = fromTime;
    day.toTime = toTime;

    if (day.fromTime != null && day.toTime != null) {
      bool success = await controller.saveAvailability(day);
      if (success) {
        showSuccessSnackBar(message: "Availability updated for ${day.dayName}");
      } else {
        showErrorSnackBar(message: "There was an error saving your availability for ${day.dayName}. Please try again or refresh the page.");
      }
    }

    controller.days.refresh();
  }
}
