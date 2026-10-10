import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/speaking_model.dart';
import 'speaking_mock_data.dart';

class SpeakingForecastRepository {
  static List<SpeakingTopic>? _cachedTopics;
  static bool _isLoading = false;

  /// Bản đồ dịch nghĩa tiếng Việt cho 2 chủ đề Part 1 Bắt buộc
  static final Map<int, String> _compulsoryViMap = {
    1: 'Nơi bạn đang sinh sống & Không gian nhà ở',
    2: 'Công việc & Ngành học hiện tại',
  };

  /// Bản đồ dịch nghĩa tiếng Việt cho 44 chủ đề Forecast Part 1 Quý 3/2026
  static final Map<int, String> _topicViMap = {
    1: 'Máy tính & Máy tính bảng',
    2: 'Sở thích sưu tầm đồ vật',
    3: 'Chợ truyền thống / Chợ trời',
    4: 'Du lịch & Những chuyến đi',
    5: 'Thư từ & Viết tay',
    6: 'Đánh mất đồ & Tìm đồ thất lạc',
    7: 'Sự lịch sự & Phép xã giao',
    8: 'Giày dép & Thói quen mua sắm',
    9: 'Quảng cáo & Truyền thông',
    10: 'Trường cấp hai & Kỷ niệm đi học',
    11: 'Rác thải & Tái chế bảo vệ môi trường',
    12: 'Ghi nhớ tên người',
    13: 'Cảm giác mệt mỏi & Nghỉ ngơi',
    14: 'Kính mắt & Kính râm',
    15: 'Ẩm thực & Thói quen ăn uống',
    16: 'Tai nghe & Nghe nhạc',
    17: 'Đồng hồ đeo tay & Quản lý thời gian',
    18: 'Ô tô & Việc lái xe',
    19: 'Trang web & Lướt Internet',
    20: 'Gương soi & Chăm chút bản thân',
    21: 'Công viên & Không gian xanh',
    22: 'Mua sắm & Mua hàng trực tuyến',
    23: 'Giữ gìn không gian gọn gàng',
    24: 'Âm nhạc & Thể loại yêu thích',
    25: 'Thầy cô giáo & Người truyền cảm hứng',
    26: 'Mạng xã hội & Tương tác online',
    27: 'Trang phục & Phong cách thời trang',
    28: 'Phim ảnh & Trải nghiệm xem phim',
    29: 'Giấc mơ & Giấc ngủ sâu',
    30: 'Đô thị & Cuộc sống thành phố lớn',
    31: 'Vũ trụ & Khám phá không gian',
    32: 'Nghệ thuật & Hội họa',
    33: 'Ca hát & Thưởng thức giọng ca',
    34: 'Buổi tối & Sinh hoạt sau giờ học',
    35: 'Kiến trúc cổ & Tòa nhà lịch sử',
    36: 'Thể dục & Hoạt động thể thao',
    37: 'Khoa học & Ứng dụng đời sống',
    38: 'Hài kịch & Tiếng cười',
    39: 'Lịch sử & Di sản văn hóa',
    40: 'Thói quen buổi sáng tràn năng lượng',
    41: 'Học tập & Ngành học',
    42: 'Nhà ở & Không gian sống',
    43: 'Quê hương & Nơi chôn rau cắt rốn',
    44: 'Khu phố & Hàng xóm láng giềng',
  };

