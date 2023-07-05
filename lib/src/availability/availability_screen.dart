import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/common/widgets/snackbar.dart';

class SetAvailabilityScreen extends GetView<AvailabilityController> {
  SetAvailabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Availability'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => ListTile(
                title: Text('Select Timezone'),
                subtitle: DropdownButton<String>(
                  value: controller.selectedTimezone.value,
                  isExpanded: true,
                  items: controller.allTimezones.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedTimezone.value = newValue;
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
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
            ElevatedButton(onPressed: () => controller.saveAvailability(), child: Text("Save")), // replace "YourUserID" with actual user id
          ],
        ),
      ),
    );
  }
}
