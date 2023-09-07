class UserModel {
  final String id;
  final String email;
  final String timezone;
  final String username;
  final String tenantId;
  final String subscriptionId;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.timezone,
    required this.username,
    required this.tenantId,
    required this.subscriptionId,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? timezone,
    String? username,
    String? tenantId,
    String? subscriptionId,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      username: username ?? this.username,
      tenantId: tenantId ?? this.tenantId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'timezone': timezone,
      'username': username,
      'tenant_id': tenantId,
      'subscription_id': subscriptionId,
      'avatar_url': avatarUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      email: json['email'],
      timezone: json['timezone'],
      username: json['username'],
      tenantId: json['tenant_id'],
      subscriptionId: json['subscription_id'],
      avatarUrl: json['avatar_url'],
    );
  }
}
