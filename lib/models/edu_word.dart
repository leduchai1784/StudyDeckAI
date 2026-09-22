class EduWord {
  final int id;
  final String title;
  final String viword;
  final String description;
  final String videscription;
  final String transcription;
  final String example;
  final String level;
  final String? customDeckId;

  EduWord({
    required this.id,
    required this.title,
    required this.viword,
    required this.description,
    required this.videscription,
    required this.transcription,
    required this.example,
    required this.level,
    this.customDeckId,
  });

  // Clean and formatted IPA string (always nicely enclosed in /.../)
  String get formattedTranscription {
    if (transcription.isEmpty) return '';
    var cleaned = transcription.trim();
    // Remove any escape slashes
    cleaned = cleaned.replaceAll('\\', '');
    // Normalize square brackets if present [abc] -> abc
    if (cleaned.startsWith('[') && cleaned.endsWith(']')) {
      cleaned = cleaned.substring(1, cleaned.length - 1).trim();
    }
    // Remove duplicate slashes
    cleaned = cleaned.replaceAll('//', '/');
    if (!cleaned.startsWith('/')) {
      cleaned = '/$cleaned';
    }
    if (!cleaned.endsWith('/')) {
      cleaned = '$cleaned/';
    }
    return cleaned;
  }

  factory EduWord.fromJson(Map<String, dynamic> json) {
    final acf = json['acf'] as Map<String, dynamic>? ?? {};
    return EduWord(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      title: (json['title'] as String? ?? '').trim(),
      viword: (acf['viword'] as String? ?? '').trim(),
      description: (acf['description'] as String? ?? '').trim(),
      videscription: (acf['videscription'] as String? ?? '').trim(),
      transcription: (acf['transcription'] as String? ?? '').trim(),
      example: (acf['example'] as String? ?? '').trim(),
      level: (acf['level'] as String?)?.toUpperCase().trim() ?? 'A1',
      customDeckId: (json['custom_deck_id'] ?? acf['custom_deck_id']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'custom_deck_id': customDeckId,
      'acf': {
        'viword': viword,
        'description': description,
        'videscription': videscription,
        'transcription': transcription,
        'example': example,
        'level': level,
        'custom_deck_id': customDeckId,
      }
    };
  }
}
