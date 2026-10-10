// ignore_for_file: avoid_print, prefer_const_declarations, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studydeck_ai/app/config/supabase_config.dart';

void main() {
  test('Seed Speaking Topics and Questions to Supabase', () async {
    print('================================================================');
    print('🎤 KHỞI ĐỘNG TOOL IMPORT DỮ LIỆU SPEAKING FORECAST LÊN SUPABASE');
    print('================================================================');
    print('📡 Kết nối tới: ${SupabaseConfig.url}');

    final client = SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);

    final jsonFile = File('assets/data/speaking_forecast_part1.json');
    if (!jsonFile.existsSync()) {
      print('❌ Không tìm thấy file assets/data/speaking_forecast_part1.json');
      return;
    }

    final jsonStr = jsonFile.readAsStringSync();
    final List<dynamic> topicList = jsonDecode(jsonStr) as List<dynamic>;
    print('📄 Đọc được ${topicList.length} chủ đề Speaking Part 1 từ file JSON.\n');

    int totalTopicsImported = 0;
    int totalQuestionsImported = 0;

    for (final rawItem in topicList) {
      final item = rawItem as Map<String, dynamic>;
      final topicNumber = (item['topicNumber'] as num).toInt();
      final partNumber = (item['part'] as num?)?.toInt() ?? 1;
      final topicId = 'speaking_p${partNumber}_t$topicNumber';
      final topicTitle = item['topicTitle'] as String? ?? 'Chủ đề $topicNumber';
      final category = item['category'] as String? ?? 'Part 1 Chủ đề';
      final quarter = item['quarter'] as String? ?? 'Quý 3 (Tháng 9–12/2026)';
      final questionsRaw = (item['questions'] as List<dynamic>? ?? []);

      // 1. Upsert speaking_topics
      final topicMap = {
        'id': topicId,
        'topic_number': topicNumber,
        'topic_title': topicTitle,
        'part_number': partNumber,
        'category': category,
        'quarter': quarter,
        'total_questions': questionsRaw.length,
      };

      try {
        await client.from('speaking_topics').upsert(topicMap);
        totalTopicsImported++;
        print('✅ [Topic $topicNumber/44] Đã nạp: $topicTitle (${questionsRaw.length} câu hỏi)');
      } catch (e) {
        print('❌ Lỗi khi nạp chủ đề $topicId: $e');
        print('💡 Nếu bảng chưa tồn tại, vui lòng chạy scratch/supabase_speaking_schema.sql trên Supabase SQL Editor.');
        return;
      }

      // 2. Batch upsert speaking_questions
      final questionsToInsert = <Map<String, dynamic>>[];
      for (int i = 0; i < questionsRaw.length; i++) {
        final qText = questionsRaw[i] as String;
        final qNumber = i + 1;
        final qId = '${topicId}_q$qNumber';

        questionsToInsert.add({
          'id': qId,
          'topic_id': topicId,
          'question_number': qNumber,
          'question_text': qText,
          'vocabulary_hints': [],
        });
      }

      if (questionsToInsert.isNotEmpty) {
        try {
          await client.from('speaking_questions').upsert(questionsToInsert);
          totalQuestionsImported += questionsToInsert.length;
        } catch (e) {
          print('❌ Lỗi khi nạp danh sách câu hỏi của topic $topicId: $e');
        }
      }
    }

    print('\n================================================================');
    print('🎉 TỔNG KẾT QUÁ TRÌNH SEED SPEAKING DỮ LIỆU:');
    print('   - Chủ đề đã nạp: $totalTopicsImported / ${topicList.length}');
    print('   - Câu hỏi đã nạp: $totalQuestionsImported');
    print('================================================================');
  });
}
