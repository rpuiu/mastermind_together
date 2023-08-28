enum ActionStatus { pending, inProgress, done }

class ActionModel {
  final String id;
  final String goalId;
  final String description;
  final ActionStatus status;
  final int rank;

  ActionModel({
    required this.id,
    required this.goalId,
    required this.description,
    required this.status,
    required this.rank,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_id': goalId,
      'description': description,
      'status': status.toString().split('.').last,
      'rank': rank,
    };
  }

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      id: json['id'],
      goalId: json['goal_id'],
      description: json['description'],
      status: ActionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ActionStatus.pending,
      ),
      rank: json['rank'] ?? 0,
    );
  }

  ActionModel copyWith({
    String? id,
    String? goalId,
    String? description,
    ActionStatus? status,
    int? rank,
  }) {
    return ActionModel(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      description: description ?? this.description,
      status: status ?? this.status,
      rank: rank ?? this.rank,
    );
  }
}
