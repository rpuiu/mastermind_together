import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/dropdown/dropdown_widget.dart';

class SetAvailabilityScreen extends GetView<AvailabilityController> {
  const SetAvailabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Availability'),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(fontSize / 2),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
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
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.days.length,
                      itemBuilder: (context, index) {
                        final day = controller.days[index];
                        return Card(
                          child: ListTile(
                            title: Text(day.dayName),
                            subtitle: day.fromTime != null && day.toTime != null
                                ? Text('From ${day.fromTime!.format(context)} to ${day.toTime!.format(context)}')
                                : null,
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
                                Get.back(); // close the dialog, stay on the current screen
                              },
                            ),
                            TextButton(
                              child: const Text('Home'),
                              onPressed: () {
                                Get.back(); // close the dialog
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
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
