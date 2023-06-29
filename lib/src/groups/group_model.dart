class GroupModel {
  String id;
  String category;
  String name;
  String meetingTime;
  int maxMembers;
  int currentMembers;

  GroupModel({
    required this.id,
    required this.category,
    required this.name,
    required this.meetingTime,
    required this.maxMembers,
    required this.currentMembers,
  });

  GroupModel.empty({
    this.id = '',
    this.category = '',
    this.name = '',
    this.meetingTime = "00:00",
    this.maxMembers = 0,
    this.currentMembers = 0,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      meetingTime: json['meeting_time'],
      maxMembers: json['max_members'],
      currentMembers: json['current_members'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'meeting_time': meetingTime,
      'max_members': maxMembers,
      'current_members': currentMembers,
    };
  }
}
