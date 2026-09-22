import 'package:dio/dio.dart';
import '../models/edu_word.dart';
import 'flashcard_progress_service.dart';

class EduwordsService {
  final Dio _dio = Dio();
  final FlashcardProgressService _progressService = FlashcardProgressService();
  static const String _apiUrl = 'https://sdata.io.vn/wp-json/scrmai/v1/eduwords';
  static const String _bearerToken = '01KWKATNQGB5TWXYDPJ671X3X1';

  // Fetch words from API
  Future<List<EduWord>> fetchWords() async {
    try {
      final response = await _dio.post(
        _apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_bearerToken',
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> body = response.data is String
            ? (response.data.isEmpty ? {} : response.data)
            : response.data;
        
        final List<dynamic> dataList = body['data'] as List<dynamic>? ?? [];
        return dataList.map((json) => EduWord.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // Fallback offline data if API network call fails
    }
    return _getFallbackWords();
  }

  // Group fetched words by Level (PERSONAL, A1, A2, B1, B2, C1, C2)
  Future<Map<String, List<EduWord>>> fetchWordsByLevel() async {
    final words = await fetchWords();
    final customWords = await _progressService.getCustomWords();
    final favoriteIds = await _progressService.getFavoriteWordIds();

    // Personal deck combines self-added custom words AND favorited/starred words from any level
    final List<EduWord> personalList = [...customWords];
    for (final w in words) {
      if (favoriteIds.contains(w.id) && !personalList.any((e) => e.id == w.id)) {
        personalList.add(w);
      }
    }

    final Map<String, List<EduWord>> grouped = {
      'PERSONAL': personalList,
      'A1': [],
      'A2': [],
      'B1': [],
      'B2': [],
      'C1': [],
      'C2': [],
    };

    for (final word in words) {
      final lvl = word.level.toUpperCase();
      if (grouped.containsKey(lvl)) {
        grouped[lvl]!.add(word);
      } else {
        grouped['A1']!.add(word);
      }
    }

    // Ensure fallback items exist for empty levels
    final fallbackMap = _getFallbackGroupedWords();
    grouped.forEach((key, list) {
      if (key != 'PERSONAL' && list.isEmpty && fallbackMap.containsKey(key)) {
        list.addAll(fallbackMap[key]!);
      }
    });

    return grouped;
  }

  // Fallback vocabulary data for each CEFR level
  List<EduWord> _getFallbackWords() {
    final grouped = _getFallbackGroupedWords();
    return grouped.values.expand((element) => element).toList();
  }

  Map<String, List<EduWord>> _getFallbackGroupedWords() {
    return {
      'A1': [
        EduWord(
          id: 101,
          title: 'Young',
          viword: 'Trẻ, trẻ tuổi',
          description: 'having lived for only a short time; not old',
          videscription: 'chỉ mới sống trong một thời gian ngắn; không già',
          transcription: '/jʌŋ/',
          example: 'She is very young. Young children learn quickly.',
          level: 'A1',
        ),
        EduWord(
          id: 102,
          title: 'Year',
          viword: 'Năm',
          description: 'a period of twelve months',
          videscription: 'một khoảng thời gian mười hai tháng',
          transcription: '/jɪə(r)/',
          example: 'I was born in this year. Next year we travel.',
          level: 'A1',
        ),
        EduWord(
          id: 103,
          title: 'Always',
          viword: 'Luôn luôn',
          description: 'at all times; on every occasion',
          videscription: 'vào mọi lúc; trong mọi dịp',
          transcription: '/ˈɔːlweɪz/',
          example: 'She always gets up early in the morning.',
          level: 'A1',
        ),
        EduWord(
          id: 104,
          title: 'Family',
          viword: 'Gia đình',
          description: 'a group of people who are related to each other',
          videscription: 'nhóm người có quan hệ họ hàng với nhau',
          transcription: '/ˈfæməli/',
          example: 'My family lives in Hanoi.',
          level: 'A1',
        ),
      ],
      'A2': [
        EduWord(
          id: 201,
          title: 'Achieve',
          viword: 'Đạt được, thành tựu',
          description: 'to succeed in reaching a particular goal',
          videscription: 'thành công trong việc đạt được mục tiêu cụ thể',
          transcription: '/əˈtʃiːv/',
          example: 'She worked hard to achieve her goal.',
          level: 'A2',
        ),
        EduWord(
          id: 202,
          title: 'Improve',
          viword: 'Cải thiện, nâng cao',
          description: 'to become better than before',
          videscription: 'trở nên tốt hơn trước đây',
          transcription: '/ɪmˈpruːv/',
          example: 'Daily practice helps improve your vocabulary.',
          level: 'A2',
        ),
        EduWord(
          id: 203,
          title: 'Journey',
          viword: 'Hành trình, chuyến đi',
          description: 'an act of traveling from one place to another',
          videscription: 'hành động di chuyển từ nơi này sang nơi khác',
          transcription: '/ˈdʒɜːni/',
          example: 'Life is a long learning journey.',
          level: 'A2',
        ),
      ],
      'B1': [
        EduWord(
          id: 301,
          title: 'Challenge',
          viword: 'Thử thách, thách thức',
          description: 'a new or difficult task that tests ability',
          videscription: 'nhiệm vụ mới hoặc khó khăn thử thách khả năng',
          transcription: '/ˈtʃælɪndʒ/',
          example: 'Overcoming challenges makes you stronger.',
          level: 'B1',
        ),
        EduWord(
          id: 302,
          title: 'Evaluate',
          viword: 'Đánh giá, định giá',
          description: 'to form an opinion of the value or quality of something',
          videscription: 'đánh giá giá trị hoặc chất lượng của điều gì',
          transcription: '/ɪˈvæljueɪt/',
          example: 'Teachers evaluate student progress periodically.',
          level: 'B1',
        ),
        EduWord(
          id: 303,
          title: 'Maintain',
          viword: 'Duy trì, bảo trì',
          description: 'to make something continue at the same level or standard',
          videscription: 'giữ cho điều gì tiếp tục ở cùng mức độ hoặc chuẩn mực',
          transcription: '/meɪnˈteɪn/',
          example: 'It is important to maintain good study habits.',
          level: 'B1',
        ),
      ],
      'B2': [
        EduWord(
          id: 401,
          title: 'Analyze',
          viword: 'Phân tích',
          description: 'to examine something detailly to understand it',
          videscription: 'nghiên cứu kỹ lưỡng điều gì đó để hiểu rõ nó',
          transcription: '/ˈænəlaɪz/',
          example: 'AI helps analyze learning performance accurately.',
          level: 'B2',
        ),
        EduWord(
          id: 402,
          title: 'Perspective',
          viword: 'Góc nhìn, viễn cảnh',
          description: 'a particular attitude toward or way of regarding something',
          videscription: 'thái độ hoặc cách nhìn nhận một vấn đề',
          transcription: '/pəˈspektɪv/',
          example: 'Reading widely gives you a broad perspective.',
          level: 'B2',
        ),
        EduWord(
          id: 403,
          title: 'Substantial',
          viword: 'Đáng kể, quan trọng',
          description: 'large in amount, value, or importance',
          videscription: 'lớn về số lượng, giá trị hoặc tầm quan trọng',
          transcription: '/səbˈstænʃl/',
          example: 'She made substantial progress in IELTS preparation.',
          level: 'B2',
        ),
      ],
      'C1': [
        EduWord(
          id: 501,
          title: 'Aesthetic',
          viword: 'Thẩm mỹ',
          description: 'relating to beauty or the appreciation of beauty',
          videscription: 'liên quan đến vẻ đẹp hoặc sự thưởng thức cái đẹp',
          transcription: '/iːsˈθetɪk/',
          example: 'The building has great aesthetic appeal.',
          level: 'C1',
        ),
        EduWord(
          id: 502,
          title: 'Aggregate',
          viword: 'Tổng hợp, tổng số',
          description: 'a total number or amount made up of smaller amounts',
          videscription: 'tổng số được tạo thành từ các phần nhỏ kết hợp',
          transcription: '/ˈæɡrɪɡət/',
          example: 'The aggregate score of the team was impressive.',
          level: 'C1',
        ),
        EduWord(
          id: 503,
          title: 'Ambiguous',
          viword: 'Mơ hồ, không rõ ràng',
          description: 'having more than one possible meaning; not clear',
          videscription: 'có nhiều hơn một nghĩa có thể hiểu; không rõ ràng',
          transcription: '/æmˈbɪɡjuəs/',
          example: 'The instructions were ambiguous and confused everyone.',
          level: 'C1',
        ),
        EduWord(
          id: 504,
          title: 'Allocate',
          viword: 'Phân bổ',
          description: 'to give a share of something for a particular purpose',
          videscription: 'cấp phát một phần của điều gì cho mục đích cụ thể',
          transcription: '/ˈæləkeɪt/',
          example: 'We need to allocate resources more efficiently.',
          level: 'C1',
        ),
      ],
      'C2': [
        EduWord(
          id: 601,
          title: 'Quintessential',
          viword: 'Tinh túy, hoàn hảo nhất',
          description: 'representing the most perfect or typical example',
          videscription: 'đại diện cho ví dụ hoàn hảo hoặc điển hình nhất',
          transcription: '/ˌkwɪntɪˈsenʃl/',
          example: 'She is the quintessential modern scholar.',
          level: 'C2',
        ),
        EduWord(
          id: 602,
          title: 'Erudite',
          viword: 'Uẩn súc, bác học',
          description: 'having or showing great knowledge or learning',
          videscription: 'có hoặc thể hiện kiến thức hay sự học hỏi sâu rộng',
          transcription: '/ˈerudaɪt/',
          example: 'The professor delivered an erudite lecture.',
          level: 'C2',
        ),
        EduWord(
          id: 603,
          title: 'Ubiquitous',
          viword: 'Có mặt ở khắp nơi',
          description: 'seeming to be seen or present everywhere',
          videscription: 'dường như xuất hiện hoặc có mặt ở khắp mọi nơi',
          transcription: '/juːˈbɪkwɪtəs/',
          example: 'Smartphones have become ubiquitous in daily life.',
          level: 'C2',
        ),
      ],
    };
  }
}
