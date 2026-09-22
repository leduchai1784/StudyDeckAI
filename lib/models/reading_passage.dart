class ReadingPassageModel {
  final String id;
  final String? lessonId;
  final String title;
  final String text;
  final String? level;

  ReadingPassageModel({
    required this.id,
    this.lessonId,
    required this.title,
    required this.text,
    this.level,
  });

  factory ReadingPassageModel.fromJson(Map<String, dynamic> json) {
    return ReadingPassageModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String?,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      level: json['level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'text': text,
      'level': level,
    };
  }
}
