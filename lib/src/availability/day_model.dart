import 'package:flutter/material.dart';

class DayModel {
  String dayName;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  DayModel({
    required this.dayName,
    this.fromTime,
    this.toTime,
  });

  Map<String, dynamic> toJson() => {
        'day': dayName,
        'from_time': fromTime != null ? '${fromTime!.hour}:${fromTime!.minute}' : null,
        'to_time': toTime != null ? '${toTime!.hour}:${toTime!.minute}' : null,
      };

  factory DayModel.fromJson(Map<String, dynamic> json) {
    final fromTimeParts = json['from_time']?.split(':').map(int.parse).toList();
    final toTimeParts = json['to_time']?.split(':').map(int.parse).toList();

    return DayModel(
      dayName: json['day'],
      fromTime: fromTimeParts != null ? TimeOfDay(hour: fromTimeParts[0], minute: fromTimeParts[1]) : null,
      toTime: toTimeParts != null ? TimeOfDay(hour: toTimeParts[0], minute: toTimeParts[1]) : null,
    );
  }
}
