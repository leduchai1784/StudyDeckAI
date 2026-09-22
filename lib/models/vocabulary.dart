class VocabularyModel {
  final String id;
  final String? lessonId;
  final String type; // word, grammar
  final String term;
  final String meaning;
  final String? example;
  final String? pronunciation;
  final String? source; // system, ai_generated
  final String? partOfSpeech;
  final String? audioUrl;

  VocabularyModel({
    required this.id,
    this.lessonId,
    required this.type,
    required this.term,
    required this.meaning,
    this.example,
    this.pronunciation,
    this.source = 'system',
    this.partOfSpeech,
    this.audioUrl,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String?,
      type: json['type'] as String? ?? 'word',
      term: json['term'] as String,
      meaning: json['meaning'] as String,
      example: json['example'] as String?,
      pronunciation: json['pronunciation'] as String?,
      source: json['source'] as String?,
      partOfSpeech: json['part_of_speech'] as String?,
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'type': type,
      'term': term,
      'meaning': meaning,
      'example': example,
      'pronunciation': pronunciation,
      'source': source,
      'part_of_speech': partOfSpeech,
      'audio_url': audioUrl,
    };
  }
}
