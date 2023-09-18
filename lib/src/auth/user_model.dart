class UserModel {
  final String id;
  final String email;
  final String timezone;
  final String username;
  final String tenantId;
  final String subscriptionId;
  final String? avatarUrl;
  final OnboardingStatus? onboardingStatus;

  UserModel({
    required this.id,
    required this.email,
    required this.timezone,
    required this.username,
    required this.tenantId,
    required this.subscriptionId,
    this.avatarUrl,
    this.onboardingStatus,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? timezone,
    String? username,
    String? tenantId,
    String? subscriptionId,
    String? avatarUrl,
    OnboardingStatus? onboardingStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      username: username ?? this.username,
      tenantId: tenantId ?? this.tenantId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
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
      'onboarding_status': OnboardingStatus.values[onboardingStatus!.index].name,
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
      onboardingStatus: OnboardingStatus.values.byName(json['onboarding_status']),
    );
  }
}

enum OnboardingStatus {
  none,
  goals,
  availability,
  groups,
  done,
}
