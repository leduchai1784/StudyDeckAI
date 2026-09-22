class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final int? orderIndex;
  final String? content;
  final DateTime? createdAt;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.orderIndex,
    this.content,
    this.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      orderIndex: json['order_index'] as int?,
      content: json['content'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'order_index': orderIndex,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
