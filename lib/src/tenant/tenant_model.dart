class Tenant {
  final String tenantId;
  final String name;
  final String hostname;

  Tenant({
    required this.tenantId,
    required this.name,
    required this.hostname,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tenant_id'] = tenantId;
    data['name'] = name;
    data['hostname'] = hostname;
    return data;
  }

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      tenantId: json['tenant_id'],
      name: json['name'],
      hostname: json['hostname'],
    );
  }
}
