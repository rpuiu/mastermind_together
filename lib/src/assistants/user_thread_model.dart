class UserThreadModel {
  final String? id;
  final String userId;
  final String aiThreadId;

  UserThreadModel({required this.id, required this.userId, required this.aiThreadId});

  factory UserThreadModel.fromJson(Map<String, dynamic> json) {
    return UserThreadModel(
      id: json['id'],
      userId: json['user_id'],
      aiThreadId: json['ai_thread_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ai_thread_id': aiThreadId,
    };
  }
}
