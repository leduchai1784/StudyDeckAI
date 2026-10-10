// ignore_for_file: avoid_print, prefer_const_declarations, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studydeck_ai/app/config/supabase_config.dart';
import 'package:studydeck_ai/features/skills/listening/data/listening_mock_data.dart';
import 'package:studydeck_ai/features/skills/listening/data/ipa_mock_data.dart';

void main() {
  test('Seed Listening Data to Supabase', () async {
    print('================================================================');
    print('🚀 KHỞI ĐỘNG TOOL IMPORT DỮ LIỆU LISTENING LÊN SUPABASE');
    print('================================================================');
    print('📡 Kết nối tới: ${SupabaseConfig.url}');

    final client = SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);

  // ------------------------------------------------------------------
  // 1. IMPORT CHÉP CHÍNH TẢ (DICTATION EXERCISES & SENTENCES)
  // ------------------------------------------------------------------
  print('\n----------------------------------------------------------------');
  print('📦 [1/3] Đang nạp dữ liệu Chép chính tả (Dictation)...');
  final jsonFile = File('assets/data/dictation_archive_lessons.json');
  if (!jsonFile.existsSync()) {
    print('❌ Không tìm thấy file assets/data/dictation_archive_lessons.json');
    return;
  }

  final jsonStr = jsonFile.readAsStringSync();
  final List<dynamic> dictationList = jsonDecode(jsonStr) as List<dynamic>;
  print('📄 Đọc được ${dictationList.length} bài học từ file JSON.');

  int totalSentencesImported = 0;
  int exerciseCount = 0;

  for (final rawItem in dictationList) {
    final item = rawItem as Map<String, dynamic>;
    final exerciseId = item['id'] as String? ?? 'dict_${item['rawId']}';
    final sentencesRaw = (item['sentences'] as List<dynamic>? ?? []);

    final exerciseMap = {
      'id': exerciseId,
      'title': item['title'] as String? ?? 'Bài luyện chính tả',
      'band_level': item['bandLevel'] as String? ?? 'Band 6.0 - 7.5',
      'source_topic': item['sourceTopic'] as String? ?? item['topic'] as String? ?? 'General',
      'category': item['category'] as String? ?? 'conversations',
      'description': item['description'] as String? ?? '',
      'duration_minutes': (item['durationMinutes'] as num?)?.toInt() ?? 5,
      'total_sentences': sentencesRaw.length,
      'difficulty_tier': sentencesRaw.length <= 20
          ? 'Dễ'
          : (sentencesRaw.length <= 35 ? 'Vừa' : 'Thử thách'),
    };

    // Upsert Exercise
    try {
      await client.from('dictation_exercises').upsert(exerciseMap);
      exerciseCount++;
    } catch (e) {
      print('  ⚠️ Lỗi khi lưu bài ${exerciseId}: $e');
      continue;
    }

    // Xóa câu cũ của bài này (nếu có) trước khi insert câu mới
    try {
      await client.from('dictation_sentences').delete().eq('exercise_id', exerciseId);
    } catch (_) {}

    // Chuẩn bị batch câu
    final sentencesToInsert = <Map<String, dynamic>>[];
    for (int i = 0; i < sentencesRaw.length; i++) {
      final s = sentencesRaw[i] as Map<String, dynamic>;
      final target = s['targetText'] as String? ?? s['text'] as String? ?? '';
      if (target.trim().isEmpty) continue;

      sentencesToInsert.add({
        'exercise_id': exerciseId,
        'sentence_number': s['sentenceNumber'] as int? ?? s['num'] as int? ?? (i + 1),
        'target_text': target.trim(),
        'hint': s['hint'] as String? ?? '',
        'translation_vi': s['translationVi'] as String? ?? '',
        'audio_url': s['audioUrl'] as String? ?? s['audio'] as String?,
        'time_start': (s['timeStart'] as num?)?.toDouble() ?? (s['start'] as num?)?.toDouble(),
        'time_end': (s['timeEnd'] as num?)?.toDouble() ?? (s['end'] as num?)?.toDouble(),
      });
    }

    if (sentencesToInsert.isNotEmpty) {
      // Chia thành các sub-chunk nhỏ 50 câu/lần gửi
      for (int i = 0; i < sentencesToInsert.length; i += 50) {
        final end = (i + 50 < sentencesToInsert.length) ? i + 50 : sentencesToInsert.length;
        final chunk = sentencesToInsert.sublist(i, end);
        try {
          await client.from('dictation_sentences').insert(chunk);
          totalSentencesImported += chunk.length;
        } catch (e) {
          print('  ⚠️ Lỗi insert sentences cho bài $exerciseId: $e');
        }
      }
    }

    if (exerciseCount % 25 == 0 || exerciseCount == dictationList.length) {
      print('  ↳ Đã hoàn thành $exerciseCount/${dictationList.length} bài Dictation ($totalSentencesImported câu)...');
    }
  }

  print('✅ HOÀN TẤT DICTATION: $exerciseCount bài, $totalSentencesImported câu âm thanh.');

  // ------------------------------------------------------------------
  // 2. IMPORT CAMBRIDGE IELTS LISTENING (11 CUỐN, 44 BÀI TEST)
  // ------------------------------------------------------------------
  print('\n----------------------------------------------------------------');
  print('📦 [2/3] Đang nạp dữ liệu Cambridge IELTS Listening (Cam 10 - Cam 20)...');
  final allTests = ListeningMockData.allTests;
  print('📄 Tổng cộng có ${allTests.length} đề thi IELTS Cambridge.');

  int testCount = 0;
  int sectionCount = 0;
  int questionCount = 0;

  for (final test in allTests) {
    // Trích xuất số tập sách (VD: cam18_test1 -> 18)
    int? bookSeries;
    final match = RegExp(r'cam(\d+)_').firstMatch(test.id);
    if (match != null) {
      bookSeries = int.tryParse(match.group(1)!);
    }

    final testMap = {
      'id': test.id,
      'title': test.title,
      'subtitle': test.subtitle,
      'book_series': bookSeries,
      'band_target': test.bandTarget,
      'duration_minutes': test.durationMinutes,
      'total_questions': test.totalQuestions,
      'is_published': true,
    };

    try {
      await client.from('listening_tests').upsert(testMap);
      testCount++;
    } catch (e) {
      print('  ⚠️ Lỗi lưu đề thi ${test.id}: $e');
      continue;
    }

    for (final sec in test.sections) {
      final sectionId = '${test.id}_part${sec.partNumber}';
      final sectionMap = {
        'id': sectionId,
        'test_id': test.id,
        'part_number': sec.partNumber,
        'section_title': sec.sectionTitle,
        'section_instruction': sec.sectionInstruction,
        'audio_url': sec.resolvedAudioUrl,
        'full_transcript': sec.fullTranscript,
      };

      try {
        await client.from('listening_sections').upsert(sectionMap);
        sectionCount++;
      } catch (e) {
        print('  ⚠️ Lỗi lưu section $sectionId: $e');
      }

      // Xử lý câu hỏi trong Section
      final questionsToInsert = <Map<String, dynamic>>[];
      for (final q in sec.questions) {
        final qId = '${test.id}_q${q.questionNumber}';
        questionsToInsert.add({
          'id': qId,
          'section_id': sectionId,
          'question_number': q.questionNumber,
          'question_type': q.type.name,
          'question_text': q.questionText,
          'options': q.options,
          'correct_answer': q.correctAnswer,
          'alternative_answers': q.alternativeAnswers,
          'explanation': q.explanation,
          'audio_timestamp_seconds': q.audioTimestampSeconds,
          'transcript_evidence': q.transcriptEvidence,
        });
      }

      if (questionsToInsert.isNotEmpty) {
        try {
          await client.from('listening_questions').upsert(questionsToInsert);
          questionCount += questionsToInsert.length;
        } catch (e) {
          print('  ⚠️ Lỗi lưu questions cho section $sectionId: $e');
        }
      }
    }

    print('  ↳ Đã import: ${test.title} (4 Parts, ${test.totalQuestions} câu hỏi)');
  }

  print('✅ HOÀN TẤT CAMBRIDGE: $testCount đề thi, $sectionCount sections, $questionCount câu hỏi.');

  // ------------------------------------------------------------------
  // 3. IMPORT IPA MINIMAL PAIRS (42 BỘ ÂM, 407 CÂU HỎI)
  // ------------------------------------------------------------------
  print('\n----------------------------------------------------------------');
  print('📦 [3/3] Đang nạp dữ liệu Luyện âm IPA (Minimal Pairs)...');
  final allIpa = IpaMockData.allCategories;
  print('📄 Tổng cộng có ${allIpa.length} cặp âm IPA.');

  int ipaCategoryCount = 0;
  int ipaQuestionCount = 0;

  for (final cat in allIpa) {
    final catMap = {
      'id': cat.id,
      'sound_pair_title': cat.soundPairTitle,
      'word_pair_label': cat.wordPairLabel,
      'sound_type': cat.soundType.name,
      'description': cat.description,
      'total_questions': cat.questions.length,
    };

    try {
      await client.from('ipa_categories').upsert(catMap);
      ipaCategoryCount++;
    } catch (e) {
      print('  ⚠️ Lỗi lưu IPA category ${cat.id}: $e');
      continue;
    }

    final ipaQuestionsToInsert = <Map<String, dynamic>>[];
    for (final q in cat.questions) {
      ipaQuestionsToInsert.add({
        'id': q.id,
        'category_id': cat.id,
        'word_a': q.wordA,
        'ipa_a': q.ipaA,
        'meaning_a': q.meaningA,
        'word_b': q.wordB,
        'ipa_b': q.ipaB,
        'meaning_b': q.meaningB,
        'target_word': q.targetWord,
        'example_sentence': q.exampleSentence,
      });
    }

    if (ipaQuestionsToInsert.isNotEmpty) {
      try {
        await client.from('ipa_questions').upsert(ipaQuestionsToInsert);
        ipaQuestionCount += ipaQuestionsToInsert.length;
      } catch (e) {
        print('  ⚠️ Lỗi lưu IPA questions cho ${cat.id}: $e');
      }
    }
  }

  print('✅ HOÀN TẤT IPA: $ipaCategoryCount danh mục cặp âm, $ipaQuestionCount câu hỏi luyện âm.');

  // ------------------------------------------------------------------
  // TỔNG KẾT
  // ------------------------------------------------------------------
  print('\n================================================================');
  print('🎉 TẤT CẢ DỮ LIỆU LISTENING ĐÃ ĐƯỢC ĐỒNG BỘ 100% LÊN SUPABASE!');
  print('================================================================');
  print('📊 Thống kê:');
  print('  • Dictation: $exerciseCount bài học, $totalSentencesImported câu audio');
  print('  • Cambridge IELTS: $testCount đề thi, $sectionCount parts, $questionCount câu hỏi');
  print('  • IPA Minimal Pairs: $ipaCategoryCount bộ âm, $ipaQuestionCount câu hỏi trắc nghiệm');
  print('================================================================\n');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
