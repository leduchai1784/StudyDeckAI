import '../models/speaking_model.dart';

class SpeakingMockData {
  /// Danh sách các chủ đề Dự đoán đề thi Speaking (Forecast Quý 3 & Quý 2)
  static const List<SpeakingTopic> forecastTopics = [
    // 1. Robots & AI (Part 1 Chủ đề - Quý 3)
    SpeakingTopic(
      id: 'spk_q3_01',
      quarter: 'Q3-2026',
      title: 'Robots & Artificial Intelligence',
      titleVi: 'Robot và Trí tuệ nhân tạo',
      categoryTag: 'part1_topic',
      bandTarget: 'Band 6.5 - 8.0',
      tagLabel: 'HOT TREND · QUÝ 3',
      viewsCount: 24800,
      questions: [
        SpeakingQuestion(
          id: 'spk_q3_01_q1',
          part: SpeakingPart.part1,
          questionText: 'Are you interested in robots and modern artificial intelligence?',
          ideaHints: [
            'Direct Answer: Yes, absolutely fascinated by how fast AI has evolved.',
            'Reason: Tools like generative AI and automated robots assist in mundane repetitive tasks.',
            'Example: Using smart assistants to schedule daily tasks and research information.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'fascinated by',
              ipa: '/ˈfæs.ɪ.neɪ.tɪd baɪ/',
              type: 'adj',
              meaning: 'Vô cùng hứng thú, say mê',
              example: 'I am completely fascinated by humanoid robotics.',
            ),
            SpeakingVocabItem(
              word: 'mundane tasks',
              ipa: '/mʌnˈdeɪn tɑːsks/',
              type: 'collocation',
              meaning: 'Những công việc thường nhật, đơn điệu',
              example: 'AI helps automate mundane tasks like sorting emails.',
            ),
            SpeakingVocabItem(
              word: 'cutting-edge',
              ipa: '/ˌkʌt.ɪŋ ˈedʒ/',
              type: 'adj',
              meaning: 'Tiên tiến, dẫn đầu công nghệ',
              example: 'Tech firms are deploying cutting-edge neural algorithms.',
            ),
          ],
          sampleAnswerBand8:
              'Without a doubt, I am completely fascinated by how rapidly artificial intelligence has progressed. Living in a digital era, I frequently rely on cutting-edge algorithms to organize my schedule and streamline mundane tasks, which saves me a tremendous amount of cognitive energy.',
          audioDurationSeconds: 22,
        ),
        SpeakingQuestion(
          id: 'spk_q3_01_q2',
          part: SpeakingPart.part1,
          questionText: 'Would you feel comfortable letting a domestic robot clean your home?',
          ideaHints: [
            'Direct Answer: Definitely, I already use robotic appliances like robot vacuums.',
            'Reason: It frees up precious weekend hours for hobbies and quality family time.',
            'Alternative/Caveat: However, privacy and data security need to be regulated.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'free up',
              ipa: '/friː ʌp/',
              type: 'phrasal verb',
              meaning: 'Giải phóng (thời gian, không gian)',
              example: 'Automating domestic chores frees up several hours each weekend.',
            ),
            SpeakingVocabItem(
              word: 'privacy concerns',
              ipa: '/ˈprɪv.ə.si kənˈsɜːnz/',
              type: 'collocation',
              meaning: 'Những lo ngại về quyền riêng tư',
              example: 'Cameras on household robots can trigger legitimate privacy concerns.',
            ),
          ],
          sampleAnswerBand8:
              'Certainly, I would welcome that with open arms. In fact, many households nowadays already rely on robotic vacuum cleaners. Having an intelligent device handle domestic chores frees up invaluable time for creative pursuits, provided that strict privacy safeguards are in place.',
          audioDurationSeconds: 20,
        ),
      ],
    ),

    // 2. Hometown & Relocation (Part 1 Bắt buộc - Quý 3)
    SpeakingTopic(
      id: 'spk_q3_02',
      quarter: 'Q3-2026',
      title: 'Hometown & City Life',
      titleVi: 'Quê hương và Đời sống đô thị',
      categoryTag: 'part1_required',
      bandTarget: 'Band 6.0 - 7.5',
      tagLabel: 'BẮT BUỘC · CỰC KỲ PHỔ BIẾN',
      viewsCount: 38200,
      questions: [
        SpeakingQuestion(
          id: 'spk_q3_02_q1',
          part: SpeakingPart.part1,
          questionText: 'What do you like most about your hometown?',
          ideaHints: [
            'Direct Answer: The harmonious blend of tranquil nature and vibrant street food culture.',
            'Reason: People are hospitable, and life feels noticeably less frantic than in megalopolises.',
            'Example: Gathering with friends at open-air coffee shops by the riverbank.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'harmonious blend',
              ipa: '/hɑːˈməʊ.ni.əs blend/',
              type: 'collocation',
              meaning: 'Sự pha trộn hài hòa, nhịp nhàng',
              example: 'My city exhibits a harmonious blend of heritage and modernization.',
            ),
            SpeakingVocabItem(
              word: 'hospitable',
              ipa: '/hɒsˈpɪt.ə.bəl/',
              type: 'adj',
              meaning: 'Hiếu khách, nồng hậu',
              example: 'The locals are exceptionally hospitable toward foreign travelers.',
            ),
            SpeakingVocabItem(
              word: 'hustle and bustle',
              ipa: '/ˈhʌs.əl ənd ˈbʌs.əl/',
              type: 'idiom',
              meaning: 'Sự ồn ào náo nhiệt của chốn phồn hoa',
              example: 'I love retreating from the hustle and bustle of downtown.',
            ),
          ],
          sampleAnswerBand8:
              'What appeals to me the most is the harmonious blend of historic charm and modern vibrancy. Unlike congested metropolises, my hometown retains a warm community spirit where locals are remarkably hospitable, and you can always escape the hustle and bustle by taking a stroll along the waterfront.',
          audioDurationSeconds: 24,
        ),
      ],
    ),

    // 3. Memorable Road Trip (Part 2 + 3 - Quý 3)
    SpeakingTopic(
      id: 'spk_q3_03',
      quarter: 'Q3-2026',
      title: 'Describe an Unforgettable Road Trip',
      titleVi: 'Mô tả một chuyến phượt đường dài đáng nhớ',
      categoryTag: 'part2_3',
      bandTarget: 'Band 6.5 - 8.5',
      tagLabel: 'PART 2 CUE CARD · ĐỀ MỚI',
      viewsCount: 19500,
      questions: [
        SpeakingQuestion(
          id: 'spk_q3_03_cue',
          part: SpeakingPart.part2,
          questionText: 'Describe an unforgettable road trip you have taken.',
          cueCardPrompts: [
            'Where you went and who you traveled with',
            'How you got there and what the scenery looked like',
            'What memorable incidents or activities happened during the journey',
            'And explain why this road trip left such an indelible impression on you.',
          ],
          ideaHints: [
            'Introduction: Coastal highway trip with close college buddies last summer.',
            'Route & Scenery: Turquoise ocean on one side, towering mountain passes on the other.',
            'Memorable Highlight: Tire puncture at twilight led to bonding with a welcoming local farmer.',
            'Reflection: Realized that the journey itself holds far more value than the final destination.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'indelible impression',
              ipa: '/ɪnˈdel.ə.bəl ɪmˈpreʃ.ən/',
              type: 'collocation',
              meaning: 'Ấn tượng không thể phai mờ',
              example: 'The breathtaking cliff vistas made an indelible impression on me.',
            ),
            SpeakingVocabItem(
              word: 'off the beaten track',
              ipa: '/ɒf ðə ˈbiː.tən træk/',
              type: 'idiom',
              meaning: 'Xa xôi hẻo lánh, hoang sơ chưa bị thương mại hóa',
              example: 'We decided to steer off the beaten track to discover secluded coves.',
            ),
            SpeakingVocabItem(
              word: 'comradeship',
              ipa: '/ˈkɒm.reɪd.ʃɪp/',
              type: 'noun',
              meaning: 'Tình bạn bè đồng chí gắn bó keo sơn',
              example: 'Overcoming road obstacles cemented our deep sense of comradeship.',
            ),
          ],
          sampleAnswerBand8:
              'I would like to recount an extraordinary road trip I embarked upon last August with three of my closest university friends. We traversed the dramatic coastal highway connecting central and southern provinces.\n\nThe scenery was utterly sensational: on our left was the azure sea glittering under golden sunlight, while on our right stood rugged mountain peaks blanketed in mist. What made the expedition truly unforgettable was an unexpected flat tire right as dusk fell. Far from panicking, we ended up receiving heartfelt assistance from a local orchard owner who welcomed us into his home for warm tea and homegrown fruit. That spontaneous encounter reinforced the adage that life is about the journey, not merely the destination.',
          audioDurationSeconds: 65,
        ),
      ],
    ),

    // 4. Sustainable Shopping & Fast Fashion (Part 1 & 3 - Hot Trend)
    SpeakingTopic(
      id: 'spk_q3_04',
      quarter: 'Q3-2026',
      title: 'Shopping Habits & Fast Fashion',
      titleVi: 'Thói quen mua sắm và Thời trang nhanh',
      categoryTag: 'hot_trend',
      bandTarget: 'Band 7.0 - 8.5',
      tagLabel: 'THI THẬT CỰC CĂNG 🔥',
      viewsCount: 29100,
      questions: [
        SpeakingQuestion(
          id: 'spk_q3_04_q1',
          part: SpeakingPart.part3,
          questionText: 'Why do you think fast fashion remains overwhelmingly popular despite its environmental drawbacks?',
          ideaHints: [
            'Reason 1: Affordability and constant algorithmic micro-trends on social media.',
            'Reason 2: Fast gratification allows young consumers to experiment without hefty financial commitments.',
            'Counter-measure: Growing awareness among Gen Z supporting thrifting and circular fashion.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'instant gratification',
              ipa: '/ˌɪn.stənt ˌɡræt.ɪ.fɪˈkeɪ.ʃən/',
              type: 'collocation',
              meaning: 'Sự thỏa mãn tức thì',
              example: 'Fast fashion taps into consumers craving instant gratification.',
            ),
            SpeakingVocabItem(
              word: 'ecological footprint',
              ipa: '/ˌiː.kəˈlɒdʒ.ɪ.kəl ˈfʊt.prɪnt/',
              type: 'collocation',
              meaning: 'Dấu chân sinh thái, tác động môi trường',
              example: 'Mass textile production carries a colossal ecological footprint.',
            ),
            SpeakingVocabItem(
              word: 'thrifting',
              ipa: '/ˈθrɪf.tɪŋ/',
              type: 'noun',
              meaning: 'Trào lưu mua đồ si, đồ vintage tái chế',
              example: 'Thrifting has transitioned from a niche hobby into a mainstream movement.',
            ),
          ],
          sampleAnswerBand8:
              'In my observation, the persistent allure of fast fashion boils down to instant gratification combined with aggressive social media marketing. Ultra-cheap garments enable consumers to mimic transient micro-trends without financial strain. However, this reckless consumption exacts a colossal ecological footprint through textile waste and chemical pollution. Thankfully, ethical alternatives like thrifting and garment swapping are gradually gaining traction.',
          audioDurationSeconds: 32,
        ),
      ],
    ),

    // 5. Impressive Public Library (Part 2 + 3 - Quý 3)
    SpeakingTopic(
      id: 'spk_q3_05',
      quarter: 'Q3-2026',
      title: 'Describe an Impressive Public Library',
      titleVi: 'Mô tả một thư viện công cộng ấn tượng',
      categoryTag: 'part2_3',
      bandTarget: 'Band 6.5 - 8.0',
      tagLabel: 'PART 2 CUE CARD',
      viewsCount: 16800,
      questions: [
        SpeakingQuestion(
          id: 'spk_q3_05_cue',
          part: SpeakingPart.part2,
          questionText: 'Describe an impressive library that you have visited.',
          cueCardPrompts: [
            'Where the library is located',
            'What the building and interior design looked like',
            'What services and facilities were offered there',
            'And explain why this library impressed you so deeply.',
          ],
          ideaHints: [
            'Location: City Central Library situated in the historic downtown core.',
            'Architecture: Floor-to-ceiling glass atriums allowing abundant natural daylight.',
            'Facilities: Quiet study pods, comprehensive digital research databases, multimedia labs.',
            'Impression: A democratic sanctuary of knowledge open to citizens from all walks of life.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'sanctuary of knowledge',
              ipa: '/ˈsæŋk.tʃʊə.ri əv ˈnɒl.ɪdʒ/',
              type: 'collocation',
              meaning: 'Thánh đường của tri thức, nơi học tập yên bình',
              example: 'The library serves as an inspiring sanctuary of knowledge.',
            ),
            SpeakingVocabItem(
              word: 'floor-to-ceiling',
              ipa: '/ˌflɔːr.təˈsiː.lɪŋ/',
              type: 'adj',
              meaning: 'Từ sàn lên tận trần nhà (cửa kính lớn)',
              example: 'Floor-to-ceiling glass panels illuminate the study halls.',
            ),
          ],
          sampleAnswerBand8:
              'The most magnificent library I have ever set foot in is our metropolitan Central Library. Designed with avant-garde Scandinavian aesthetics, it boasts soaring floor-to-ceiling glass atriums that bathe the reading areas in warm natural light. Beyond its vast repository of physical books, it provides soundproof digital media pods and collaborative workspaces. It stands as a true sanctuary of knowledge where students and lifelong learners alike feel inspired.',
          audioDurationSeconds: 50,
        ),
      ],
    ),

    // 6. Habits & Morning Routines (Quý 2)
    SpeakingTopic(
      id: 'spk_q2_01',
      quarter: 'Q2-2026',
      title: 'Habits & Morning Routines',
      titleVi: 'Thói quen và Lịch trình buổi sáng',
      categoryTag: 'part1_topic',
      bandTarget: 'Band 6.0 - 7.5',
      tagLabel: 'QUÝ 2 · BỀN VỮNG',
      viewsCount: 22100,
      questions: [
        SpeakingQuestion(
          id: 'spk_q2_01_q1',
          part: SpeakingPart.part1,
          questionText: 'Do you have a fixed routine in the morning?',
          ideaHints: [
            'Direct Answer: Yes, I adhere to a relatively structured morning regimen.',
            'Actions: Waking at 6 AM, light stretching, brewing fresh black coffee, review top priorities.',
            'Benefit: It sets a positive, calm tone for the rest of the workday.',
          ],
          usefulVocab: [
            SpeakingVocabItem(
              word: 'structured regimen',
              ipa: '/ˈstrʌk.tʃəd ˈredʒ.ɪ.mən/',
              type: 'collocation',
              meaning: 'Chế độ sinh hoạt nề nếp, bài bản',
              example: 'Adhering to a structured regimen primes me for high productivity.',
            ),
            SpeakingVocabItem(
              word: 'set the tone',
              ipa: '/set ðə təʊn/',
              type: 'idiom',
              meaning: 'Tạo đà, tạo không khí định hướng',
              example: 'A serene morning routine sets the tone for a fulfilling day.',
            ),
          ],
          sampleAnswerBand8:
              'I definitely adhere to a disciplined morning regimen. I usually rise at dawn, spend twenty minutes practicing mindfulness and light yoga, followed by brewing a cup of pour-over coffee. This deliberate routine helps set a composed tone before the whirlwind of daily responsibilities commences.',
          audioDurationSeconds: 22,
        ),
      ],
    ),
  ];

  /// Danh sách thẻ bài bốc ngẫu nhiên (Speaking Roulette Cards 3D)
  static const List<SpeakingRouletteCard> rouletteCards = [
    SpeakingRouletteCard(
      id: 'roulette_01',
      part: SpeakingPart.part1,
      topicName: 'Sunglasses & Eye Protection',
      question: 'Do you often wear sunglasses when heading outdoors?',
      cuePoints: [
        'Protecting eyesight against harsh ultraviolet (UV) radiation and blinding glare.',
        'Using sunglasses as a sleek fashion accessory to complement daily streetwear.',
        'Preference for polarized lenses when driving on sunny coastal roads.',
      ],
      contextualVocab: [
        SpeakingVocabItem(
          word: 'blinding glare',
          ipa: '/ˈblaɪn.dɪŋ ɡleər/',
          type: 'collocation',
          meaning: 'Ánh nắng chói lóa mắt',
          example: 'Polarized lenses shield my eyes from blinding glare while driving.',
        ),
        SpeakingVocabItem(
          word: 'UV radiation',
          ipa: '/ˌjuːˈviː ˌreɪ.diˈeɪ.ʃən/',
          type: 'noun',
          meaning: 'Tia bức xạ cực tím',
          example: 'Quality sunglasses block harmful UV radiation effectively.',
        ),
        SpeakingVocabItem(
          word: 'fashion statement',
          ipa: '/ˈfæʃ.ən ˌsteɪt.mənt/',
          type: 'collocation',
          meaning: 'Tuyên ngôn phong cách thời trang',
          example: 'Oversized shades serve as a bold fashion statement.',
        ),
      ],
      sampleAnswer:
          'Whenever I venture outdoors on scorching summer days, sunglasses are an indispensable companion. Primarily, they shield my retinas from blinding glare and pernicious UV radiation. Beyond functional protection, I regard a classic pair of aviator shades as a stylish fashion statement that elevates even the most casual attire.',
    ),
    SpeakingRouletteCard(
      id: 'roulette_02',
      part: SpeakingPart.part2,
      topicName: 'Memorable Mountain Expedition',
      question: 'Describe an unforgettable journey through high mountain passes.',
      cuePoints: [
        'Traversing high-altitude serpentine roads surrounded by cascading waterfalls.',
        'Overcoming physical fatigue and bonding with companion riders at twilight.',
        'The awe-inspiring feeling of standing above sea of clouds at dawn.',
      ],
      contextualVocab: [
        SpeakingVocabItem(
          word: 'serpentine roads',
          ipa: '/ˈsɜː.pən.taɪn rəʊdz/',
          type: 'collocation',
          meaning: 'Những cung đường uốn lượn ngoằn ngoèo',
          example: 'Navigating serpentine mountain roads requires utmost concentration.',
        ),
        SpeakingVocabItem(
          word: 'awe-inspiring',
          ipa: '/ˈɔː.ɪnˌspaɪə.rɪŋ/',
          type: 'adj',
          meaning: 'Choáng ngợp, đẹp đến sững sờ',
          example: 'The panoramic vista at the summit was truly awe-inspiring.',
        ),
        SpeakingVocabItem(
          word: 'unwind',
          ipa: '/ʌnˈwaɪnd/',
          type: 'verb',
          meaning: 'Thư giãn, giải tỏa căng thẳng',
          example: 'Being immersed in untouched nature helped me completely unwind.',
        ),
      ],
      sampleAnswer:
          'I would like to describe a breathtaking motorcycle expedition across the northern mountainous peaks. Negotiating serpentine passes with sheer vertical drops on either side pushed me far out of my comfort zone. Yet, when we reached the summit at sunrise and gazed across a sea of billowy clouds, all exhaustion vanished. It offered a profound sense of awe and perspective on human fragility.',
    ),
    SpeakingRouletteCard(
      id: 'roulette_03',
      part: SpeakingPart.part3,
      topicName: 'AI & The Future of Education',
      question: 'How will artificial intelligence revolutionize classroom pedagogy in the next decade?',
      cuePoints: [
        'Customized adaptive curricula tailored to each learner\'s unique cognitive tempo.',
        'Human educators shifting towards mentors of emotional resilience and ethical thinking.',
        'Eliminating administrative grading burdens to focus on meaningful mentorship.',
      ],
      contextualVocab: [
        SpeakingVocabItem(
          word: 'tailored curriculum',
          ipa: '/ˈteɪ.ləd kəˈrɪk.jə.ləm/',
          type: 'collocation',
          meaning: 'Giáo trình được may đo, cá nhân hóa',
          example: 'AI generates a tailored curriculum responsive to student strengths.',
        ),
        SpeakingVocabItem(
          word: 'foster critical thinking',
          ipa: '/ˈfɒs.tər ˈkrɪt.ɪ.kəl ˈθɪŋ.kɪŋ/',
          type: 'collocation',
          meaning: 'Nuôi dưỡng tư duy phản biện',
          example: 'Teachers must pivot toward fostering critical thinking and empathy.',
        ),
        SpeakingVocabItem(
          word: 'indispensable',
          ipa: '/ˌɪn.dɪˈspen.sə.bəl/',
          type: 'adj',
          meaning: 'Không thể thiếu, tối quan trọng',
          example: 'Human warmth remains indispensable in nurturing children.',
        ),
      ],
      sampleAnswer:
          'Looking ahead, artificial intelligence will fundamentally democratize pedagogy by providing real-time, tailored curricula that dynamically adjust to each pupil\'s learning pace. Teachers will no longer squander hours grading worksheets; instead, they will assume the indispensable mantle of mentors who foster critical thinking, creativity, and moral discernment—domains where algorithms fall hopelessly short.',
    ),
    SpeakingRouletteCard(
      id: 'roulette_04',
      part: SpeakingPart.part1,
      topicName: 'Reading Mediums: Print vs E-books',
      question: 'Do you prefer reading physical books or digital e-readers?',
      cuePoints: [
        'The nostalgic tactile sensation and smell of physical paper pages.',
        'Unmatched portability of having an entire library on a lightweight e-reader.',
        'Mitigating eye strain during prolonged late-night study sessions.',
      ],
      contextualVocab: [
        SpeakingVocabItem(
          word: 'tactile sensation',
          ipa: '/ˈtæk.taɪl senˈseɪ.ʃən/',
          type: 'collocation',
          meaning: 'Cảm giác xúc giác khi chạm vào',
          example: 'I cherish the tactile sensation of turning printed paper pages.',
        ),
        SpeakingVocabItem(
          word: 'unmatched portability',
          ipa: '/ʌnˈmætʃt ˌpɔː.təˈbɪl.ə.ti/',
          type: 'collocation',
          meaning: 'Tính cơ động, tiện mang theo vô đối',
          example: 'Digital tablets offer unmatched portability on long commutes.',
        ),
        SpeakingVocabItem(
          word: 'immerse oneself',
          ipa: '/ɪˈmɜːs wʌnˈself/',
          type: 'collocation',
          meaning: 'Đắm mình say sưa vào thế giới sách',
          example: 'A physical novel allows me to immerse myself without digital notifications.',
        ),
      ],
      sampleAnswer:
          'Although I deeply appreciate the unmatched portability of e-readers when traveling, my heart unequivocally belongs to physical books. There is an irreplaceable tactile sensation in holding a volume and smelling the ink on paper. Most importantly, a printed book guarantees an uninterrupted sanctuary free from pop-up notifications.',
    ),
  ];
}