  /// Bản đồ dịch nghĩa tiếng Việt cho 66 chủ đề Forecast Part 2 + 3 Quý 3/2026
  static final Map<int, String> _part2ViMap = {
    1: 'Mô tả người mới gặp một lần nhưng muốn kết bạn',
    2: 'Mô tả món quà bạn muốn mua tặng bạn bè',
    3: 'Mô tả lần bạn thay đổi quyết định quan trọng',
    4: 'Mô tả người nổi tiếng tại địa phương bạn',
    5: 'Mô tả quyết định quan trọng mang lại kết quả hài lòng',
    6: 'Mô tả người vượt qua thử thách khó khăn và thành công',
    7: 'Mô tả khóa học để lại ấn tượng sâu sắc',
    8: 'Mô tả lần kiên nhẫn lắng nghe chủ đề bạn không hứng thú',
    9: 'Mô tả người quen có sở thích chụp ảnh',
    10: 'Mô tả kỹ năng mới học được từ thời thơ ấu',
    11: 'Mô tả lần tiết kiệm tiền mua món đồ yêu thích',
    12: 'Mô tả người sống rất ngăn nắp và có kế hoạch',
    13: 'Mô tả trải nghiệm phỏng vấn người nổi tiếng',
    14: 'Mô tả người vui vẻ, lạc quan bạn quen biết',
    15: 'Mô tả bộ phim bạn ít yêu thích nhất',
    16: 'Mô tả người say mê và am hiểu lịch sử',
    17: 'Mô tả buổi tối đáng nhớ bên bạn bè',
    18: 'Mô tả người khéo tay làm đồ thủ công',
    19: 'Mô tả không gian thiên nhiên yên bình bạn thích ghé thăm',
    20: 'Mô tả một nơi ồn ào bạn từng đến',
    21: 'Mô tả người lớn tuổi bạn ngưỡng mộ',
    22: 'Mô tả hoạt động thường làm nhưng thấy lãng phí thời gian',
    23: 'Mô tả địa điểm đông đúc bạn từng đến',
    24: 'Mô tả lần nhận được dịch vụ chăm sóc khách hàng tốt',
    25: 'Mô tả thành phố bạn từng ghé và muốn quay lại',
    26: 'Mô tả nơi có âm nhạc bạn không thích',
    27: 'Mô tả trải nghiệm khiến bạn tự hào',
    28: 'Mô tả không gian yên tĩnh bạn muốn tìm đến',
    29: 'Mô tả chuyến đi xa bạn hay đi nhưng không thích',
    30: 'Mô tả bữa tiệc tổ chức sau sự kiện đặc biệt',
    31: 'Mô tả sự thay đổi tích cực gần đây của bạn',
    32: 'Mô tả lần bạn thay đổi quan điểm cá nhân quan trọng',
    33: 'Mô tả đạo luật bảo vệ môi trường bạn biết',
    34: 'Mô tả mục tiêu dài hạn bạn nỗ lực đạt được',
    35: 'Mô tả lần gửi tin nhắn/email mãi không thấy hồi âm',
    36: 'Mô tả cuốn sách hoặc câu chuyện về loài vật',
    37: 'Mô tả quảng cáo có sự tham gia của người nổi tiếng',
    38: 'Mô tả địa điểm du lịch bạn muốn giới thiệu cho người khác',
    39: 'Mô tả sự cố công nghệ phức tạp bạn từng đối mặt',
    40: 'Mô tả người có năng khiếu học và nói ngoại ngữ',
    41: 'Mô tả món ăn đặc biệt vào dịp lễ hội',
    42: 'Mô tả sự kiện thể thao trực tiếp bạn từng theo dõi',
    43: 'Mô tả người muốn theo đuổi ngành y tế (bác sĩ/y tá)',
    44: 'Mô tả trải nghiệm làm việc nhóm hiệu quả',
    45: 'Mô tả doanh nhân kinh doanh thành đạt bạn biết',
    46: 'Mô tả người thích trồng cây và chăm sóc vườn',
    47: 'Mô tả video thú vị bạn từng xem',
    48: 'Mô tả tòa nhà cao tầng bạn thích hoặc không thích',
    49: 'Mô tả địa điểm tẻ nhạt bạn từng đến',
    50: 'Mô tả kế hoạch bạn phải thay đổi gần đây',
    51: 'Mô tả luật mới bạn muốn ban hành ở quốc gia mình',
    52: 'Mô tả quyết định quan trọng bạn từng đưa ra',
    53: 'Mô tả người bạn thân từ thời thơ ấu',
    54: 'Mô tả lần bị kẹt xe nghiêm trọng trong thời gian dài',
    55: 'Mô tả chuyến đi chơi thú vị mà ít tốn kém',
    56: 'Mô tả lần bạn tổ chức thành công một sự kiện vui vẻ',
    57: 'Mô tả chiếc bánh đặc biệt bạn nhận được từ người khác',
    58: 'Mô tả phương pháp bạn áp dụng để học ngoại ngữ',
    59: 'Mô tả nơi bạn muốn đến vào thời gian rảnh rỗi',
    60: 'Mô tả nhân viên làm việc tại công ty thành công',
    61: 'Mô tả con sông hoặc hồ nước quan trọng ở nước bạn',
    62: 'Mô tả ngôi nhà bạn thích ghé thăm nhưng không muốn ở',
    63: 'Mô tả luật môi trường bạn muốn đất nước áp dụng',
    64: 'Mô tả mẩu tin tức địa phương thu hút sự chú ý',
    65: 'Mô tả lần bạn thức dậy thật sớm vào buổi sáng',
    66: 'Mô tả nhà của một người bạn bạn thích nhưng không muốn sống ở đó',
  };

