class ListeningExerciseModel {
  final String id;
  final String? lessonId;
  final String title;
  final String audioUrl;
  final String? transcript;

  ListeningExerciseModel({
    required this.id,
    this.lessonId,
    required this.title,
    required this.audioUrl,
    this.transcript,
  });

  factory ListeningExerciseModel.fromJson(Map<String, dynamic> json) {
    return ListeningExerciseModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String?,
      title: json['title'] as String? ?? '',
      audioUrl: json['audio_url'] as String,
      transcript: json['transcript'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'audio_url': audioUrl,
      'transcript': transcript,
    };
  }
}
