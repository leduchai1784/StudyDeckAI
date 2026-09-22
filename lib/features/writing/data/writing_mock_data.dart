import '../models/writing_model.dart';

class WritingMockData {
  static const List<WritingPrompt> prompts = [
    // 1. Task 2: Causes and Solutions for Traffic Congestion
    WritingPrompt(
      id: 'task2_115',
      taskType: WritingTaskType.task2,
      category: WritingCategory.problemSolution,
      categoryLabel: 'Problem & Solution',
      title: 'Causes and Solutions for Traffic Congestion',
      promptText:
          'Traffic congestion in cities around the world is increasing. What are the causes of this? What solutions can be suggested?',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.5 - 8.5',
      viewsCount: 3840,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
            'Phân tích nguyên nhân gây tắc nghẽn giao thông rồi đưa ra giải pháp khả thi. Bố cục 4 đoạn chuẩn: Mở bài (Paraphrase + Thesis), Thân bài 1 (2-3 Nguyên nhân chính), Thân bài 2 (2-3 Giải pháp tương ứng), Kết luận tóm tắt.',
        sections: [
          BrainstormSection(
            title: 'NGUYÊN NHÂN (CAUSES)',
            points: [
              'Tăng dân số đô thị và tốc độ đô thị hóa bùng nổ (Rapid urbanization and population influx into metropolitan hubs).',
              'Hạ tầng giao thông không theo kịp nhu cầu (Outdated road network and insufficient road expansion).',
              'Thói quen ưa chuộng phương tiện cá nhân do phương tiện công cộng chưa tiện nghi và linh hoạt (Prevalence of private vehicle ownership over public transit).',
            ],
          ),
          BrainstormSection(
            title: 'GIẢI PHÁP (SOLUTIONS)',
            points: [
              'Đầu tư nâng cấp mạng lưới xe buýt điện, tàu điện ngầm cao tốc (Heavily invest in eco-friendly mass rapid transit systems).',
              'Áp dụng phí chống ùn tắc nội đô và tăng thuế xe cá nhân (Implement congestion charging zones and higher parking tariffs).',
              'Quy hoạch phân bổ các cơ quan, trường học ra vùng ven đô (Decentralize urban facilities to reduce central traffic density).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'Traffic congestion has undeniably emerged as one of the most pressing dilemmas confronting urban centers globally. This alarming trend is primarily driven by exponential urban population growth and an over-reliance on private automobiles, but it can be effectively mitigated through strategic infrastructure investment and fiscal deterrents.\n\nThe principal cause of gridlock in modern metropolises is the mismatch between rapid demographic expansion and municipal infrastructure. Over recent decades, the relentless influx of rural residents migrating to cities in pursuit of employment has caused urban populations to soar. Unfortunately, road networks in many metropolitan areas were never engineered to accommodate such massive vehicular volumes. Furthermore, the convenience, autonomy, and comfort afforded by private vehicles incentivize residents to drive rather than use mass transit. Consequently, during peak commuting hours, major arteries are routinely choked by thousands of single-occupancy cars.\n\nTo counter this escalating predicament, governments must adopt comprehensive countermeasures. First and foremost, municipal authorities ought to heavily subsidize and modernize public transportation networks, including high-speed subways and electric bus rapid transit. If public transit becomes punctual, clean, and seamlessly interconnected, commuters will naturally gravitate away from personal vehicles. Additionally, fiscal measures such as congestion pricing schemes—successfully demonstrated in cities like London and Singapore—can serve as a powerful economic disincentive, penalizing motorists for entering commercial districts during rush hours.\n\nIn conclusion, while urban overpopulation and widespread private car dependence are the chief catalysts of traffic bottlenecks, concerted efforts to enhance public transit systems and impose congestion levies offer pragmatic and durable remedies.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Traffic congestion',
          ipa: '/ˈtræfɪk kənˈdʒestʃən/',
          type: 'Noun phrase',
          meaning: 'Tình trạng ùn tắc giao thông',
          example: 'Traffic congestion causes billions of dollars in lost productivity each year.',
        ),
        WritingVocabItem(
          word: 'Metropolitan areas',
          ipa: '/ˌmetrəˈpɒlɪtən ˈeəriəz/',
          type: 'Noun phrase',
          meaning: 'Khu vực đô thị lớn',
          example: 'Massive infrastructure upgrades are urgently required in metropolitan areas.',
        ),
        WritingVocabItem(
          word: 'Single-occupancy vehicles',
          ipa: '/ˈsɪŋɡl ˈɒkjəpənsi ˈviːəklz/',
          type: 'Noun phrase',
          meaning: 'Phương tiện chỉ chở 1 người',
          example: 'The predominance of single-occupancy vehicles is the main driver of peak-hour gridlock.',
        ),
        WritingVocabItem(
          word: 'Congestion pricing scheme',
          ipa: '/kənˈdʒestʃən ˈpraɪsɪŋ skiːm/',
          type: 'Noun phrase',
          meaning: 'Chính sách thu phí chống ùn tắc',
          example: 'Implementing a congestion pricing scheme encourages residents to opt for public transit.',
        ),
      ],
    ),

    // 2. Task 2: Competitive Sport in Education (Discuss Both Views)
    WritingPrompt(
      id: 'task2_116',
      taskType: WritingTaskType.task2,
      category: WritingCategory.discussBoth,
      categoryLabel: 'Discuss Both Views',
      title: 'Competitive Sport in Education',
      promptText:
          'Some people think that competitive sport has a positive effect on children’s education, while others argue that it is not beneficial. Discuss both views and give your own opinion.',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.0 - 8.0',
      viewsCount: 2950,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
            'Phân tích công bằng cả 2 luồng quan điểm: Thân bài 1 thảo luận lý do nhiều người cho rằng thể thao cạnh tranh có hại (áp lực tâm lý, chấn thương, phân tán học tập). Thân bài 2 làm rõ lợi ích (tinh thần đồng đội, tính kỷ luật, rèn luyện thể chất). Kết luận khẳng định thể thao cạnh tranh mang lại giá trị to lớn nếu được hướng dẫn hợp lý.',
        sections: [
          BrainstormSection(
            title: 'MẶT HẠN CHẾ (ARGUMENT AGAINST)',
            points: [
              'Tạo áp lực thắng thua quá mức khiến trẻ dễ rơi vào tự ti hoặc kiệt sức (Excessive psychological pressure and fear of failure).',
              'Nguy cơ chấn thương thể chất và xao nhãng kết quả học thuật chính khóa (Physical injury risks and distraction from academics).',
            ],
          ),
          BrainstormSection(
            title: 'MẶT TÍCH CỰC (ARGUMENT IN FAVOR)',
            points: [
              'Xây dựng tinh thần đồng đội, tính kỷ luật và sự kiên trì (Fosters team collaboration, resilience, and discipline).',
              'Cải thiện sức khỏe thể chất và giảm stress học tập (Boosts physical fitness and alleviates cognitive fatigue).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'While proponents argue that competitive athletic programs play an indispensable role in youth development, skeptics contend that intense sports rivalries can detract from academic pursuits. This essay examines both perspectives before illustrating why structured competition yields overwhelmingly positive educational outcomes.\n\nOn the one hand, critics raise legitimate concerns regarding excessive competitiveness among students. When schools emphasize winning above participation, children may endure significant emotional strain and heightened anxiety. In extreme cases, fear of failure can erode self-esteem and foster unhealthy rivalries between classmates. Moreover, vigorous sports entail risks of physical injuries and consume substantial time that could otherwise be allocated to core curricular subjects.\n\nOn the other hand, competitive sports serve as an exceptional vehicle for character building and social maturation. Engaging in regulated contests instills indispensable life competencies, notably perseverance, disciplined goal-setting, and emotional resilience in the face of defeat. Furthermore, participating in team sports such as football or basketball teaches students how to subordinate individual egos in pursuit of collective objectives—a skill paramount in the modern workforce.\n\nIn conclusion, while unbalanced emphasis on winning can trigger stress, I am firmly convinced that when organized under constructive mentorship, competitive sports provide indispensable educational benefits that complement scholastic excellence.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Indispensable role',
          ipa: '/ˌɪndɪˈspensəbl rəʊl/',
          type: 'Collocation',
          meaning: 'Vai trò không thể thiếu',
          example: 'Physical training plays an indispensable role in comprehensive education.',
        ),
        WritingVocabItem(
          word: 'Emotional resilience',
          ipa: '/ɪˈməʊʃənl rɪˈzɪliəns/',
          type: 'Noun phrase',
          meaning: 'Sự kiên cường và khả năng phục hồi cảm xúc',
          example: 'Competition teaches students emotional resilience when handling failure.',
        ),
      ],
    ),

    // 3. Task 2: Remote Working (Opinion Essay)
    WritingPrompt(
      id: 'task2_117',
      taskType: WritingTaskType.task2,
      category: WritingCategory.opinion,
      categoryLabel: 'Opinion Essay',
      title: 'Remote Working and Work-Life Balance',
      promptText:
          'In many countries, an increasing number of employees now work from home rather than in traditional offices. Do the advantages of this trend outweigh the disadvantages?',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.5+',
      viewsCount: 2210,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
            'Đưa ra quan điểm rõ ràng ngay từ mở bài (Lợi ích vượt trội hơn bất lợi). Đoạn 1 thừa nhận hạn chế của làm việc từ xa (cô lập xã hội, mờ ranh giới công việc - nghỉ ngơi). Đoạn 2 phân tích sâu 2 lợi ích lớn (tiết kiệm thời gian di chuyển, tự chủ lịch trình, tăng năng suất).',
        sections: [
          BrainstormSection(
            title: 'BẤT LỢI (DISADVANTAGES)',
            points: [
              'Cảm giác cô lập xã hội và thiếu tương tác trực tiếp (Social isolation and diminished workplace camaraderie).',
              'Khó tách bạch công việc và đời sống cá nhân (Blurring boundaries between professional duties and domestic life).',
            ],
          ),
          BrainstormSection(
            title: 'LỢI ÍCH VƯỢT TRỘI (OUTWEIGHING ADVANTAGES)',
            points: [
              'Loại bỏ thời gian kẹt xe hằng ngày, giảm phát thải khí nhà kính (Eliminates exhaustive commutes and cuts carbon footprint).',
              'Tự chủ thời gian giúp cân bằng việc nhà và nâng cao hiệu suất (Flexible scheduling empowers better work-life integration).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'The transition toward telecommuting has dramatically redefined contemporary employment patterns across the globe. Although telework presents certain challenges related to professional isolation, I firmly believe that its benefits in terms of temporal autonomy and environmental sustainability decisively outweigh any drawbacks.\n\nAdmittedly, working remotely is not without pitfalls. The most pronounced drawback is the potential erosion of interpersonal connections among colleagues. Without informal water-cooler chats and collaborative office dynamics, remote employees may experience feelings of professional alienation and detachment from corporate culture. Additionally, when the home becomes the workplace, maintaining a distinct boundary between professional duties and private life becomes elusive, frequently culminating in extended working hours and occupational burnout.\n\nNonetheless, the advantages of telecommuting are considerably more substantial. Foremost among these is the eradication of stressful daily commutes. In bustling metropolises, workers commonly squander multiple hours navigating congested highways, which induces physical exhaustion and cognitive fatigue. Reclaiming this wasted time allows individuals to spend meaningful moments with family, pursue physical exercise, or engage in continuous self-improvement. Furthermore, remote work grants employees autonomy over their schedules, empowering them to work during their peak cognitive hours and dramatically enhancing overall productivity.\n\nTo conclude, despite legitimate concerns regarding social isolation, the freedom from commuting and enhanced lifestyle flexibility demonstrate that remote work is an overwhelmingly advantageous development.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Telecommuting',
          ipa: '/ˈtelikəmjuːtɪŋ/',
          type: 'Noun',
          meaning: 'Làm việc từ xa qua mạng',
          example: 'Telecommuting has become the new norm in the technology sector.',
        ),
        WritingVocabItem(
          word: 'Temporal autonomy',
          ipa: '/ˈtempərəl ɔːˈtɒnəmi/',
          type: 'Noun phrase',
          meaning: 'Sự tự chủ về mặt thời gian',
          example: 'Remote employment grants workers temporal autonomy to balance personal duties.',
        ),
      ],
    ),

    // 4. Task 1: Pie Chart - Percentage of volunteers by organisation type
    WritingPrompt(
      id: 'task1_001',
      taskType: WritingTaskType.task1,
      category: WritingCategory.pieChart,
      categoryLabel: 'Pie Chart',
      title: 'Volunteers by Organisation Type (2008 and 2014)',
      promptText:
          'The charts below show the percentage of volunteers by organizations in 2008 and 2014. Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
      minWords: 150,
      timeMinutes: 20,
      targetBand: 'Band 7.5+',
      viewsCount: 3100,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
            'Cấu trúc bài viết 4 đoạn: 1. Introduction (Paraphrase đề bài); 2. Overview (Nêu 2 xu hướng nổi bật: Giáo dục và Môi trường chiếm tỷ trọng lớn nhất, Y tế sụt giảm mạnh nhất); 3. Detail Paragraph 1 (So sánh Environmental và Educational); 4. Detail Paragraph 2 (So sánh Health care, Sport, và Others).',
        sections: [
          BrainstormSection(
            title: 'TỔNG QUAN (OVERVIEW)',
            points: [
              'Environmental và Educational organisations luôn chiếm ưu thế áp đảo trong cả 2 năm.',
              'Tỷ lệ tình nguyện viên cho mảng Y tế (Health care) sụt giảm rõ rệt nhất, trong khi Thể thao (Sport) tăng trưởng.',
            ],
          ),
          BrainstormSection(
            title: 'SỐ LIỆU NỔI BẬT (KEY FIGURES)',
            points: [
              'Environmental: Tăng từ 21% (2008) lên 29% (2014), trở thành lĩnh vực thu hút nhất.',
              'Educational: Giảm nhẹ từ 24% xuống 17%.',
              'Health care: Giảm sâu một nửa từ 18% xuống còn 9%.',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'The two pie charts illustrate the proportion of volunteers participating in five distinct categories of organizations in 2008 and 2014.\n\nOverall, environmental and educational groups attracted the vast majority of volunteer labor in both years. Furthermore, while environmental initiatives and sports clubs registered notable expansions, healthcare and educational charities experienced significant contractions in their volunteer shares.\n\nIn 2008, educational organizations constituted the largest category, accounting for nearly a quarter (24%) of total volunteers, followed closely by environmental bodies at 21%. However, by 2014, environmental organizations surged by 8% to reach 29%, cementing their position as the leading sector, whereas education witnessed a pronounced decline to 17%.\n\nRegarding the remaining sectors, healthcare organizations experienced the most dramatic downturn, plummeting from 18% in 2008 to precisely half that figure (9%) in 2014. Conversely, volunteer engagement in sports expanded moderately from 15% to 25%. Lastly, the proportion of individuals volunteering in miscellaneous other organizations remained relatively stable, fluctuating minimally around 20% over the six-year duration.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Constituted the largest category',
          ipa: '/ˈkɒnstɪtjuːtɪd ðə lɑːdʒɪst ˈkætəɡəri/',
          type: 'Collocation',
          meaning: 'Chiếm tỷ trọng lớn nhất',
          example: 'Educational groups constituted the largest category in the initial year.',
        ),
        WritingVocabItem(
          word: 'Plummeted',
          ipa: '/ˈplʌmɪtɪd/',
          type: 'Verb',
          meaning: 'Lao dốc, sụt giảm thẳng đứng',
          example: 'The share of healthcare volunteers plummeted from 18% to 9%.',
        ),
      ],
    ),

    // 5. Task 1: Map - Development of Porth Harbour
    WritingPrompt(
      id: 'task1_002',
      taskType: WritingTaskType.task1,
      category: WritingCategory.map,
      categoryLabel: 'Map',
      title: 'Development of Porth Harbour (2000 vs Today)',
      promptText:
          'The maps below show the changes that have taken place at Porth Harbour between 2000 and the present day. Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
      minWords: 150,
      timeMinutes: 20,
      targetBand: 'Band 7.5+',
      viewsCount: 1890,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
            'Overview: Bến cảng đã chuyển đổi công năng từ một bến tàu đánh cá thương mại nhỏ thành một khu vực dịch vụ du lịch, thể thao biển và khách sạn hiện đại. Body 1: Các thay đổi ở phía Tây và bờ biển. Body 2: Các thay đổi ở phía Đông và trung tâm bến tàu.',
        sections: [
          BrainstormSection(
            title: 'TỔNG QUAN (OVERVIEW)',
            points: [
              'Khu vực cảng thương mại truyền thống đã được hiện đại hóa toàn diện phục vụ du lịch.',
              'Các nhà kho cũ bị phá dỡ để nhường chỗ cho khách sạn, nhà hàng và bến đỗ du thuyền.',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'The two maps depict the structural transformation that has occurred in Porth Harbour from the year 2000 to the present day.\n\nOverall, the harbour has undergone extensive redevelopment, shifting from an industrial fishing port into a contemporary tourist and leisure destination with upgraded recreational amenities.\n\nIn the western sector of the harbour, the original fishing docks and maintenance warehouses have been entirely dismantled. In their place, developers have erected a multi-story boutique hotel accompanied by an array of waterfront cafes and dining establishments. Furthermore, the private car park previously located on the northwest periphery has been substantially enlarged to accommodate heightened vehicular traffic from visitors.\n\nTurning to the eastern and maritime zones, the public beach has been preserved, although a new marina catering exclusively to private yachts has been constructed adjacent to the main breakwater. The old commercial pier has been repurposed for passenger ferries and leisure boat cruises, completing the area’s complete metamorphosis into an attractive seaside resort.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Undergone extensive redevelopment',
          ipa: '/ˌʌndəˈɡɒn ɪkˈstensɪv ˌriːdɪˈveləpmənt/',
          type: 'Collocation',
          meaning: 'Trải qua quá trình tái phát triển toàn diện',
          example: 'The port has undergone extensive redevelopment over the past two decades.',
        ),
      ],
    ),
  ];

  // Mock Translation Items (Tập Dịch IELTS)
  static const List<WritingTranslationItem> translationItems = [
    // Step 1: Cấu trúc câu cơ bản
    WritingTranslationItem(
      id: 'trans_s1_01',
      step: 1,
      category: 'Cấu trúc S-V-O & Mệnh đề chỉ nguyên nhân',
      vietnameseSentence:
          'Ùn tắc giao thông ngày càng trở nên nghiêm trọng bởi vì số lượng phương tiện cá nhân đang tăng nhanh chóng.',
      englishSample:
          'Traffic congestion is becoming increasingly severe because the number of private vehicles is surging rapidly.',
      keyCollocations: ['Traffic congestion', 'increasingly severe', 'surging rapidly'],
      explanation:
          'Sử dụng trạng từ "increasingly" bổ nghĩa cho tính từ "severe". Mệnh đề chỉ nguyên nhân "because" nối hai vế độc lập có thì hiện tại tiếp diễn.',
    ),
    WritingTranslationItem(
      id: 'trans_s1_02',
      step: 1,
      category: 'Mệnh đề quan hệ & Dạng bị động',
      vietnameseSentence:
          'Chính phủ cần đầu tư vào hệ thống giao thông công cộng, cái mà đã bị lãng quên trong nhiều năm qua.',
      englishSample:
          'The government ought to invest in public transit systems, which have been neglected for many years.',
      keyCollocations: ['invest in', 'public transit systems', 'neglected for many years'],
      explanation:
          'Dùng mệnh đề quan hệ không xác định ", which" kết hợp thể bị động hoàn thành "have been neglected" để tạo câu phức nâng cao Band ngữ pháp.',
    ),
    WritingTranslationItem(
      id: 'trans_s1_03',
      step: 1,
      category: 'Cấu trúc nhượng bộ (Although / While)',
      vietnameseSentence:
          'Mặc dù làm việc từ xa mang lại sự linh hoạt, nó cũng có thể dẫn đến cảm giác cô lập xã hội.',
      englishSample:
          'Although telecommuting offers significant flexibility, it can also lead to feelings of social isolation.',
      keyCollocations: ['telecommuting', 'significant flexibility', 'social isolation'],
      explanation:
          'Sử dụng liên từ nhượng bộ "Although" ở đầu câu, lưu ý không dùng "but" ở mệnh đề chính trong tiếng Anh học thuật.',
    ),

    // Step 2: Collocations & Vocab học thuật
    WritingTranslationItem(
      id: 'trans_s2_01',
      step: 2,
      category: 'Chủ đề Môi trường & Đô thị',
      vietnameseSentence:
          'Việc áp dụng các chính sách thu phí tắc đường đóng vai trò như một biện pháp ngăn chặn tài chính hiệu quả.',
      englishSample:
          'The implementation of congestion pricing policies acts as an effective financial deterrent.',
      keyCollocations: ['congestion pricing policies', 'financial deterrent', 'implementation of'],
      explanation:
          'Cụm từ học thuật Band 8+: "financial deterrent" (biện pháp răn đe tài chính) và danh từ hóa "The implementation of...".',
    ),
    WritingTranslationItem(
      id: 'trans_s2_02',
      step: 2,
      category: 'Chủ đề Giáo dục & Thể thao',
      vietnameseSentence:
          'Thể thao cạnh tranh đóng vai trò không thể thiếu trong việc rèn luyện sự kiên cường và tinh thần đồng đội cho thanh thiếu niên.',
      englishSample:
          'Competitive sports play an indispensable role in fostering resilience and teamwork among youngsters.',
      keyCollocations: ['play an indispensable role', 'fostering resilience', 'competitive sports'],
      explanation:
          'Collocation đắt giá: "play an indispensable role in V-ing" (đóng vai trò không thể thiếu) và "foster resilience" (nuôi dưỡng sự kiên cường).',
    ),
  ];
}
