class UserCustomDeck {
  final String id;
  final String name;
  final String description;
  final int colorValue;
  final DateTime createdAt;

  UserCustomDeck({
    required this.id,
    required this.name,
    this.description = '',
    this.colorValue = 0xFF6D28D9, // Deep purple default
    required this.createdAt,
  });

  factory UserCustomDeck.fromJson(Map<String, dynamic> json) {
    return UserCustomDeck(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Bộ thẻ không tên',
      description: json['description'] as String? ?? '',
      colorValue: json['color_value'] as int? ?? 0xFF6D28D9,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color_value': colorValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserCustomDeck copyWith({
    String? id,
    String? name,
    String? description,
    int? colorValue,
    DateTime? createdAt,
  }) {
    return UserCustomDeck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
