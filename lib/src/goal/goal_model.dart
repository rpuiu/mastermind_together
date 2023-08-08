class GoalModel {
  final String id;
  final String userId;
  final String goal;
  final String category;
  final bool autoSelectGroup;
  final DateTime createdAt;

  GoalModel({
    required this.id,
    required this.userId,
    required this.goal,
    required this.category,
    required this.autoSelectGroup,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'goal': goal,
      'category': category,
      'auto_select_group': autoSelectGroup,
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      userId: json['user_id'],
      goal: json['goal'],
      category: json['category'],
      autoSelectGroup: json['auto_select_group'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
