import 'package:intl/intl.dart';

class MessageModel {
  final String id;
  final String? groupId;
  final String? goalId;
  final String userId;
  final String sender;
  final String content;
  final DateTime timestamp;

  String get formattedTime => DateFormat.Hm().format(timestamp.toLocal());

  MessageModel({
    required this.id,
    this.groupId,
    this.goalId,
    required this.userId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      groupId: json['group_id'],
      goalId: json['goal_id'],
      userId: json['user_id'] ?? '',
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'goal_id': goalId,
      'user_id': userId,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