  /// Phân loại 44 chủ đề Part 1 vào 4 nhóm chuẩn theo yêu cầu:
  static String getCategoryForTopicNumber(int topicNumber) {
    const dailyLifeNumbers = {3, 5, 6, 10, 13, 14, 20, 21, 22, 23, 34, 40, 41, 42, 43, 44};
    if (dailyLifeNumbers.contains(topicNumber)) return 'daily_life';

    const hobbiesNumbers = {2, 4, 8, 15, 24, 27, 28, 32, 33, 36, 38};
    if (hobbiesNumbers.contains(topicNumber)) return 'hobbies_lifestyle';

    const societyNumbers = {1, 9, 11, 16, 18, 19, 26, 30, 31, 35, 37, 39};
    if (societyNumbers.contains(topicNumber)) return 'society_tech';

    const abstractNumbers = {7, 12, 17, 25, 29};
    if (abstractNumbers.contains(topicNumber)) return 'abstract_skills';

    return 'daily_life';
  }

  /// Phân loại 66 chủ đề Part 2 + 3 vào 4 nhóm chuẩn:
  static String getCategoryForPart2Topic(int topicNumber) {
    const hobbiesNumbers = {2, 9, 15, 17, 18, 26, 30, 36, 38, 41, 42, 47, 55, 56, 57, 59};
    if (hobbiesNumbers.contains(topicNumber)) return 'hobbies_lifestyle';

    const societyNumbers = {4, 6, 13, 16, 33, 35, 37, 39, 43, 45, 51, 60, 63, 64};
    if (societyNumbers.contains(topicNumber)) return 'society_tech';

    const abstractNumbers = {3, 5, 8, 10, 12, 21, 27, 31, 32, 34, 40, 44, 50, 52, 58};
    if (abstractNumbers.contains(topicNumber)) return 'abstract_skills';

    return 'daily_life';
  }

