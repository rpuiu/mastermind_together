import 'package:flutter/material.dart';

class DayModel {
  String? id;
  String dayName;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  DayModel({
    this.id,
    required this.dayName,
    this.fromTime,
    this.toTime,
  });

  DayModel.fromDayModel(DayModel dayModel)
      : id = dayModel.id,
        dayName = dayModel.dayName,
        fromTime = dayModel.fromTime != null ? TimeOfDay(hour: dayModel.fromTime!.hour, minute: dayModel.fromTime!.minute) : null,
        toTime = dayModel.toTime != null ? TimeOfDay(hour: dayModel.toTime!.hour, minute: dayModel.toTime!.minute) : null;

  Map<String, dynamic> toJson() {
    final json = {
      'day': dayName,
      'from_time': fromTime != null ? '${fromTime!.hour}:${fromTime!.minute}' : null,
      'to_time': toTime != null ? '${toTime!.hour}:${toTime!.minute}' : null,
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }

  factory DayModel.fromJson(Map<String, dynamic> json) {
    List<int>? fromTimeParts = (json['from_time'] as String?)?.split('+')[0].split(':').map(int.parse).toList();
    List<int>? toTimeParts = (json['to_time'] as String?)?.split('+')[0].split(':').map(int.parse).toList();

    return DayModel(
      id: json['id'],
      dayName: json['day'],
      fromTime: fromTimeParts != null ? TimeOfDay(hour: fromTimeParts[0], minute: fromTimeParts[1]) : null,
      toTime: toTimeParts != null ? TimeOfDay(hour: toTimeParts[0], minute: toTimeParts[1]) : null,
    );
  }
}
