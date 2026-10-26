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

    // 4. Task 2: Cooking as a Popular Hobby (Positive / Negative Development)
    WritingPrompt(
      id: 'task2_118',
      taskType: WritingTaskType.task2,
      category: WritingCategory.opinion,
      categoryLabel: 'Opinion Essay',
      title: 'Cooking as a Popular Hobby',
      promptText:
          'In recent years, many people have become interested in cooking as a hobby. Is this a positive or negative development?',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.5 - 8.5',
      viewsCount: 3120,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
          'Khẳng định rõ đây là một xu hướng tích cực (positive development) mang lại nhiều lợi ích vượt trội về sức khỏe thể chất (kiểm soát dinh dưỡng, tránh đồ ăn nhanh), giá trị tinh thần (giảm stress, gắn kết gia đình) và hiệu quả tài chính cá nhân.',
        sections: [
          BrainstormSection(
            title: 'LỢI ÍCH SỨC KHỎE & KINH TẾ (HEALTH & ECONOMIC)',
            points: [
              'Chủ động kiểm soát nguyên liệu, hạn chế dầu mỡ, đường tinh luyện và chất bảo quản (Enables strict control over ingredients, drastically curtailing saturated fats and synthetic preservatives).',
              'Tiết kiệm chi phí đáng kể so với việc thường xuyên ăn nhà hàng hoặc gọi đồ ăn nhanh (Substantially less costly than dining out frequently or ordering commercial takeout).',
            ],
          ),
          BrainstormSection(
            title: 'GIÁ TRỊ TÂM LÝ & GẮN KẾT (PSYCHOLOGICAL & SOCIAL)',
            points: [
              'Liệu pháp tinh thần giúp giải tỏa căng thẳng công việc qua việc sáng tạo ẩm thực (Culinary preparation serves as a therapeutic outlet to decompress from workplace stress).',
              'Bữa cơm tự nấu tạo cơ hội gắn kết các thành viên gia đình và bạn bè (Home-cooked meals facilitate meaningful interpersonal bonding and strengthen familial ties).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'In contemporary society, an increasing proportion of individuals have embraced culinary preparation not merely as a domestic chore, but as an engaging recreational pastime. From my perspective, this burgeoning phenomenon represents an overwhelmingly positive development, as it promotes holistic physical wellbeing, fosters financial mindfulness, and serves as an effective therapeutic outlet.\n\nFirst and foremost, the resurgence of cooking at home delivers profound physical health advantages. Unlike restaurant fare and ultra-processed convenience meals—which are notoriously saturated with sodium, refined sugars, and hydrogenated fats to enhance shelf-life and palatability—home cooking affords complete sovereignty over dietary ingredients. Culinary hobbyists are empowered to select wholesome, nutrient-dense produce and regulate portion sizes, thereby mitigating the risk of diet-induced ailments such as hypertension, obesity, and cardiovascular diseases. Moreover, preparing meals from scratch represents an economical alternative to frequent dining out, enabling households to allocate fiscal resources toward other constructive long-term endeavors.\n\nBeyond physiological and economic dividends, cooking confers significant psychological and interpersonal benefits. In an era dominated by relentless digital screens and cognitive exhaustion, engaging the senses through chopping, seasoning, and tasting acts as a grounding form of mindful therapy. Many find the creative experimentation inherent in culinary arts to be an invigorating antidote to occupational stress. Furthermore, food has historically served as a universal social glue; gathering loved ones to savor home-cooked dishes nurtures deeper familial bonds and reinforces authentic human connections in an increasingly fragmented world.\n\nIn conclusion, the contemporary transition toward adopting cooking as an enjoyable hobby is unequivocally beneficial. It not only fortifies personal health and economic resilience, but also enhances mental equilibrium and social cohesion.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Culinary preparation',
          ipa: '/ˈkʌlɪnəri ˌprepəˈreɪʃn/',
          type: 'Noun phrase',
          meaning: 'Hoạt động nấu nướng ẩm thực',
          example: 'Culinary preparation has transformed from a mundane task into a mindful hobby.',
        ),
        WritingVocabItem(
          word: 'Ultra-processed convenience meals',
          ipa: '/ˌʌltrə ˈprəʊsest kənˈviːniəns miːlz/',
          type: 'Noun phrase',
          meaning: 'Bữa ăn tiện lợi siêu chế biến',
          example: 'Frequent reliance on ultra-processed convenience meals fuels metabolic diseases.',
        ),
        WritingVocabItem(
          word: 'Diet-induced ailments',
          ipa: '/ˈdaɪət ɪnˈdjuːst ˈeɪlmənts/',
          type: 'Noun phrase',
          meaning: 'Các chứng bệnh do chế độ ăn uống gây ra',
          example: 'Home-cooked nutrition sharply lowers the prevalence of diet-induced ailments.',
        ),
        WritingVocabItem(
          word: 'Mindful therapy',
          ipa: '/ˈmaɪndfl ˈθerəpi/',
          type: 'Noun phrase',
          meaning: 'Liệu pháp chánh niệm giải tỏa tâm lý',
          example: 'Preparing fresh recipes after office hours acts as a restorative mindful therapy.',
        ),
      ],
    ),

    // 5. Task 2: Popularity of Extreme Sports (Two-part Question)
    WritingPrompt(
      id: 'task2_119',
      taskType: WritingTaskType.task2,
      category: WritingCategory.twoPart,
      categoryLabel: 'Two-part Question',
      title: 'Popularity of Extreme Sports',
      promptText:
          'Extreme sports such as skydiving and car racing have become increasingly popular. What are the reasons for this? What can be done to make these sports safer?',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.5 - 8.5',
      viewsCount: 2780,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
          'Bài viết cấu trúc 4 đoạn: Đoạn 1 nêu lý do thể thao mạo hiểm thu hút (tìm kiếm cảm giác mạnh adrenaline giải thoát lối sống đơn điệu, ảnh hưởng của mạng xã hội). Đoạn 2 nêu giải pháp an toàn (quy định chứng nhận thiết bị nghiêm ngặt, huấn luyện bắt buộc và kiểm tra sức khỏe).',
        sections: [
          BrainstormSection(
            title: 'NGUYÊN NHÂN ƯA CHUỘNG (REASONS)',
            points: [
              'Nhu cầu kích thích cảm giác mạnh để thoát khỏi lối sống văn phòng ít vận động (The pursuit of intense adrenaline rushes to counteract sedentary monotony).',
              'Sự lan tỏa của các video thể thao hành động góc nhìn thứ nhất trên mạng xã hội (Widespread dissemination of high-definition POV footage on viral digital platforms).',
            ],
          ),
          BrainstormSection(
            title: 'GIẢI PHÁP AN TOÀN (SAFETY MEASURES)',
            points: [
              'Ban hành tiêu chuẩn chứng nhận bắt buộc đối với trang thiết bị kỹ thuật (Enforce stringent certification standards for safety equipment and gear).',
              'Yêu cầu kiểm tra sức khỏe và hoàn thành khóa huấn luyện chuyên nghiệp trước khi tham gia (Mandate rigorous physical assessments and accredited training before granting permits).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'In recent years, adrenaline-fueled pursuits such as skydiving, white-water rafting, and motorsport racing have captured the fascination of millions worldwide. This growing allure stems fundamentally from a psychological yearning for escapism and the amplifying power of digital media, though concerted institutional safeguards must be instituted to curtail catastrophic risks.\n\nThe primary driver behind the popularity of extreme sports is the modern urbanite’s craving for sensory stimulation. In contemporary society, countless individuals lead highly predictable, sedentary lifestyles confined to cubicles and computer monitors. Participating in perilous activities triggers an instantaneous surge of adrenaline and endorphins, providing an intense sensation of euphoria and vitality that mundane routines fail to offer. Additionally, the proliferation of social media platforms has propelled this trend into the cultural mainstream. Content creators frequently broadcast exhilarating high-definition first-person footage of daring exploits, inspiring impressionable audiences to test their own thresholds of courage.\n\nTo safeguard enthusiasts without dampening their passion, comprehensive regulatory measures are indispensable. Foremost, governing bodies must establish non-negotiable safety protocols and enforce rigorous quality checks on all mechanical equipment, such as reserve parachutes, braking systems, and protective armor. Unlicensed operators utilizing substandard gear must face severe punitive fines or criminal prosecution. Furthermore, participants ought to undergo mandatory medical screenings and accredited competency training prior to engaging in high-risk ventures, ensuring they possess the physiological stamina and emergency protocols necessary to handle perilous contingencies.\n\nTo conclude, while the allure of extreme sports is driven by the desire to transcend monotonous routines and the influence of viral media, their lethal hazards can be effectively contained through uncompromising equipment standards and compulsory professional training.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Adrenaline-fueled pursuits',
          ipa: '/əˈdrenəlɪn fjuːəld pəˈsjuːts/',
          type: 'Noun phrase',
          meaning: 'Các hoạt động kích thích cảm giác mạnh',
          example: 'Young adults increasingly spend weekends engaging in adrenaline-fueled pursuits.',
        ),
        WritingVocabItem(
          word: 'Sedentary monotony',
          ipa: '/ˈsedntri məˈnɒtəni/',
          type: 'Noun phrase',
          meaning: 'Sự đơn điệu của lối sống ít vận động',
          example: 'Extreme adventures offer a psychological escape from corporate sedentary monotony.',
        ),
        WritingVocabItem(
          word: 'Non-negotiable safety protocols',
          ipa: '/nɒn nɪˈɡəʊʃiəbl ˈseɪfti ˈprəʊtəkɒlz/',
          type: 'Noun phrase',
          meaning: 'Các quy chuẩn an toàn không thể thương lượng',
          example: 'Commercial operators must adhere strictly to non-negotiable safety protocols.',
        ),
        WritingVocabItem(
          word: 'Perilous contingencies',
          ipa: '/ˈperələs kənˈtɪndʒənsiz/',
          type: 'Noun phrase',
          meaning: 'Các sự cố bất ngờ đầy nguy hiểm',
          example: 'Skydivers undergo extensive drills to navigate perilous contingencies at high altitudes.',
        ),
      ],
    ),

    // 6. Task 2: Dangers of Scientific Discoveries (Opinion Essay)
    WritingPrompt(
      id: 'task2_120',
      taskType: WritingTaskType.task2,
      category: WritingCategory.opinion,
      categoryLabel: 'Opinion Essay',
      title: 'Dangers of Scientific Discoveries',
      promptText:
          'Some people think that scientific discoveries have made our world more dangerous. To what extent do you agree or disagree?',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.5 - 8.5',
      viewsCount: 2450,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
          'Bày tỏ quan điểm không đồng tình (disagree). Thừa nhận những rủi ro quân sự hóa và ô nhiễm công nghiệp. Tuy nhiên khẳng định mạnh mẽ khoa học giúp nhân loại an toàn hơn nhờ xóa bỏ dịch bệnh hiểm nghèo, cảnh báo sớm thiên tai và nâng cao tuổi thọ trung bình.',
        sections: [
          BrainstormSection(
            title: 'RỦI RO ĐANG TỒN TẠI (EXISTING PERILS)',
            points: [
              'Vũ khí hủy diệt hàng loạt và chiến tranh mạng (Militarization of breakthroughs, including thermonuclear warheads and autonomous cyber weaponry).',
              'Ô nhiễm môi trường và biến đổi khí hậu từ công nghiệp hóa (Anthropogenic environmental degradation and global warming).',
            ],
          ),
          BrainstormSection(
            title: 'LỢI ÍCH BẢO VỆ VƯỢT TRỘI (LIFE-SAVING POWER)',
            points: [
              'Y học và kháng sinh đẩy lùi dịch bệnh, nhân đôi tuổi thọ con người (Pharmacology, sanitation, and vaccines doubling human life expectancy).',
              'Vệ tinh và AI dự báo sớm thiên tai, bảo vệ hàng triệu người (Meteorology and seismic sensors enabling timely evacuations).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'A faction of critics asserts that the relentless progression of scientific inquiry has rendered our planet a substantially more precarious habitat. While catastrophic technologies like weapons of mass destruction certainly validate these anxieties, I largely dispute this premise, as scientific innovation has universally elevated human longevity, eradicated existential diseases, and enhanced global security against natural perils.\n\nAdmittedly, scientific discovery has occasionally amplified the scale of existential threats. The most palpable manifestation is the proliferation of military technologies, notably thermonuclear warheads, chemical agents, and autonomous cyber weaponry, which possess the harrowing capacity to obliterate civilizations in minutes. Furthermore, unregulated scientific exploitation of fossil fuels and chemical engineering has precipitated planetary crises, including global warming, microplastic contamination, and biodiversity collapse. These disastrous ramifications demonstrate that when detached from ethical oversight, scientific prowess can indeed engender unprecedented vulnerabilities.\n\nNevertheless, the overwhelmingly dominant trajectory of science has been life-preserving rather than destructive. Before the advent of modern biomedical science, everyday bacterial infections, smallpox, and tuberculosis routinely decimated populations, resulting in an average global life expectancy below forty years. The development of sanitation systems, broad-spectrum antibiotics, and revolutionary mRNA vaccines has effectively subdued infectious scourges, saving billions of lives. Moreover, modern meteorology and seismology, powered by satellite observation networks and artificial intelligence, provide accurate early warnings for typhoons and tsunamis, enabling timely evacuations that prevent catastrophic death tolls. Without these scientific tools, human existence would remain profoundly fragile and exposed to the brutal caprices of nature.\n\nIn conclusion, although the misapplication of scientific breakthroughs has produced menacing hazards, science on the whole has served as humanity\'s most formidable shield, delivering unprecedented safety, longevity, and stability to modern civilization.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Existential threats',
          ipa: '/ˌeɡzɪˈstenʃl θrets/',
          type: 'Noun phrase',
          meaning: 'Hiểm họa mang tính sống còn đối với nhân loại',
          example: 'Thermonuclear proliferation remains one of the gravest existential threats.',
        ),
        WritingVocabItem(
          word: 'Subdued infectious scourges',
          ipa: '/səbˈdjuːd ɪnˈfekʃəs ˈskɜːdʒɪz/',
          type: 'Verb phrase',
          meaning: 'Đẩy lùi và dập tắt các đại dịch truyền nhiễm',
          example: 'Mass vaccination campaigns have largely subdued infectious scourges worldwide.',
        ),
        WritingVocabItem(
          word: 'Precipitated planetary crises',
          ipa: '/prɪˈsɪpɪteɪtɪd ˈplænətri ˈkraɪsiːz/',
          type: 'Verb phrase',
          meaning: 'Châm ngòi cho các cuộc khủng hoảng quy mô hành tinh',
          example: 'Unrestrained carbon emissions have precipitated planetary crises in climate systems.',
        ),
      ],
    ),

    // 7. Task 2: Celebrity Support for Charities (Discuss Both Views)
    WritingPrompt(
      id: 'task2_121',
      taskType: WritingTaskType.task2,
      category: WritingCategory.discussBoth,
      categoryLabel: 'Discuss Both Views',
      title: 'Celebrity Support for Charities',
      promptText:
          'Some people think famous people\'s support can help raise money for charities. Others think celebrities should not be involved in charities. Discuss both views and give your opinion.',
      minWords: 250,
      timeMinutes: 40,
      targetBand: 'Band 7.5 - 8.5',
      viewsCount: 2630,
      aiBrainstorm: WritingAiBrainstorm(
        strategy:
          'Thảo luận 2 mặt: Đoạn 1 phân tích rủi ro khi người nổi tiếng làm từ thiện (nghi ngờ chiêu trò PR, làm lu mờ thông điệp tổ chức, bê bối cá nhân gây tổn hại uy tín quỹ). Đoạn 2 làm rõ sức mạnh huy động tài chính (độ phủ sóng truyền thông, thu hút người trẻ quyên góp). Kết luận khẳng định giá trị to lớn của nghệ sĩ khi có sự giám sát tài chính minh bạch.',
        sections: [
          BrainstormSection(
            title: 'MẶT TRÁI & QUAN ĐIỂM HOÀI NGHI (SKEPTICAL VIEW)',
            points: [
              'Từ thiện bị biến tướng thành công cụ PR đánh bóng tên tuổi (Charitable advocacy being co-opted as a superficial public relations stunt).',
              'Bê bối cá nhân của nghệ sĩ làm sụp đổ uy tín của quỹ từ thiện liên đới (Celebrity scandals can irreparably tarnish donor trust in nonprofit organizations).',
            ],
          ),
          BrainstormSection(
            title: 'SỨC MẠNH HUY ĐỘNG TÀI CHÍNH (PHILANTHROPIC REACH)',
            points: [
              'Tận dụng lượng người theo dõi khổng lồ để kích hoạt làn sóng quyên góp (Vast social media followings mobilize substantial micro-donations from youth demographics).',
              'Đưa các cuộc khủng hoảng bị lãng quên lên tâm điểm báo chí chính thống (Catapults neglected humanitarian crises onto mainstream news agendas).',
            ],
          ),
        ],
      ),
      sampleEssayBand8:
          'The involvement of high-profile personalities in philanthropic endeavors has sparked continuous debate. While skeptics assert that celebrity patronage often degenerates into self-serving publicity maneuvers, advocates maintain that their star power is vital for mobilizing resources. This essay analyzes both perspectives before arguing that famous individuals offer invaluable contributions to charitable initiatives provided rigorous financial accountability is upheld.\n\nOn the one hand, reservations regarding celebrity philanthropy are not without merit. Foremost among these is the perception of insincerity; critics frequently suspect that public figures exploit altruistic causes as calculated marketing gimmicks to rehabilitate tarnished reputations or burnish their public profiles. Furthermore, the celebrity often overshadows the cause itself, drawing media scrutiny toward their attire or lifestyle rather than the systemic struggles of the disadvantaged. Worse still, if a celebrity ambassador becomes entangled in a high-profile personal scandal, the associated charity risks severe reputational collateral damage, precipitating a collapse in donor trust.\n\nConversely, the tangible benefits of celebrity endorsement are undeniable and frequently irreplaceable. In an era saturated with information, charitable organizations face fierce competition for public attention. Celebrities possess vast followings across social media platforms, allowing them to instantaneously catapult neglected humanitarian crises onto mainstream news agendas. By leveraging their emotional resonance, they can motivate hundreds of thousands of ordinary fans—particularly younger demographics who might otherwise remain disengaged—to contribute micro-donations that cumulatively total millions of dollars. For instance, global relief campaigns championed by international stars during humanitarian disasters have repeatedly secured life-saving supplies far quicker than conventional bureaucratic fundraising.\n\nTo conclude, although concerns over superficiality and reputational risks are justifiable, I firmly believe that the immense advocacy reach and fundraising capacity of celebrities are overwhelmingly beneficial, so long as charity operations remain transparent and professionally audited.',
      usefulVocab: [
        WritingVocabItem(
          word: 'Philanthropic endeavors',
          ipa: '/ˌfɪlənˈθrɒpɪk ɪnˈdevəz/',
          type: 'Noun phrase',
          meaning: 'Các nỗ lực từ thiện, nhân đạo',
          example: 'Major celebrities often donate millions to global philanthropic endeavors.',
        ),
        WritingVocabItem(
          word: 'Public relations stunt',
          ipa: '/ˌpʌblɪk rɪˈleɪʃnz stʌnt/',
          type: 'Noun phrase',
          meaning: 'Chiêu trò PR đánh bóng tên tuổi',
          example: 'Cynics dismiss celebrity fundraisers as a calculated public relations stunt.',
        ),
        WritingVocabItem(
          word: 'Catapult onto mainstream news',
          ipa: '/ˈkætəpʌlt ˈɒntuː ˈmeɪnstriːm njuːz/',
          type: 'Verb phrase',
          meaning: 'Đưa sự việc lập tức lên tâm điểm báo chí',
          example: 'Star endorsements can catapult obscure causes onto mainstream news agendas.',
        ),
        WritingVocabItem(
          word: 'Reputational collateral damage',
          ipa: '/ˌrepjuˈteɪʃənl kəˈlætərəl ˈdæmɪdʒ/',
          type: 'Noun phrase',
          meaning: 'Thiệt hại uy tín liên đới',
          example: 'Ambassador controversies often inflict reputational collateral damage on charities.',
        ),
      ],
    ),

    // 8. Task 1: Pie Chart - Percentage of volunteers by organisation type
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
