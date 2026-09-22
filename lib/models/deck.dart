class DeckModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final bool isAiGenerated;
  final DateTime? createdAt;
  final int cardCount;

  DeckModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.isAiGenerated = false,
    this.createdAt,
    this.cardCount = 0,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isAiGenerated: json['is_ai_generated'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      cardCount: json['card_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'is_ai_generated': isAiGenerated,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
