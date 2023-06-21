class Goal {
  final String id;
  final String userId;
  final String goal;
  final String goalArea;
  final bool autoSelectGroup;

  Goal({
    required this.id,
    required this.userId,
    required this.goal,
    required this.goalArea,
    required this.autoSelectGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'goal': goal,
      'goal_area': goalArea,
      'auto_select': autoSelectGroup,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'],
      goal: json['goal'],
      goalArea: json['goal_area'],
      autoSelectGroup: json['auto_select'],
    );
  }
}
