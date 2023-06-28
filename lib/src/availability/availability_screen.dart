import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';

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