  /// Nạp toàn bộ dữ liệu Forecast Speaking (Part 1 Bắt buộc, Part 1 Chủ đề, Part 2 & 3)
  static Future<void> ensureLoaded() async {
    if (_cachedTopics != null) return;
    if (_isLoading) {
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 30));
      }
      return;
    }

    _isLoading = true;
    try {
      final resultList = <SpeakingTopic>[];

      // 1. NẠP PART 1 BẮT BUỘC (2 CHỦ ĐỀ: Where you live now, Work / Study)
      try {
        final p1CompulsoryStr = await rootBundle.loadString('assets/data/speaking_forecast_part1_compulsory.json');
        final List<dynamic> p1CompulsoryList = jsonDecode(p1CompulsoryStr) as List<dynamic>;

        for (final rawItem in p1CompulsoryList) {
          final item = rawItem as Map<String, dynamic>;
          final topicNumber = (item['topicNumber'] as num).toInt();
          final topicTitle = item['topicTitle'] as String? ?? 'Chủ đề bắt buộc $topicNumber';
          final topicId = 'speaking_p1_compulsory_$topicNumber';
          final questionsRaw = (item['questions'] as List<dynamic>? ?? []);

          final titleVi = _compulsoryViMap[topicNumber] ?? topicTitle;

          final questions = <SpeakingQuestion>[];
          for (int i = 0; i < questionsRaw.length; i++) {
            final qText = questionsRaw[i] as String;
            questions.add(
              SpeakingQuestion(
                id: '${topicId}_q${i + 1}',
                part: SpeakingPart.part1,
                questionText: qText,
                ideaHints: const [
                  'Direct Answer: Trả lời thẳng vào trọng tâm câu hỏi trong 1 câu đầu.',
                  'Explanation: Mở rộng lý do hoặc tần suất diễn ra hành động.',
                  'Personal Example: Minh họa cụ thể bằng trải nghiệm thực tế của bạn.',
                ],
                usefulVocab: const [],
                sampleAnswerBand8: '',
                audioDurationSeconds: 30,
              ),
            );
          }

          resultList.add(
            SpeakingTopic(
              id: topicId,
              quarter: 'Q3-2026',
              title: topicTitle,
              titleVi: titleVi,
              categoryTag: 'daily_life',
              bandTarget: 'Band 6.0 - 8.5',
              tagLabel: 'BẮT BUỘC THI',
              partNumber: 1,
              isCompulsory: true,
              viewsCount: 42000 + topicNumber * 1200,
              questions: questions,
            ),
          );
        }
      } catch (e) {
        debugPrint('[SpeakingForecastRepository] Lỗi nạp Part 1 Compulsory: $e');
      }

      // 2. NẠP PART 1 CHỦ ĐỀ (44 CHỦ ĐỀ)
      try {
        final jsonStr = await rootBundle.loadString('assets/data/speaking_forecast_part1.json');
        final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;

        for (final rawItem in list) {
          final item = rawItem as Map<String, dynamic>;
          final topicNumber = (item['topicNumber'] as num).toInt();
          final topicTitle = item['topicTitle'] as String? ?? 'Chủ đề $topicNumber';
          final topicId = 'speaking_p1_t$topicNumber';
          final questionsRaw = (item['questions'] as List<dynamic>? ?? []);

          final categoryTag = getCategoryForTopicNumber(topicNumber);
          final isHotTrend = topicNumber == 1 || topicNumber == 4 || topicNumber == 26 || topicNumber == 19;
          final tagLabel = isHotTrend ? 'HOT TREND · QUÝ 3' : 'DỰ ĐOÁN QUÝ 3';

          final titleVi = _topicViMap[topicNumber] ?? topicTitle;

          final questions = <SpeakingQuestion>[];
          for (int i = 0; i < questionsRaw.length; i++) {
            final qText = questionsRaw[i] as String;
            questions.add(
              SpeakingQuestion(
                id: '${topicId}_q${i + 1}',
                part: SpeakingPart.part1,
                questionText: qText,
                ideaHints: const [
                  'Direct Answer: Trả lời thẳng vào trọng tâm câu hỏi trong 1 câu đầu.',
                  'Explanation: Mở rộng lý do hoặc tần suất diễn ra hành động.',
                  'Personal Example: Minh họa cụ thể bằng một trải nghiệm của chính bạn.',
                ],
                usefulVocab: const [],
                sampleAnswerBand8: '',
                audioDurationSeconds: 30,
              ),
            );
          }

          resultList.add(
            SpeakingTopic(
              id: topicId,
              quarter: 'Q3-2026',
              title: topicTitle,
              titleVi: titleVi,
              categoryTag: categoryTag,
              bandTarget: 'Band 6.0 - 8.0',
              tagLabel: tagLabel,
              partNumber: 1,
              isCompulsory: false,
              viewsCount: 15000 + topicNumber * 350,
              questions: questions,
            ),
          );
        }
      } catch (e) {
        debugPrint('[SpeakingForecastRepository] Lỗi nạp Part 1 Topics: $e');
      }

      // 3. NẠP PART 2 + 3 (66 CHỦ ĐỀ CUE CARD & FOLLOW-UP)
      try {
        final p2Str = await rootBundle.loadString('assets/data/speaking_forecast_part2_3.json');
        final List<dynamic> p2List = jsonDecode(p2Str) as List<dynamic>;

        for (final rawItem in p2List) {
          final item = rawItem as Map<String, dynamic>;
          final topicNumber = (item['topicNumber'] as num).toInt();
          final topicTitle = item['topicTitle'] as String? ?? 'Chủ đề Part 2 $topicNumber';
          final topicId = 'speaking_p23_t$topicNumber';
          final cuePrompts = (item['cueCardPrompts'] as List<dynamic>? ?? []).cast<String>();
          final p3Questions = (item['part3Questions'] as List<dynamic>? ?? []).cast<String>();

          final categoryTag = getCategoryForPart2Topic(topicNumber);
          final titleVi = _part2ViMap[topicNumber] ?? topicTitle;

          final questions = <SpeakingQuestion>[];

          // Câu 1: Part 2 Cue Card chính
          questions.add(
            SpeakingQuestion(
              id: '${topicId}_cue',
              part: SpeakingPart.part2,
              questionText: topicTitle,
              cueCardPrompts: cuePrompts.isNotEmpty ? cuePrompts : null,
              ideaHints: const [
                'Introduction: Giới thiệu hoàn cảnh, nhân vật hoặc sự kiện trong 1-2 câu đầu.',
                'Development: Kể chi tiết diễn biến, các điểm nổi bật theo gợi ý trên Cue Card.',
                'Reflection: Nêu cảm xúc và bài học/ấn tượng sâu sắc bạn rút ra.',
              ],
              usefulVocab: const [],
              sampleAnswerBand8: '',
              audioDurationSeconds: 120, // 2 phút cho Part 2
            ),
          );

          // Các câu tiếp theo: Part 3 Discussion questions
          for (int i = 0; i < p3Questions.length; i++) {
            questions.add(
              SpeakingQuestion(
                id: '${topicId}_p3_q${i + 1}',
                part: SpeakingPart.part3,
                questionText: p3Questions[i],
                ideaHints: const [
                  'Direct Stance: Nêu rõ quan điểm của bạn về vấn đề xã hội/tổng quan.',
                  'Analysis & Evidence: Phân tích 2 góc nhìn hoặc nêu dẫn chứng thực tế.',
                  'Broader Context: Mở rộng xu hướng tương lai hoặc bài học chung.',
                ],
                usefulVocab: const [],
                sampleAnswerBand8: '',
                audioDurationSeconds: 45,
              ),
            );
          }

          resultList.add(
            SpeakingTopic(
              id: topicId,
              quarter: 'Q3-2026',
              title: topicTitle,
              titleVi: titleVi,
              categoryTag: categoryTag,
              bandTarget: 'Band 6.5 - 8.5',
              tagLabel: 'PART 2 & 3',
              partNumber: 2,
              isCompulsory: false,
              viewsCount: 22000 + topicNumber * 410,
              questions: questions,
            ),
          );
        }
      } catch (e) {
        debugPrint('[SpeakingForecastRepository] Lỗi nạp Part 2+3: $e');
      }

      // Giữ lại các chủ đề Q2 từ Mock Data để người dùng chuyển tab Quý 2 vẫn đầy đủ
      for (final mockTopic in SpeakingMockData.forecastTopics) {
        if (mockTopic.quarter == 'Q2-2026') {
          resultList.add(mockTopic);
        }
      }

      _cachedTopics = resultList;
    } catch (e) {
      debugPrint('[SpeakingForecastRepository] Lỗi nạp forecast: $e');
      _cachedTopics = SpeakingMockData.forecastTopics;
    } finally {
      _isLoading = false;
    }
  }

  /// Lấy danh sách tất cả các chủ đề Forecast (Part 1 Bắt buộc, Part 1 Chủ đề, Part 2 & 3)
  static List<SpeakingTopic> getAllTopics() {
    return _cachedTopics ?? SpeakingMockData.forecastTopics;
  }

  /// Tìm chủ đề theo ID
  static SpeakingTopic? getTopicById(String id) {
    final list = getAllTopics();
    for (final t in list) {
      if (t.id == id) return t;
    }
    return null;
  }
}
