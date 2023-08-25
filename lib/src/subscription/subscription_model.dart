class SubscriptionModel {
  String id;
  String name;
  double price;
  int durationInDays;
  String description;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInDays,
    required this.description,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      durationInDays: json['duration_in_days'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'duration_in_days': durationInDays,
      'description': description,
    };
  }
}
