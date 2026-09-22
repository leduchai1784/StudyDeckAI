class UserLevelModel {
  final String id;
  final String userId;
  final int level;
  final int currentExp;
  final int totalExp;

  UserLevelModel({
    required this.id,
    required this.userId,
    required this.level,
    required this.currentExp,
    this.totalExp = 0,
  });

  factory UserLevelModel.fromJson(Map<String, dynamic> json) {
    return UserLevelModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      currentExp: json['current_exp'] as int? ?? 0,
      totalExp: json['total_exp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'level': level,
      'current_exp': currentExp,
      'total_exp': totalExp,
    };
  }
}
