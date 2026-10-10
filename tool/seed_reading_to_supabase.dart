// ignore_for_file: avoid_print, prefer_const_declarations, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studydeck_ai/app/config/supabase_config.dart';

void main() {
  test('Seed Reading Tests to Supabase', () async {
    print('================================================================');
    print('🚀 KHỞI ĐỘNG TOOL IMPORT DỮ LIỆU READING LÊN SUPABASE');
    print('================================================================');
    print('📡 Kết nối tới: ${SupabaseConfig.url}');

    final client = SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);

    final dir = Directory('scratch/raw_reading_tests');
    if (!dir.existsSync()) {
      print('❌ Không tìm thấy thư mục scratch/raw_reading_tests');
      return;
    }

    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList();
    // Sắp xếp thứ tự theo tên file (cam-10-1, cam-10-2, ...)
    files.sort((a, b) => a.path.compareTo(b.path));
    print('📄 Tìm thấy ${files.length} file đề Reading sẵn sàng để import.\n');

    int totalTestsImported = 0;
    int totalPassagesImported = 0;
    int totalQuestionsImported = 0;

    for (final file in files) {
      final fileName = file.uri.pathSegments.last;
      try {
        final content = file.readAsStringSync();
        final data = jsonDecode(content) as Map<String, dynamic>;

        final testId = data['testId'] as String;
        final bookSeries = (data['bookSeries'] as num).toInt();
        final testNumber = (data['testNumber'] as num).toInt();
        final title = data['title'] as String? ?? 'Cambridge IELTS $bookSeries Test $testNumber';
        final totalQuestions = (data['totalQuestions'] as num?)?.toInt() ?? 40;
        final passagesRaw = (data['passages'] as List<dynamic>? ?? []);

        // 1. Upsert reading_tests
        final testMap = {
          'id': testId,
          'book_series': bookSeries,
          'test_number': testNumber,
          'title': title,
          'total_questions': totalQuestions,
          'category': 'cambridge',
        };

        await client.from('reading_tests').upsert(testMap);
        totalTestsImported++;

        // 2. Duyệt qua từng Passage
        for (final pRaw in passagesRaw) {
          final p = pRaw as Map<String, dynamic>;
          final passageId = p['youpassId'] as String? ?? '${testId}-${p['partNumber']}';
          final partNumber = (p['partNumber'] as num).toInt();
          final pTitle = p['title'] as String? ?? 'Passage $partNumber';
          final contentHtml = p['contentHtml'] as String? ?? '';
          final category = p['category'] as String?;
          final questionTypes = p['questionTypes'] as List<dynamic>? ?? [];

          final passageMap = {
            'id': passageId,
            'test_id': testId,
            'part_number': partNumber,
            'title': pTitle,
            'content_html': contentHtml,
            'category': category,
            'question_types': questionTypes,
          };

          await client.from('reading_passages').upsert(passageMap);
          totalPassagesImported++;

          // 3. Chuẩn bị batch câu hỏi cho Passage này
          final questionsRaw = (p['questions'] as List<dynamic>? ?? []);
          final questionsToInsert = <Map<String, dynamic>>[];

          for (final qRaw in questionsRaw) {
            final q = qRaw as Map<String, dynamic>;
            final qNumber = (q['number'] as num?)?.toInt() ?? (q['id'] as num).toInt();
            final qId = '${testId}_q$qNumber';

            questionsToInsert.add({
              'id': qId,
              'passage_id': passageId,
              'question_number': qNumber,
              'question_type': q['type'] as String? ?? '',
              'question_text': q['question_text'] as String?,
              'group_html': q['groupHtml'] as String?,
              'group_id': q['groupId'] as String?,
              'question_html': q['questionHtml'] as String?,
              'block_config': q['_blockConfig'],
              'correct_answer': q['correctAnswer'] as String?,
              'explanation': q['explanation'] as String?,
            });
          }

          if (questionsToInsert.isNotEmpty) {
            // Chia chunk nhỏ 50 câu nếu cần
            for (int i = 0; i < questionsToInsert.length; i += 50) {
              final end = (i + 50 < questionsToInsert.length) ? i + 50 : questionsToInsert.length;
              final chunk = questionsToInsert.sublist(i, end);
              await client.from('reading_questions').upsert(chunk);
              totalQuestionsImported += chunk.length;
            }
          }
        }

        print('  ✓ [$fileName] Import thành công ${passagesRaw.length} Passages (${data['totalWithAnswers'] ?? '?'}/$totalQuestions câu có đáp án)');
      } catch (e) {
        print('  ❌ Lỗi khi import file $fileName: $e');
      }
    }

    print('\n================================================================');
    print('🎉 HOÀN THÀNH SEED DỮ LIỆU READING LÊN SUPABASE!');
    print('================================================================');
    print('📊 Thống kê:');
    print('  • Đề thi đã import: $totalTestsImported đề');
    print('  • Bài đọc (Passages): $totalPassagesImported bài');
    print('  • Câu hỏi & đáp án: $totalQuestionsImported câu');
    print('================================================================\n');
  }, timeout: const Timeout(Duration(minutes: 15)));
}
