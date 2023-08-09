class GoalModel {
  final String id;
  final String userId;
  final String goal;
  final String category;
  final String status;
  final DateTime? dueDate;
  final bool autoSelectGroup;
  final DateTime createdAt;
  final DateTime updatedAt;

  GoalModel({
    required this.id,
    required this.userId,
    required this.goal,
    required this.category,
    required this.status,
    required this.dueDate,
    required this.autoSelectGroup,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'goal': goal,
      'category': category,
      'status': status,
      'due_date': dueDate?.toIso8601String(),
      'auto_select_group': autoSelectGroup,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      userId: json['user_id'],
      goal: json['goal'],
      category: json['category'],
      status: json['status'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      autoSelectGroup: json['auto_select_group'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
