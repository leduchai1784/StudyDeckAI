class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String role; // Learner, Administrator
  final String? level;
  final String? targetLevel;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.role = 'Learner',
    this.level,
    this.targetLevel,
    this.avatarUrl,
    this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      role: json['role'] as String? ?? 'Learner',
      level: json['level'] as String?,
      targetLevel: json['target_level'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'level': level,
      'target_level': targetLevel,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}
