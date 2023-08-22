import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class SetAvailabilityScreen extends GetView<AvailabilityController> {
  const SetAvailabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => CustomDropDown(
                label: "Timezone",
                selectedValue: controller.selectedTimezone.value,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedTimezone.value = newValue;
                  }
                },
                items: controller.allTimezones.value,
              ),
            ),
            const SizedBox(height: 2 * fontSize),
            Obx(
              () => SizedBox(
                height: 9 * 3 * fontSize, //No particular reason for these numbers, they just looked well at that time
                width: MediaQuery.of(context).size.width * 0.7,
                child: ListView.builder(
                  itemCount: controller.days.length,
                  itemBuilder: (context, index) {
                    final day = controller.days[index];
                    return Card(
                      child: ListTile(
                        title: Text(day.dayName),
                        subtitle:
                            day.fromTime != null && day.toTime != null ? Text('From ${day.fromTime!.format(context)} to ${day.toTime!.format(context)}') : null,
                        onTap: () async {
                          final fromTime = await showTimePicker(
                            context: context,
                            initialTime: day.fromTime ?? TimeOfDay.now(),
                            helpText: 'Select Start Time',
                          );

                          if (fromTime == null) return;

                          final toTime = await showTimePicker(
                            context: context,
                            initialTime: day.toTime ?? TimeOfDay.now(),
                            helpText: 'Select End Time',
                          );

                          if (toTime == null) return;

                          final fromDuration = Duration(hours: fromTime.hour, minutes: fromTime.minute);
                          final toDuration = Duration(hours: toTime.hour, minutes: toTime.minute);

                          if (fromDuration.compareTo(toDuration) >= 0) {
                            showErrorSnackBar(message: 'End time should be greater than start time');
                            return;
                          }

                          day.fromTime = fromTime;
                          day.toTime = toTime;

                          controller.days.refresh();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 2 * fontSize),
            CustomButton(
              onPressed: () async {
                bool success = await controller.saveAvailability();
                if (success) {
                  Get.dialog(
                    AlertDialog(
                      title: const Text("Success"),
                      content: const Text('Your availability has been updated'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Back'),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: const Text('Home'),
                          onPressed: () {
                            Get.back();
                            Get.offAllNamed(Routes.home);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  Get.snackbar("Error", "There was an error saving your availability. Please try again.");
                }
              },
              label: 'Save',
              labelTextStyle: buttonTextStyle,
              backgroundColor: buttonBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
