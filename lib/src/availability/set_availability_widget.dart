import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/close_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/info_tooltip.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class SetAvailabilityWidget extends GetView<AvailabilityController> {
  const SetAvailabilityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContentState(context);
  }

  Column _buildContentState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: oneColContentWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => _buildTimezoneDropDown(context)),
                xxSpace,
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text("Set Your Daily Availability", style: formLabelTextStyle),
                      InfoTooltip(
                          title: "Why Set Availability?",
                          content:
                              "Select the days and time intervals when you're free for group calls. This helps us find the best accountability groups for you.")
                    ],
                  ),
                ),
                halfSpace,
                Obx(() => _buildDaysList(context)),
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
          icon: const InfoTooltip(
              title: "Why is this important?",
              content:
                  "Your timezone helps us accurately match your availability with others. Ensure you select the correct timezone to prevent scheduling conflicts."),
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
          shape: customBorder,
          color: controller.isSet(day) ? doneColor.withOpacity(0.25) : null,
          child: ListTile(
            shape: customBorder,
            dense: true,
            title: Text(day.dayName.toUpperCase(), style: bodySemiBold),
            subtitle: controller.isSet(day) ? Text('From ${day.fromTime!.format(context)} to ${day.toTime!.format(context)}') : null,
            trailing: _buildTrailingWidget(day),
            onTap: () => _handleDayTap(context, day),
          ),
        );
      }).toList(),
    );
  }

  Widget? _buildTrailingWidget(DayModel day) {
    if (controller.isLoadingAvailability(day)!) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double desiredSize = constraints.maxHeight * 0.7; // Adjust as needed
          return SizedBox(
            height: desiredSize,
            width: desiredSize,
            child: const CircularProgressIndicator(strokeWidth: 3.0),
          );
        },
      );
    }
    if (controller.isSet(day)) {
      return CloseBtn(
        onPressed: () async => await controller.resetAvailability(day),
        iconState: IconState.defaultState,
      );
    }
    return null;
  }

  Future<void> _handleDayTap(BuildContext context, DayModel day) async {
    BuildContext ctx = context;
    controller.selectedDayStatus.value = {day.dayName: true};

    Future<TimeOfDay?> pickTime(TimeOfDay? initialTime, String helpText) {
      return showTimePicker(
        context: ctx,
        initialTime: initialTime ?? const TimeOfDay(hour: 8, minute: 0),
        helpText: helpText,
        initialEntryMode: TimePickerEntryMode.dialOnly,
      );
    }

    final fromTime = await pickTime(day.fromTime, 'From:');
    if (fromTime == null) {
      controller.selectedDayStatus.value = {day.dayName: false};
      return;
    }

    final toTime = await pickTime(day.toTime, 'To:');
    if (toTime == null) {
      controller.selectedDayStatus.value = {day.dayName: false};
      return;
    }

    final fromDuration = Duration(hours: fromTime.hour, minutes: fromTime.minute);
    final toDuration = Duration(hours: toTime.hour, minutes: toTime.minute);

    if (fromDuration.compareTo(toDuration) >= 0) {
      controller.selectedDayStatus.value = {day.dayName: false};
      showErrorSnackBar(message: 'End time should be greater than start time');
      return;
    }

    day.fromTime = fromTime;
    day.toTime = toTime;

    if (day.fromTime != null && day.toTime != null) {
      bool success = await controller.saveAvailability(day);
      if (!success) {
        showErrorSnackBar(message: "There was an error saving your availability for ${day.dayName}. Please try again or refresh the page.");
      }
    }
    controller.selectedDayStatus.value = {day.dayName: false};

    controller.days.refresh();
  }
}
