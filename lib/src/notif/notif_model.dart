class NotificationModel {
  final String id;
  final String userId;
  final String tenantId;
  final String message;
  final String type;
  final bool readStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.tenantId,
    required this.message,
    required this.type,
    required this.readStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tenant_id': tenantId,
      'message': message,
      'type': type,
      'read_status': readStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      tenantId: json['tenant_id'],
      message: json['message'],
      type: json['type'],
      readStatus: json['read_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
