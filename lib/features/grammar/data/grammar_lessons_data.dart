import '../models/grammar_lesson_model.dart';

class GrammarLessonsData {
  static List<GrammarLessonModel> getAllLessons() => _allLessons;

  static List<GrammarLessonModel> getReferenceLessons() =>
      _allLessons.where((l) => l.category == 'reference').toList();

  static List<GrammarLessonModel> getAdvancedLessons() =>
      _allLessons.where((l) => l.category == 'advanced').toList();

  static GrammarLessonModel? getLessonById(String id) {
    try {
      return _allLessons.firstWhere((l) => l.id == id || l.slug == id);
    } catch (_) {
      return null;
    }
  }

  static final List<GrammarLessonModel> _allLessons = [
    // ==========================================
    // 1. NGỮ PHÁP TOÀN TẬP (Grammar Reference - 25 Chủ đề)
    // ==========================================
    const GrammarLessonModel(
      id: 'grm_01_word_forms',
      slug: 'grm-word-forms',
      title: 'Word Forms — Dạng thức từ',
      titleEn: 'Word Forms',
      titleVi: 'Dạng thức từ & Cấu tạo từ loại',
      category: 'reference',
      bandText: 'Band 4.0 - 6.0',
      durationMinutes: 15,
      questionCount: 303,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Quy tắc vị trí Danh từ, Động từ, Tính từ & Trạng từ',
          overview:
              'Trong bài thi IELTS (đặc biệt là Reading và Writing), nhận diện đúng từ loại (Noun, Verb, Adjective, Adverb) giúp bạn chọn đúng dạng từ khi viết và điền từ vào bài tóm tắt.',
          rows: [
            GrammarTheoryRow(
              title: 'Danh từ (Noun)',
              usage: 'Đứng đầu câu làm Chủ ngữ (S), sau Động từ làm Tân ngữ (O), sau Tính từ sở hữu và Mạo từ (a/an/the).',
              formula: 'a/an/the + (Adj) + Noun | Prep + Noun',
              example: 'The rapid industrialization has caused severe environmental degradation.',
            ),
            GrammarTheoryRow(
              title: 'Tính từ (Adjective)',
              usage: 'Đứng trước Danh từ bổ nghĩa cho Noun, hoặc đứng sau Linking Verbs (be, seem, appear, become).',
              formula: 'Linking Verb + Adj | Adj + Noun',
              example: 'Renewable energy is significantly beneficial for long-term sustainable development.',
            ),
            GrammarTheoryRow(
              title: 'Trạng từ (Adverb)',
              usage: 'Bổ nghĩa cho Động từ thường, Tính từ, Trạng từ khác hoặc đứng đầu câu bổ nghĩa cả mệnh đề.',
              formula: 'Verb + Adv | Adv + Adj | Adv, S + V + O',
              example: 'The government successfully implemented innovative economic strategies.',
            ),
          ],
          examTips: [
            'Hậu tố danh từ phổ biến: -tion, -ment, -ness, -ity, -ance/-ence, -ship.',
            'Hậu tố tính từ: -ful, -less, -ive, -ous, -able/-ible, -al, -ic.',
            'Hậu tố trạng từ: hầu hết là Tính từ + -ly (ngoại lệ: friendly, lovely là tính từ).',
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'wf_q1',
          questionText:
              'The company has demonstrated an exceptional commitment to __________ sustainable farming practices.',
          options: ['promote', 'promotion', 'promoting', 'promoter'],
          correctIndex: 2,
          explanation:
              'Sau giới từ "to" trong cấu trúc "commitment to doing sth" (cam kết làm gì), ta cần một danh động từ V-ing ("promoting") để đi kèm tân ngữ "sustainable farming practices".',
        ),
        GrammarQuestion(
          id: 'wf_q2',
          questionText:
              'Over the past decade, technological advancements have __________ transformed the modern workspace.',
          options: ['dramatic', 'dramatically', 'dramatize', 'drama'],
          correctIndex: 1,
          explanation:
              'Vị trí đứng giữa trợ động từ "have" và động từ chính phân từ hai "transformed" cần một Trạng từ (Adverb) để bổ nghĩa cho động từ "transformed". Đáp án đúng là "dramatically".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_02_tenses',
      slug: 'grm-tenses',
      title: 'Tenses — Các thì trong tiếng Anh',
      titleEn: 'English Tenses',
      titleVi: 'Hệ thống 12 thì ứng dụng IELTS',
      category: 'reference',
      bandText: 'Band 4.5 - 6.5',
      durationMinutes: 18,
      questionCount: 150,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Ứng dụng các thì trọng điểm trong IELTS Writing & Speaking',
          overview:
              'Trong IELTS Writing Task 1, thì Quá khứ đơn (Past Simple) và Hiện tại hoàn thành (Present Perfect) xuất hiện liên tục khi phân tích số liệu biểu đồ. Trong Task 2, Hiện tại đơn dùng để bàn về sự thật khách quan và quan điểm học thuật.',
          rows: [
            GrammarTheoryRow(
              title: 'Hiện tại đơn (Present Simple)',
              usage: 'Diễn tả chân lý khoa học, quy luật tự nhiên, số liệu bảng biểu không mốc thời gian quá khứ.',
              formula: 'S + V(s/es) | S + do/does not + V',
              example: 'Carbon emissions contribute significantly to global temperature rise.',
            ),
            GrammarTheoryRow(
              title: 'Quá khứ đơn (Past Simple)',
              usage: 'Phân tích các số liệu, chu kỳ đã diễn ra và kết thúc trong quá khứ (Writing Task 1).',
              formula: 'S + V-ed/V2 | S + did not + V-inf',
              example: 'Between 2000 and 2010, the proportion of car owners rose dramatically.',
            ),
            GrammarTheoryRow(
              title: 'Hiện tại hoàn thành (Present Perfect)',
              usage: 'Hành động bắt đầu từ quá khứ và vẫn tiếp diễn/ảnh hưởng đến hiện tại (since, over the past decade).',
              formula: 'S + have/has + V3/V-ed',
              example: 'Renewable technologies have experienced steady expansion over the past ten years.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'tn_q1',
          questionText:
              'Between 2005 and 2015, the global consumption of fossil fuels __________ by nearly 18 percent.',
          options: ['increased', 'has increased', 'is increasing', 'increases'],
          correctIndex: 0,
          explanation:
              'Có mốc thời gian xác định hoàn toàn trong quá khứ "Between 2005 and 2015", nên động từ bắt buộc chia ở thì Quá khứ đơn (Past Simple) -> "increased".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_03_passive',
      slug: 'grm-passive',
      title: 'Passive Voice — Câu bị động',
      titleEn: 'Passive Voice',
      titleVi: 'Thể bị động học thuật trong Writing',
      category: 'reference',
      bandText: 'Band 5.0 - 6.5',
      durationMinutes: 15,
      questionCount: 120,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Cách sử dụng Thể bị động để tăng tính khách quan',
          overview:
              'Trong văn phong học thuật IELTS (Academic Writing), việc dùng Thể bị động giúp bài viết khách quan, trang trọng, nhấn mạnh vào hành động và đối tượng chịu tác động thay vì chủ thể thực hiện.',
          rows: [
            GrammarTheoryRow(
              title: 'Bị động cơ bản (Basic Passive)',
              usage: 'Biến tân ngữ thành chủ ngữ khi người thực hiện hành động không quan trọng hoặc hiển nhiên.',
              formula: 'S + be + V3/ed + (by O)',
              example: 'Substantial funds were allocated to public healthcare infrastructure.',
            ),
            GrammarTheoryRow(
              title: 'Bị động khách quan (Impersonal Passive)',
              usage: 'Trình bày ý kiến, quan điểm xã hội một cách trung lập trong Writing Task 2.',
              formula: 'It is widely believed / argued / proven that + Clause',
              example: 'It is widely argued that strict regulations should be imposed on carbon emissions.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'pv_q1',
          questionText:
              'It is frequently __________ that academic qualifications alone cannot guarantee career success.',
          options: ['argue', 'arguing', 'argued', 'argument'],
          correctIndex: 2,
          explanation:
              'Cấu trúc bị động khách quan: "It is + V3/ed + that...". Do đó ta cần phân từ hai "argued" (Người ta thường lập luận rằng...).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_04_relative_clauses',
      slug: 'grm-relative-clauses',
      title: 'Relative Clauses — Mệnh đề quan hệ',
      titleEn: 'Relative Clauses',
      titleVi: 'Mệnh đề quan hệ xác định & không xác định',
      category: 'reference',
      bandText: 'Band 5.0 - 6.5',
      durationMinutes: 16,
      questionCount: 110,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Cấu tạo mệnh đề quan hệ & Rút gọn mệnh đề',
          overview:
              'Sử dụng mệnh đề quan hệ là tiêu chí trực tiếp giúp nâng điểm Grammatical Range & Accuracy trong cả Speaking và Writing.',
          rows: [
            GrammarTheoryRow(
              title: 'Mệnh đề quan hệ',
              usage: 'Bổ nghĩa cho danh từ đứng trước.',
              formula: 'N + who/which/that + V + O',
              example: 'Individuals who exercise regularly tend to have better mental resilience.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'rc_q1',
          questionText:
              'Employees __________ adapt quickly to changing market conditions are highly valued by corporate leaders.',
          options: ['which', 'who', 'whom', 'whose'],
          correctIndex: 1,
          explanation:
              'Đại từ quan hệ thay thế cho danh từ chỉ người làm chủ ngữ ("Employees") và đứng trước động từ "adapt" là "who".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_05_comparatives',
      slug: 'grm-comparatives',
      title: 'Comparatives & Superlatives — So sánh',
      titleEn: 'Comparatives & Superlatives',
      titleVi: 'Cấu trúc so sánh hơn, so sánh nhất & so sánh kép',
      category: 'reference',
      bandText: 'Band 5.0 - 6.5',
      durationMinutes: 15,
      questionCount: 90,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'So sánh trong IELTS Writing Task 1',
          overview: 'Viết Task 1 bắt buộc phải có các cấu trúc so sánh hơn, gấp nhiều lần và so sánh kép.',
          rows: [
            GrammarTheoryRow(
              title: 'So sánh hơn',
              usage: 'So sánh 2 đối tượng hoặc 2 xu hướng.',
              formula: 'Adj-er / more + Adj + than',
              example: 'Expenditure on education was significantly higher than that on defense.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'cp_q1',
          questionText: 'The proportion of urban residents is __________ higher than in rural sectors.',
          options: ['substantially', 'substance', 'substantial', 'substantiate'],
          correctIndex: 0,
          explanation: 'Bổ nghĩa cho tính từ so sánh hơn "higher" ta dùng trạng từ chỉ mức độ "substantially".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_06_complex_sentences',
      slug: 'grm-complex-sentences',
      title: 'Complex Sentences — Câu phức',
      titleEn: 'Complex Sentences',
      titleVi: 'Cấu trúc câu phức nâng điểm Writing',
      category: 'reference',
      bandText: 'Band 6.0 - 7.0',
      durationMinutes: 16,
      questionCount: 85,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Liên từ phụ thuộc tạo câu phức',
          overview: 'Sử dụng Although, While, Whereas, Because, Since để liên kết ý.',
          rows: [
            GrammarTheoryRow(
              title: 'Mệnh đề nhượng bộ',
              usage: 'Nêu sự đối lập logic giữa 2 vế câu.',
              formula: 'Although / While / Whereas + S + V, S + V',
              example: 'Although renewable energy requires high initial capital, its long-term gains are undeniable.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'cs_q1',
          questionText: '__________ online education provides great flexibility, face-to-face interaction remains vital.',
          options: ['Despite', 'Although', 'Because of', 'In spite'],
          correctIndex: 1,
          explanation: 'Sau "Although" là một mệnh đề hoàn chỉnh (S + V). "Despite" đòi hỏi Noun/V-ing.',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_07_nouns',
      slug: 'grm-nouns',
      title: 'Nouns — Danh từ',
      titleEn: 'Nouns & Countability',
      titleVi: 'Danh từ đếm được, không đếm được & Cụm danh từ',
      category: 'reference',
      bandText: 'Band 4.5 - 6.0',
      durationMinutes: 14,
      questionCount: 75,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Danh từ đếm được và không đếm được trong IELTS',
          overview: 'Phân biệt Information, Advice, Equipment (không đếm được, không thêm -s).',
          rows: [
            GrammarTheoryRow(
              title: 'Danh từ không đếm được học thuật',
              usage: 'Không dùng với a/an, không có dạng số nhiều.',
              formula: 'much / a large amount of + Uncountable Noun',
              example: 'Substantial research has shown the benefits of early childhood bilingualism.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'no_q1',
          questionText: 'Modern scientific __________ requires extensive cross-border collaboration.',
          options: ['researches', 'research', 'researching', 'researched'],
          correctIndex: 1,
          explanation: '"Research" là danh từ không đếm được trong tiếng Anh chuẩn, không chia số nhiều "researches".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_08_advanced',
      slug: 'grm-advanced',
      title: 'Advanced Grammar — Ngữ pháp nâng cao',
      titleEn: 'Advanced Grammar Structures',
      titleVi: 'Tổng hợp các cấu trúc band 7.0+',
      category: 'reference',
      bandText: 'Band 7.0 - 8.0',
      durationMinutes: 20,
      questionCount: 90,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Cấu trúc tạo ấn tượng học thuật',
          overview: 'Sử dụng Cleft sentences, Subjunctive, và Ellipsis trong IELTS.',
          rows: [
            GrammarTheoryRow(
              title: 'Cleft Sentence',
              usage: 'Nhấn mạnh thành phần chủ chốt của câu.',
              formula: 'It is/was X that/who + V...',
              example: 'It is comprehensive education that empowers marginalized communities.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'ag_q1',
          questionText: 'It is through proactive civic engagement __________ sustainable progress is achieved.',
          options: ['which', 'that', 'what', 'where'],
          correctIndex: 1,
          explanation: 'Cấu trúc câu chẻ nhấn mạnh: "It is + Cụm từ + THAT + Mệnh đề".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_09_conditionals',
      slug: 'grm-conditionals',
      title: 'Conditionals — Câu điều kiện',
      titleEn: 'Conditionals',
      titleVi: 'Câu điều kiện loại 1, 2, 3 & Đảo ngữ If',
      category: 'reference',
      bandText: 'Band 5.0 - 7.0',
      durationMinutes: 16,
      questionCount: 95,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Câu điều kiện đề xuất giải pháp Task 2',
          overview: 'If clause loại 1 và 2 giúp đưa ra các giải pháp khả thi trong bài luận.',
          rows: [
            GrammarTheoryRow(
              title: 'Điều kiện loại 2',
              usage: 'Giả định sự việc trái với thực tế hiện tại.',
              formula: 'If + S + were/V-ed, S + would/could + V-inf',
              example: 'If every citizen sorted household waste, landfills would be dramatically reduced.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'cd_q1',
          questionText: 'If strict penalties __________ imposed on polluters, companies would be more cautious.',
          options: ['are', 'were', 'had been', 'will be'],
          correctIndex: 1,
          explanation: 'Mệnh đề chính dùng "would be" (loại 2), do đó vế If dùng quá khứ giả định "were".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_10_modals',
      slug: 'grm-modals',
      title: 'Modal Verbs — Động từ khiếm khuyết',
      titleEn: 'Modal Verbs',
      titleVi: 'Kỹ thuật Hedging & Giảm sắc thái tuyệt đối hoá',
      category: 'reference',
      bandText: 'Band 5.5 - 7.0',
      durationMinutes: 15,
      questionCount: 80,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Kỹ thuật Hedging trong Academic Writing',
          overview: 'Thay vì dùng "will" chắc chắn, dùng may/might/could/is likely to để câu văn học thuật.',
          rows: [
            GrammarTheoryRow(
              title: 'Hedging',
              usage: 'Tránh khẳng định quá đà, tăng tính cẩn trọng khoa học.',
              formula: 'may/might/could + V-inf | is likely to + V',
              example: 'Early exposure to reading may enhance linguistic competency in adulthood.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'mv_q1',
          questionText: 'Technological disruption __________ lead to significant structural unemployment.',
          options: ['is', 'may', 'has', 'would to'],
          correctIndex: 1,
          explanation: '"May" đứng trước động từ nguyên mẫu "lead" để thể hiện khả năng dự đoán học thuật.',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_11_reported_speech',
      slug: 'grm-reported-speech',
      title: 'Reported Speech — Câu tường thuật',
      titleEn: 'Reported Speech',
      titleVi: 'Trích dẫn và tường thuật quan điểm học thuật',
      category: 'reference',
      bandText: 'Band 5.0 - 6.5',
      durationMinutes: 15,
      questionCount: 70,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Động từ dẫn luận (Reporting Verbs)',
          overview: 'Dùng claim, argue, contend, demonstrate, assert thay vì say/tell.',
          rows: [
            GrammarTheoryRow(
              title: 'Reporting Verbs',
              usage: 'Tường thuật nghiên cứu hoặc luận điểm của chuyên gia.',
              formula: 'Researchers argue that + Clause',
              example: 'Economists contend that fiscal incentives stimulate innovation.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'rs_q1',
          questionText: 'Leading scientists __________ that immediate action is indispensable.',
          options: ['said to', 'asserted', 'told that', 'spoke that'],
          correctIndex: 1,
          explanation: '"Assert that + Clause" (khẳng định rằng) là động từ dẫn luận học thuật chuẩn.',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_12_questions',
      slug: 'grm-questions',
      title: 'Question Forms — Các dạng câu hỏi',
      titleEn: 'Question Forms',
      titleVi: 'Cấu trúc câu hỏi & Câu hỏi gián tiếp',
      category: 'reference',
      bandText: 'Band 4.5 - 6.0',
      durationMinutes: 14,
      questionCount: 65,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Câu hỏi trong IELTS Speaking',
          overview: 'Trả lời lưu loát các dạng Wh-questions và câu hỏi gián tiếp.',
          rows: [
            GrammarTheoryRow(
              title: 'Indirect Question',
              usage: 'Tạo câu hỏi lịch sự, tự nhiên trong Speaking Part 3.',
              formula: 'Could you explain how + S + V?',
              example: 'I wonder why modern society places such high value on material wealth.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'qf_q1',
          questionText: 'Many citizens question how the new policy __________ their daily commute.',
          options: ['will affect', 'will it affect', 'affects it', 'does affect'],
          correctIndex: 0,
          explanation: 'Trong mệnh đề danh ngữ / câu hỏi gián tiếp, thứ tự từ là Khẳng định: "how + S + V" -> "will affect".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_13_participle_clauses',
      slug: 'grm-participle-clauses',
      title: 'Participle Clauses — Mệnh đề phân từ',
      titleEn: 'Participle Clauses',
      titleVi: 'Mệnh đề phân từ V-ing và Having V3',
      category: 'reference',
      bandText: 'Band 6.5 - 8.0',
      durationMinutes: 18,
      questionCount: 85,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Rút gọn 2 mệnh đề có cùng chủ ngữ',
          overview: 'Dùng V-ing (chủ động) hoặc V3/ed (bị động) ở đầu câu để tạo phong cách báo chí, học thuật.',
          rows: [
            GrammarTheoryRow(
              title: 'Present Participle (V-ing)',
              usage: 'Rút gọn nguyên nhân - kết quả cùng chủ ngữ.',
              formula: 'V-ing + O, S + V...',
              example: 'Recognizing the urgency of global warming, nations ratified the climate treaty.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'pc_q1',
          questionText: '__________ the adverse side effects, doctors discontinued the experimental treatment.',
          options: ['Observed', 'Observing', 'To observe', 'Observation'],
          correctIndex: 1,
          explanation: 'Bác sĩ là chủ thể thực hiện hành động quan sát (chủ động) -> Dùng Present Participle "Observing".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_14_linking_words',
      slug: 'grm-linking-words',
      title: 'Linking Words & Discourse Markers — Từ nối & liên kết',
      titleEn: 'Linking Words & Markers',
      titleVi: 'Từ nối học thuật tăng tiêu chí Coherence & Cohesion',
      category: 'reference',
      bandText: 'Band 5.5 - 7.5',
      durationMinutes: 16,
      questionCount: 120,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Từ nối học thuật chuẩn IELTS',
          overview: 'Furthermore, Moreover, Consequently, Conversely, In contrast, Nonetheless.',
          rows: [
            GrammarTheoryRow(
              title: 'Từ nối kết quả',
              usage: 'Dùng để chỉ hệ quả logic.',
              formula: 'S + V. Consequently, S + V.',
              example: 'Public transit was expanded. Consequently, traffic congestion dropped by 20%.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'lw_q1',
          questionText: 'Electric cars produce zero tailpipe emissions. __________, they still depend on the power grid.',
          options: ['Consequently', 'However', 'Therefore', 'Furthermore'],
          correctIndex: 1,
          explanation: 'Thể hiện mối quan hệ tương phản đối lập giữa 2 câu -> Dùng "However".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_15_pronouns',
      slug: 'grm-pronouns',
      title: 'Pronouns — Đại từ',
      titleEn: 'Pronouns & Referencing',
      titleVi: 'Kỹ thuật tham chiếu đại từ (Referencing) trong Reading & Writing',
      category: 'reference',
      bandText: 'Band 4.5 - 6.0',
      durationMinutes: 14,
      questionCount: 65,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Đại từ chỉ định và tham chiếu',
          overview: 'This, That, These, Those, Former, Latter giúp tránh lặp từ.',
          rows: [
            GrammarTheoryRow(
              title: 'This / These + Summary Noun',
              usage: 'Tóm tắt ý đoạn trước.',
              formula: 'These trends / This phenomenon',
              example: 'Birth rates have declined globally. This trend presents challenges for pension systems.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'pn_q1',
          questionText: 'Between nuclear and coal energy, the __________ is much less carbon-intensive.',
          options: ['former', 'formally', 'firstly', 'format'],
          correctIndex: 0,
          explanation: '"The former" dùng để chỉ đối tượng được nhắc đến trước tiên (ở đây là nuclear energy).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_16_determiners',
      slug: 'grm-determiners',
      title: 'Determiners — Từ hạn định',
      titleEn: 'Determiners & Articles',
      titleVi: 'Mạo từ A, An, The & Lượng từ',
      category: 'reference',
      bandText: 'Band 4.5 - 6.5',
      durationMinutes: 15,
      questionCount: 75,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Sử dụng mạo từ The chính xác',
          overview: 'Dùng "The" trước tên quốc gia có số nhiều/liên bang (the UK, the US, the Netherlands).',
          rows: [
            GrammarTheoryRow(
              title: 'Mạo từ xác định The',
              usage: 'Chỉ đối tượng đã xác định hoặc duy nhất.',
              formula: 'The + Noun',
              example: 'The environment has suffered from unconstrained industrial expansion.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'dt_q1',
          questionText: 'Life expectancy in __________ United Kingdom has steadily climbed over decades.',
          options: ['a', 'an', 'the', '—'],
          correctIndex: 2,
          explanation: 'Tên quốc gia có từ "United" bắt buộc đi kèm mạo từ "the" -> "the United Kingdom".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_17_sv_agreement',
      slug: 'grm-sv-agreement',
      title: 'Subject–Verb Agreement — Hoà hợp chủ vị',
      titleEn: 'Subject–Verb Agreement',
      titleVi: 'Quy tắc hoà hợp giữa chủ ngữ và động từ trong câu dài',
      category: 'reference',
      bandText: 'Band 5.0 - 6.5',
      durationMinutes: 16,
      questionCount: 85,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Bẫy chủ vị trong câu có mệnh đề phụ xen kẽ',
          overview: 'Xác định chủ ngữ thực sự khi có cụm giới từ xen giữa (The number of, A variety of).',
          rows: [
            GrammarTheoryRow(
              title: 'The number of vs A number of',
              usage: '"The number of" chia số ít, "A number of" chia số nhiều.',
              formula: 'The number of + N(pl) + V(singular)',
              example: 'The number of international students has surged exponentially.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'sv_q1',
          questionText: 'The number of electric vehicles on roads __________ dramatically in recent years.',
          options: ['has increased', 'have increased', 'increasing', 'are increasing'],
          correctIndex: 0,
          explanation: 'Chủ ngữ là "The number of..." nên động từ chia ở ngôi thứ 3 số ít -> "has increased".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_18_imperatives',
      slug: 'grm-imperatives',
      title: 'Imperatives — Câu mệnh lệnh',
      titleEn: 'Imperatives & Instructions',
      titleVi: 'Câu chỉ dẫn trong Listening Section 2 và hướng dẫn kỹ thuật',
      category: 'reference',
      bandText: 'Band 4.0 - 5.5',
      durationMinutes: 12,
      questionCount: 50,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Nghe hiểu hướng dẫn trong IELTS Listening',
          overview: 'Các chỉ dẫn trong bản đồ (Map labelling) và quy trình hoạt động.',
          rows: [
            GrammarTheoryRow(
              title: 'Câu mệnh lệnh chỉ đường',
              usage: 'Turn left, proceed straight, ensure that...',
              formula: 'V-inf + (O)...',
              example: 'Turn left at the reception and proceed along the corridor.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'im_q1',
          questionText: 'To navigate the campus library, __________ the main staircase to the second floor.',
          options: ['take', 'taking', 'taken', 'takes'],
          correctIndex: 0,
          explanation: 'Câu mệnh lệnh hướng dẫn bắt đầu bằng động từ nguyên thể không "to" -> "take".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_19_cleft_emphasis',
      slug: 'grm-cleft-emphasis',
      title: 'Cleft Sentences & Emphasis — Câu chẻ & nhấn mạnh',
      titleEn: 'Cleft Sentences & Emphasis',
      titleVi: 'Kỹ thuật nhấn mạnh luận điểm Band 7.5+',
      category: 'reference',
      bandText: 'Band 7.0 - 8.5',
      durationMinutes: 18,
      questionCount: 65,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'What-cleft và It-cleft',
          overview: 'What society requires is..., It is government regulation that...',
          rows: [
            GrammarTheoryRow(
              title: 'Pseudo-cleft (What-clause)',
              usage: 'Tập trung sự chú ý vào giải pháp cốt tử.',
              formula: 'What + S + need/require + is + Noun/To-V',
              example: 'What developing nations need most is equitable access to international markets.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'ce_q1',
          questionText: 'What modern enterprises require __________ employees with adaptive thinking.',
          options: ['is', 'are', 'were', 'being'],
          correctIndex: 0,
          explanation: 'Mệnh đề Wh-clause làm chủ ngữ được xem như ngôi thứ 3 số ít -> Động từ to be là "is".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_20_parallelism_ellipsis',
      slug: 'grm-parallelism-ellipsis',
      title: 'Parallelism & Ellipsis — Song song & tỉnh lược',
      titleEn: 'Parallelism & Ellipsis',
      titleVi: 'Cấu trúc song song và tỉnh lược câu văn học thuật',
      category: 'reference',
      bandText: 'Band 6.5 - 8.0',
      durationMinutes: 16,
      questionCount: 60,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Cấu trúc song song (Parallel Structure)',
          overview: 'Các vế nối bằng and/or/as well as phải cùng dạng từ loại.',
          rows: [
            GrammarTheoryRow(
              title: 'Song song từ loại',
              usage: 'Noun and Noun | V-ing, V-ing, and V-ing',
              formula: 'A, B, and C (cùng loại)',
              example: 'The program focuses on recruiting, training, and retaining skilled engineers.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'pe_q1',
          questionText: 'Effective managers excel at delegating tasks, motivating teams, and __________ clear objectives.',
          options: ['establishing', 'establish', 'established', 'establishment'],
          correctIndex: 0,
          explanation: 'Cấu trúc song song dạng V-ing: "delegating..., motivating..., and establishing...".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_21_punctuation',
      slug: 'grm-punctuation',
      title: 'Punctuation — Dấu câu trong IELTS',
      titleEn: 'Punctuation in Writing',
      titleVi: 'Dấu phẩy, chấm phẩy và dấu gạch nối trong Writing',
      category: 'reference',
      bandText: 'Band 5.5 - 7.5',
      durationMinutes: 15,
      questionCount: 55,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Tránh lỗi Comma Splice',
          overview: 'Không nối 2 mệnh đề độc lập chỉ bằng dấu phẩy; phải dùng chấm phẩy hoặc liên từ fanboys.',
          rows: [
            GrammarTheoryRow(
              title: 'Semicolon (Chấm phẩy)',
              usage: 'Nối 2 câu có liên hệ mật thiết.',
              formula: 'Clause 1; Clause 2',
              example: 'Solar energy is sustainable; fossil fuels are finite.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'pu_q1',
          questionText: 'Renewable energy adoption is growing; __________, storage costs remain a challenge.',
          options: ['however', 'although', 'because', 'whereas'],
          correctIndex: 0,
          explanation: 'Sau dấu chấm phẩy và trước dấu phẩy là trạng từ liên kết "however".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_22_common_mistakes',
      slug: 'grm-common-mistakes',
      title: 'Common Grammar Mistakes — Lỗi ngữ pháp thường gặp',
      titleEn: 'Common Grammar Mistakes',
      titleVi: 'Các bẫy lỗi sai khiến thí sinh mất điểm band 6.0',
      category: 'reference',
      bandText: 'Band 5.0 - 6.5',
      durationMinutes: 18,
      questionCount: 110,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Top lỗi sai ngữ pháp người Việt hay gặp',
          overview: 'Thiếu mạo từ, dùng sai giới từ, nhầm lẫn số ít/số nhiều.',
          rows: [
            GrammarTheoryRow(
              title: 'Lỗi nhầm giới từ',
              usage: 'depend on (không dùng with), contribute to (không dùng in).',
              formula: 'contribute to + V-ing/Noun',
              example: 'Unhealthy diets contribute to chronic ailments.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'cm_q1',
          questionText: 'Deforestation contributes significantly __________ biodiversity loss.',
          options: ['to', 'with', 'in', 'for'],
          correctIndex: 0,
          explanation: 'Động từ "contribute" luôn đi kèm giới từ "to" ("contribute to sth": đóng góp/gây ra cái gì).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_23_sentence_transformation',
      slug: 'grm-sentence-transformation',
      title: 'Sentence Transformation — Biến đổi câu',
      titleEn: 'Sentence Paraphrasing',
      titleVi: 'Kỹ thuật Paraphrase câu văn cho Writing & Speaking',
      category: 'reference',
      bandText: 'Band 6.0 - 7.5',
      durationMinutes: 18,
      questionCount: 90,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: '4 Kỹ thuật Paraphrase câu hỏi đề thi',
          overview: 'Dùng từ đồng nghĩa, chuyển chủ động sang bị động, đổi từ loại, dùng cấu trúc giả định.',
          rows: [
            GrammarTheoryRow(
              title: 'Chuyển đổi dạng từ',
              usage: 'Biến câu có động từ thành câu có cụm danh từ.',
              formula: 'S + V + Adv  ===>  There was an Adj + Noun in S',
              example: 'The number rose sharply. ===> There was a sharp rise in the number.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'st_q1',
          questionText: 'Between 2010 and 2020, there was a __________ in consumer spending.',
          options: ['dramatic increase', 'dramatically increase', 'dramatically increased', 'dramatic increasing'],
          correctIndex: 0,
          explanation: 'Sau "there was a [Tính từ] [Danh từ]" -> "dramatic increase" (sự gia tăng đáng kể).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_24_ielts_structures',
      slug: 'grm-ielts-structures',
      title: 'Common IELTS Grammar Structures — Cấu trúc IELTS thường gặp',
      titleEn: 'IELTS Essential Structures',
      titleVi: 'Tổng hợp mẫu câu kinh điển cho Writing Task 1 & Task 2',
      category: 'reference',
      bandText: 'Band 6.0 - 7.5',
      durationMinutes: 18,
      questionCount: 95,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Mẫu câu mở đầu và phát triển luận điểm',
          overview: 'It is evident that..., There is no doubt that..., Given the fact that...',
          rows: [
            GrammarTheoryRow(
              title: 'Cấu trúc Task 1 Overview',
              usage: 'Tóm lược xu hướng chung của biểu đồ.',
              formula: 'Overall, it is readily apparent that + Clause',
              example: 'Overall, it is readily apparent that renewable energy output experienced sustained growth.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'is_q1',
          questionText: 'It is readily apparent __________ renewable power output surged over the analyzed timeframe.',
          options: ['that', 'which', 'what', 'where'],
          correctIndex: 0,
          explanation: 'Cấu trúc mệnh đề giả chủ ngữ: "It is readily apparent that + Clause" (Rõ ràng nhận thấy rằng...).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'grm_25_collocations',
      slug: 'grm-collocations',
      title: 'Collocations & Fixed Expressions — Cụm cố định & Collocations',
      titleEn: 'Collocations & Fixed Expressions',
      titleVi: 'Cụm từ kết hợp tự nhiên nâng điểm Lexical Resource',
      category: 'reference',
      bandText: 'Band 6.0 - 7.5',
      durationMinutes: 18,
      questionCount: 130,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Collocations học thuật phổ biến',
          overview: 'Pose a threat, take measures, bridge the gap, play an indispensable role.',
          rows: [
            GrammarTheoryRow(
              title: 'Động từ + Danh từ',
              usage: 'Các cặp từ luôn đi liền với nhau.',
              formula: 'Verb + Collocated Noun',
              example: 'Authorities must implement rigorous measures to mitigate pollution.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'cl_q1',
          questionText: 'Education plays an __________ role in eradicating societal inequality.',
          options: ['indispensable', 'indispensably', 'indispensability', 'indispense'],
          correctIndex: 0,
          explanation: 'Cụm Collocation kinh điển: "play an indispensable role in" (đóng vai trò không thể thiếu trong).',
        ),
      ],
    ),

    // ==========================================
    // 2. ADVANCED GRAMMAR (Chuyên Đề Nâng Cao Theo Band)
    // ==========================================
    const GrammarLessonModel(
      id: 'b2_tenses_v2',
      slug: 'b2-tenses-v2',
      title: '[B2] Tenses — Advanced',
      titleEn: 'Advanced Tenses & Aspects',
      titleVi: 'Luyện tập chuyên sâu 12 thì tiếng Anh trong tình huống thực tế IELTS',
      category: 'advanced',
      bandText: 'Band 6.0 - 7.0',
      durationMinutes: 18,
      questionCount: 75,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Các thì kết hợp phức tạp',
          overview: 'Phối hợp thì Past Perfect, Future Perfect trong mô tả dự báo và nguyên nhân quá khứ.',
          rows: [
            GrammarTheoryRow(
              title: 'Tương lai hoàn thành (Future Perfect)',
              usage: 'Dự báo cột mốc hoàn thành trước một thời điểm trong tương lai (By 2050...).',
              formula: 'By + mốc tương lai, S + will have + V3/ed',
              example: 'By 2050, clean energy will have replaced fossil fuels in major urban centers.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'b2_q1',
          questionText: 'By the year 2040, solar technology __________ substantial breakthroughs.',
          options: ['will have achieved', 'will achieve', 'has achieved', 'achieved'],
          correctIndex: 0,
          explanation: 'Cụm mốc tương lai "By the year 2040" đòi hỏi thì Tương lai hoàn thành: "will have achieved".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'b7_gerund_infinitive',
      slug: 'b7-gerund-infinitive',
      title: '[B7] Gerunds & Infinitives — Danh động từ & Động từ nguyên mẫu',
      titleEn: 'Gerunds & Infinitives',
      titleVi: 'Phân biệt và sử dụng đúng động danh từ (V-ing) và động từ nguyên mẫu trong văn phong học thuật',
      category: 'advanced',
      bandText: 'Band 6.5 - 7.5',
      durationMinutes: 20,
      questionCount: 100,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Quy tắc chọn V-ing hay To V theo động từ đi kèm',
          overview:
              'Sự nhầm lẫn giữa V-ing và To V là một trong những lỗi ngữ pháp phổ biến nhất khiến thí sinh bị giữ chân ở Band 5.5 - 6.0.',
          rows: [
            GrammarTheoryRow(
              title: 'Động từ luôn đi với Gerund (V-ing)',
              usage: 'avoid, admit, consider, deny, enjoy, postpone, recommend, suggest, involve, risk.',
              formula: 'Verb + V-ing',
              example: 'Many experts recommend adopting plant-based diets to curb environmental strain.',
            ),
            GrammarTheoryRow(
              title: 'Động từ luôn đi với Infinitive (To V)',
              usage: 'agree, decide, hope, manage, promise, refuse, tend, aim, attempt, afford.',
              formula: 'Verb + To V',
              example: 'Developing nations strive to achieve economic stability through foreign investment.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'gi_q1',
          questionText:
              'The municipal council considered __________ a congestion tax to discourage private vehicle usage.',
          options: ['introduce', 'introducing', 'to introduce', 'introduction'],
          correctIndex: 1,
          explanation:
              'Động từ "consider" khi đi kèm một hành động bắt buộc theo sau là một Danh động từ (Gerund - V-ing): "consider doing sth" -> "introducing".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'b8_inversion',
      slug: 'b8-inversion',
      title: '[B8] Inversion — Cấu trúc Đảo ngữ',
      titleEn: 'Inversion for Emphasis',
      titleVi: 'Nắm vững cấu trúc đảo ngữ để tạo câu nhấn mạnh, chuyên nghiệp và đặc trưng của IELTS Band 7–8',
      category: 'advanced',
      bandText: 'Band 7.0 - 8.5',
      durationMinutes: 20,
      questionCount: 80,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Các dạng Đảo ngữ học thuật tiêu biểu',
          overview:
              'Đảo ngữ (Inversion) là kỹ thuật đảo trợ động từ lên trước chủ ngữ nhằm nhấn mạnh ý hoặc tăng tính trang trọng, giúp bài viết vượt ngưỡng Band 7.0.',
          rows: [
            GrammarTheoryRow(
              title: 'Cấu trúc "Not only... but also"',
              usage: 'Nhấn mạnh 2 ưu điểm hoặc 2 tác hại liên tiếp.',
              formula: 'Not only + Trợ động từ + S + V, but S also + V',
              example: 'Not only does tourism stimulate local economies, but it also fosters cultural exchange.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'inv_q1',
          questionText:
              'Not only __________ severe health complications, but excessive screen time also diminishes productivity.',
          options: ['it causes', 'does it cause', 'it does cause', 'causes it'],
          correctIndex: 1,
          explanation:
              'Khi cụm phủ định "Not only" đứng ở đầu câu, ta phải đảo trợ động từ lên trước chủ ngữ: "does it cause".',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'b9_quantifiers',
      slug: 'b9-quantifiers',
      title: '[B9] Quantifiers — Từ chỉ số lượng',
      titleEn: 'Academic Quantifiers',
      titleVi: 'Sử dụng chính xác các từ chỉ số lượng trong ngữ cảnh học thuật',
      category: 'advanced',
      bandText: 'Band 6.5 - 7.5',
      durationMinutes: 16,
      questionCount: 70,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Lượng từ học thuật',
          overview: 'A vast majority of, An overwhelming proportion of, A negligible minority of.',
          rows: [
            GrammarTheoryRow(
              title: 'Lượng từ Task 1',
              usage: 'Mô tả tỉ lệ phần trăm và số lượng một cách đa dạng.',
              formula: 'An overwhelming majority of + Noun',
              example: 'An overwhelming majority of surveyed citizens expressed confidence in green energy.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'qt_q1',
          questionText: 'A __________ proportion of respondents preferred flexible working arrangements.',
          options: ['substantial', 'substance', 'substantially', 'substantiate'],
          correctIndex: 0,
          explanation: 'Bổ nghĩa cho danh từ "proportion" ta cần tính từ "substantial" (đáng kể).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'b10_nominalization',
      slug: 'b10-nominalization',
      title: '[B10] Nominalization — Kỹ thuật Danh từ hoá',
      titleEn: 'Academic Nominalization',
      titleVi: 'Chuyển động từ và tính từ thành danh từ để viết văn học thuật chặt chẽ, súc tích theo chuẩn IELTS',
      category: 'advanced',
      bandText: 'Band 7.5 - 8.5+',
      durationMinutes: 18,
      questionCount: 75,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Biến đổi động từ/tính từ thành cụm danh từ cô đọng',
          overview:
              'Danh từ hoá (Nominalization) là đặc trưng lớn nhất của văn phong học thuật Cambridge, tăng mật độ thông tin (Lexical Density).',
          rows: [
            GrammarTheoryRow(
              title: 'Chuyển đổi Động từ -> Danh từ',
              usage: 'Biến hành động thành thực thể trừu tượng làm chủ ngữ.',
              formula: 'S + V + Adv  ===>  The + Noun + of + Noun',
              example: 'The rapid increase in population caused severe infrastructure deficits.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'nom_q1',
          questionText:
              'The sudden __________ of natural resources has placed enormous strain on regional economies.',
          options: ['deplete', 'depleted', 'depletion', 'depleting'],
          correctIndex: 2,
          explanation:
              'Cấu trúc "The + [Tính từ] + [Danh từ] + of" cần danh từ "depletion" (sự suy kiệt tài nguyên).',
        ),
      ],
    ),

    const GrammarLessonModel(
      id: 'b11_prepositions',
      slug: 'b11-prepositions',
      title: '[B11] Prepositions — Giới từ & Cụm giới từ',
      titleEn: 'Academic Prepositions',
      titleVi: 'Làm chủ các giới từ thông dụng và cụm giới từ hay gặp trong IELTS Writing & Reading',
      category: 'advanced',
      bandText: 'Band 6.5 - 7.5',
      durationMinutes: 16,
      questionCount: 80,
      theorySections: [
        GrammarTheorySection(
          sectionTitle: 'Cụm giới từ học thuật',
          overview: 'In terms of, With regard to, In light of, On the verge of.',
          rows: [
            GrammarTheoryRow(
              title: 'Cụm giới từ chuyển ý',
              usage: 'Nêu phạm vi hoặc khía cạnh thảo luận.',
              formula: 'In terms of + Noun/V-ing',
              example: 'In terms of renewable adoption, northern nations have taken a definitive lead.',
            ),
          ],
        ),
      ],
      questions: [
        GrammarQuestion(
          id: 'pr_q1',
          questionText: '__________ technological innovation, the company continues to outpace rivals.',
          options: ['In terms of', 'In view with', 'On terms of', 'With regard of'],
          correctIndex: 0,
          explanation: 'Cụm giới từ chuẩn xác là "In terms of" (xét về mặt...).',
        ),
      ],
    ),
  ];
}
