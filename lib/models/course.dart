class CourseModel {
  final String id;
  final String title;
  final String? topic;
  final String? level;
  final String? description;
  final String? thumbnailUrl;
  final DateTime? createdAt;

  CourseModel({
    required this.id,
    required this.title,
    this.topic,
    this.level,
    this.description,
    this.thumbnailUrl,
    this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      topic: json['topic'] as String?,
      level: json['level'] as String?,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'topic': topic,
      'level': level,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
