import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';

class GroupModel {
  String id;
  String category;
  String name;
  TimeOfDay meetingTimeUTC;
  TimeOfDay meetingTimeLocal;
  String meetingDay;
  int maxMembers;
  int currentMembers;
  String meetingUrl;

  GroupModel({
    required this.id,
    required this.category,
    required this.name,
    required this.meetingTimeUTC,
    required this.meetingTimeLocal,
    required this.meetingDay,
    required this.maxMembers,
    required this.currentMembers,
    required this.meetingUrl,
  });

  GroupModel.empty({
    this.id = '',
    this.category = '',
    this.name = '',
    this.meetingTimeUTC = const TimeOfDay(hour: 0, minute: 0),
    this.meetingTimeLocal = const TimeOfDay(hour: 0, minute: 0),
    this.meetingDay = '',
    this.maxMembers = 0,
    this.currentMembers = 0,
    this.meetingUrl = '',
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    var timeParts = (json['meeting_time'] as String).split(':');
    var utcMeetingTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    var localMeetingTime = Get.find<TimezoneService>().convertToLocalTime(utcMeetingTime);
    return GroupModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      meetingTimeUTC: utcMeetingTime,
      meetingTimeLocal: localMeetingTime,
      meetingDay: json['meeting_day'],
      maxMembers: json['max_members'],
      currentMembers: json['current_members'],
      meetingUrl: json['meeting_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'meeting_time': '${meetingTimeUTC.hour}:${meetingTimeUTC.minute}',
      'meeting_day': meetingDay, // Serialize the meeting day
      'max_members': maxMembers,
      'current_members': currentMembers,
      'meeting_url': meetingUrl,
    };
  }
}
