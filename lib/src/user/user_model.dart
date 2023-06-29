class UserModel {
  final String id;
  final String email;
  final String timezone;

  UserModel({
    required this.id,
    required this.email,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'timezone': timezone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      timezone: json['timezone'],
    );
  }
}
