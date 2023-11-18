class AIMessageModel {
  final String? id;
  final String userThreadId;
  final String userId;
  final String sender;
  final String content;
  final DateTime timestamp;

  AIMessageModel({
    this.id,
    required this.userThreadId,
    required this.userId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory AIMessageModel.fromJson(Map<String, dynamic> json) {
    return AIMessageModel(
      id: json['id'],
      userThreadId: json['user_thread_id'],
      userId: json['user_id'],
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_thread_id': userThreadId,
      'user_id': userId,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
