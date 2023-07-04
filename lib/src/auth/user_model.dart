class UserModel {
  final String userId;
  final String email;
  final String timezone;

  UserModel({
    required this.userId,
    required this.email,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'timezone': timezone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      email: json['email'],
      timezone: json['timezone'],
    );
  }
}
