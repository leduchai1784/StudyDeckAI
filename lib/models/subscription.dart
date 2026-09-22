class SubscriptionModel {
  final String id;
  final String userId;
  final String planName;
  final String status;
  final DateTime? renewedAt;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planName,
    this.status = 'active',
    this.renewedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      planName: json['plan_name'] as String,
      status: json['status'] as String? ?? 'active',
      renewedAt: json['renewed_at'] != null ? DateTime.parse(json['renewed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_name': planName,
      'status': status,
      'renewed_at': renewedAt?.toIso8601String(),
    };
  }
}
