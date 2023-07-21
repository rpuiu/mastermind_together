class UserModel {
  final String id;
  final String email;
  final String timezone;
  final String username;
  final String tenantId;

  UserModel({
    required this.id,
    required this.email,
    required this.timezone,
    required this.username,
    required this.tenantId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'timezone': timezone,
      'username': username,
      'tenant_id': tenantId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      email: json['email'],
      timezone: json['timezone'],
      username: json['username'],
      tenantId: json['tenant_id'],
    );
  }
}
