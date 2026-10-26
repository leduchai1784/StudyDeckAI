class GrammarQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const GrammarQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionText': questionText,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
      };

  factory GrammarQuestion.fromJson(Map<String, dynamic> json) =>
      GrammarQuestion(
        id: json['id'] as String,
        questionText: json['questionText'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String,
      );
}

class GrammarTheoryRow {
  final String title;
  final String usage;
  final String formula;
  final String example;

  const GrammarTheoryRow({
    required this.title,
    required this.usage,
    required this.formula,
    required this.example,
  });
  Map<String, dynamic> toJson() => {
        'title': title,
        'usage': usage,
        'formula': formula,
        'example': example,
      };

  factory GrammarTheoryRow.fromJson(Map<String, dynamic> json) =>
      GrammarTheoryRow(
        title: json['title'] as String? ?? '',
        usage: json['usage'] as String? ?? '',
        formula: json['formula'] as String? ?? '',
        example: json['example'] as String? ?? '',
      );
}

class GrammarTheorySection {
  final String sectionTitle;
  final String overview;
  final List<GrammarTheoryRow> rows;
  final List<String> examTips;

  const GrammarTheorySection({
    required this.sectionTitle,
    required this.overview,
    required this.rows,
    this.examTips = const [],
  });

  Map<String, dynamic> toJson() => {
        'sectionTitle': sectionTitle,
        'overview': overview,
        'rows': rows.map((r) => r.toJson()).toList(),
        'examTips': examTips,
      };

  factory GrammarTheorySection.fromJson(Map<String, dynamic> json) =>
      GrammarTheorySection(
        sectionTitle: json['sectionTitle'] as String? ?? '',
        overview: json['overview'] as String? ?? '',
        rows: (json['rows'] as List<dynamic>?)
                ?.map((r) => GrammarTheoryRow.fromJson(r as Map<String, dynamic>))
                .toList() ??
            const [],
        examTips: (json['examTips'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );
}

class GrammarLessonModel {
  final String id;
  final String slug;
  final String title;
  final String titleEn;
  final String titleVi;
  final String category; // 'reference' (Toàn tập 25 chủ đề) hoặc 'advanced' (Nâng cao theo Band)
  final String bandText; // e.g. 'Band 4.0 - 5.5', 'Band 6.0 - 7.0', 'Band 7.5+'
  final int durationMinutes;
  final int questionCount;
  final List<GrammarTheorySection> theorySections;
  final List<GrammarQuestion> questions;

  const GrammarLessonModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.titleEn,
    required this.titleVi,
    required this.category,
    required this.bandText,
    this.durationMinutes = 15,
    required this.questionCount,
    required this.theorySections,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'titleEn': titleEn,
        'titleVi': titleVi,
        'category': category,
        'bandText': bandText,
        'durationMinutes': durationMinutes,
        'questionCount': questionCount,
        'theorySections': theorySections.map((s) => s.toJson()).toList(),
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  factory GrammarLessonModel.fromJson(Map<String, dynamic> json) =>
      GrammarLessonModel(
        id: json['id'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        title: json['title'] as String? ?? '',
        titleEn: json['titleEn'] as String? ?? '',
        titleVi: json['titleVi'] as String? ?? '',
        category: json['category'] as String? ?? 'reference',
        bandText: json['bandText'] as String? ?? '',
        durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 15,
        questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
        theorySections: (json['theorySections'] as List<dynamic>?)
                ?.map((s) =>
                    GrammarTheorySection.fromJson(s as Map<String, dynamic>))
                .toList() ??
            const [],
        questions: (json['questions'] as List<dynamic>?)
                ?.map((q) => GrammarQuestion.fromJson(q as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
