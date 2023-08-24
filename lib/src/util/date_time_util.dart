import 'package:flutter/material.dart';

List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String getDayName(int index) {
  return days[index];
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final hours = timeOfDay.hour.toString().padLeft(2, '0');
  final minutes = timeOfDay.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}
