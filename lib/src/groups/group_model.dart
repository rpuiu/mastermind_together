import 'package:flutter/material.dart';

class GroupModel {
  String id;
  String category;
  String name;
  TimeOfDay meetingTime;
  String meetingDay;
  int maxMembers;
  int currentMembers;
  String meetingUrl;

  GroupModel({
    required this.id,
    required this.category,
    required this.name,
    required this.meetingTime,
    required this.meetingDay,
    required this.maxMembers,
    required this.currentMembers,
    required this.meetingUrl,
  });

  GroupModel.empty({
    this.id = '',
    this.category = '',
    this.name = '',
    this.meetingTime = const TimeOfDay(hour: 0, minute: 0),
    this.meetingDay = '',
    this.maxMembers = 0,
    this.currentMembers = 0,
    this.meetingUrl = '',
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    // Parse the time string into a TimeOfDay object
    var timeParts = (json['meeting_time'] as String).split(':');
    return GroupModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      meetingTime: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      meetingDay: json['meeting_day'],
      // Parse the meeting day
      maxMembers: json['max_members'],
      currentMembers: json['current_members'],
      meetingUrl: json['meeting_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'meeting_time': '${meetingTime.hour}:${meetingTime.minute}',
      'meeting_day': meetingDay, // Serialize the meeting day
      'max_members': maxMembers,
      'current_members': currentMembers,
      'meeting_url': meetingUrl,
    };
  }
}
