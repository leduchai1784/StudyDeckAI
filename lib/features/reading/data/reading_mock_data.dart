import '../models/reading_test_model.dart';

class ReadingMockData {
  static const List<ReadingTest> allTests = [
    _cambridge20Test1,
    _cambridge19Test1,
    _cambridge18Test1,
  ];

  // ==========================================
  // CAMBRIDGE 20 - READING TEST 1
  // ==========================================
  static const ReadingTest _cambridge20Test1 = ReadingTest(
    id: 'cam20_test1',
    title: 'Cambridge IELTS 20 - Reading Test 1',
    bookSeries: 'Cambridge 20',
    bandTarget: 'Band 6.5 - 7.5',
    totalQuestions: 40,
    durationMinutes: 60,
    passages: [
      // PART 1: The White Horse of Uffington
      ReadingPassage(
        partNumber: 1,
        title: 'The White Horse of Uffington',
        subtitle: 'An ancient chalk hill figure in the English county of Oxfordshire',
        content: '''The cutting of huge figures or "geoglyphs" into the earth of English hillsides has taken place for more than 3,000 years. There are 56 hill figures scattered around England, with the vast majority on the chalk downlands of the southern counties. The figures include giants, horses, crosses and regimental badges. Although the majority of these geoglyphs date from the 18th and 19th centuries, the Uffington White Horse is an extraordinary exception.

The Uffington White Horse is a highly stylised prehistoric hill figure, 110 metres long, carved into the upper slopes of Whitehorse Hill in the parish of Uffington. The horse is situated close to the ancient Ridgeway path that traces the top of the Berkshire Downs. The figure consists of a long, sleek body with disjointed, galloping legs and a beaked head. Unlike more modern, realistic horse carvings, this figure has an abstract, almost minimalist appearance.

The carving was created by digging deep trenches into the turf and topsoil to reveal the underlying brilliant white chalk. Soil analysis and modern optical stimulated luminescence (OSL) dating conducted in the 1990s revealed that the figure was created in the late Bronze Age or early Iron Age, between 1400 and 600 BC. This makes it by far the oldest geoglyph in Britain.

For centuries, researchers and local antiquarians debated why such a massive artwork was created. Some believed it was a tribal emblem constructed by the local Celtic chieftain to claim territory. Others suggested it was a religious tribute to a sun god or equine deity. However, one remarkable fact is clear: without regular scouring and cleaning by local communities, the chalk figure would have been reclaimed and overgrown by grass within thirty to fifty years. The ritual scouring was celebrated with a local fair every seven years until modern preservation bodies took over.''',
        questionGroups: [
          // Questions 1-6: True / False / Not Given
          ReadingQuestionGroup(
            instructions:
                'Do the following statements agree with the information given in Reading Passage 1? Write TRUE if the statement agrees with the information, FALSE if the statement contradicts the information, or NOT GIVEN if there is no information on this.',
            type: ReadingQuestionType.trueFalseNotGiven,
            questions: [
              ReadingQuestion(
                number: 1,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt:
                    'Most geoglyphs found in England were created more than two thousand years ago.',
                correctAnswer: 'FALSE',
                explanation: AnswerExplanation(
                  questionKeyword: 'Most geoglyphs / more than two thousand years ago',
                  passageLocation:
                      'Đoạn 1: "Although the majority of these geoglyphs date from the 18th and 19th centuries, the Uffington White Horse is an extraordinary exception."',
                  paraphraseExplanation:
                      'Bài đọc nêu rõ đa số (majority) các hình khắc trên đồi có niên đại từ thế kỷ 18 và 19 (cách đây 200–300 năm), không phải hơn 2,000 năm trước. Do đó nhận định này đối lập trực tiếp (FALSE).',
                ),
              ),
              ReadingQuestion(
                number: 2,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt:
                    'The design of the Uffington White Horse is notably different from modern horse carvings.',
                correctAnswer: 'TRUE',
                explanation: AnswerExplanation(
                  questionKeyword: 'design / notably different / modern horse carvings',
                  passageLocation:
                      'Đoạn 2: "Unlike more modern, realistic horse carvings, this figure has an abstract, almost minimalist appearance."',
                  paraphraseExplanation:
                      'Bài đọc so sánh: "Khác với các hình khắc ngựa thời hiện đại tả thực, hình tượng này có vẻ ngoài trừu tượng, tối giản". Điều này xác nhận thiết kế của nó khác biệt rõ rệt (TRUE).',
                ),
              ),
              ReadingQuestion(
                number: 3,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt:
                    'The Uffington White Horse is located directly beside a modern motorway.',
                correctAnswer: 'FALSE',
                explanation: AnswerExplanation(
                  questionKeyword: 'located directly beside / modern motorway',
                  passageLocation:
                      'Đoạn 2: "The horse is situated close to the ancient Ridgeway path that traces the top of the Berkshire Downs."',
                  paraphraseExplanation:
                      'Hình tượng này nằm gần con đường mòn cổ xưa (ancient Ridgeway path), không phải cạnh đường cao tốc hiện đại (modern motorway) (FALSE).',
                ),
              ),
              ReadingQuestion(
                number: 4,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt:
                    'Dating techniques in the 1990s confirmed the figure was constructed in prehistoric times.',
                correctAnswer: 'TRUE',
                explanation: AnswerExplanation(
                  questionKeyword: 'dating techniques 1990s / confirmed prehistoric times',
                  passageLocation:
                      'Đoạn 3: "OSL dating conducted in the 1990s revealed that the figure was created in the late Bronze Age or early Iron Age... oldest geoglyph in Britain."',
                  paraphraseExplanation:
                      'Thời kỳ Đồ Đồng muộn hoặc Đồ Sắt sớm thuộc thời tiền sử (prehistoric). Phương pháp định tuổi OSL thập niên 1990 đã xác nhận điều này (TRUE).',
                ),
              ),
              ReadingQuestion(
                number: 5,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt:
                    'Historians now have conclusive proof regarding who commissioned the artwork.',
                correctAnswer: 'FALSE',
                explanation: AnswerExplanation(
                  questionKeyword: 'conclusive proof / who commissioned',
                  passageLocation:
                      'Đoạn 4: "For centuries, researchers and local antiquarians debated why such a massive artwork was created. Some believed... Others suggested..."',
                  paraphraseExplanation:
                      'Các nhà nghiên cứu vẫn tranh cãi (debated) và đưa ra nhiều giả thuyết khác nhau, chưa có bằng chứng kết luận chắc chắn (conclusive proof) (FALSE).',
                ),
              ),
              ReadingQuestion(
                number: 6,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt:
                    'The local fair held every seven years raised money for poor villagers.',
                correctAnswer: 'NOT GIVEN',
                explanation: AnswerExplanation(
                  questionKeyword: 'local fair / seven years / raised money for poor',
                  passageLocation:
                      'Đoạn 4: "The ritual scouring was celebrated with a local fair every seven years until modern preservation bodies took over."',
                  paraphraseExplanation:
                      'Bài đọc có nhắc đến lễ hội hội chợ địa phương tổ chức mỗi 7 năm, nhưng hoàn toàn không đề cập đến mục đích quyên góp tiền cho người nghèo (NOT GIVEN).',
                ),
              ),
            ],
          ),

          // Questions 7-13: Note completion
          ReadingQuestionGroup(
            instructions:
                'Complete the notes below. Choose ONE WORD ONLY from the passage for each answer.',
            type: ReadingQuestionType.noteCompletion,
            questions: [
              ReadingQuestion(
                number: 7,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'The total length of the Uffington White Horse carving is approximately 110 [BLANK].',
                correctAnswer: 'metres',
                acceptableAnswers: ['meters', 'metres'],
                explanation: AnswerExplanation(
                  questionKeyword: 'total length / approximately 110',
                  passageLocation:
                      'Đoạn 2: "...prehistoric hill figure, 110 metres long, carved into the upper slopes..."',
                  paraphraseExplanation:
                      'Từ duy nhất chỉ đơn vị đo độ dài 110 là "metres".',
                ),
              ),
              ReadingQuestion(
                number: 8,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Builders removed turf and soil to uncover the pure white [BLANK] underneath.',
                correctAnswer: 'chalk',
                explanation: AnswerExplanation(
                  questionKeyword: 'removed turf and soil / uncover pure white [BLANK]',
                  passageLocation:
                      'Đoạn 3: "...digging deep trenches into the turf and topsoil to reveal the underlying brilliant white chalk."',
                  paraphraseExplanation:
                      'Từ chỉ vật liệu đá vôi trắng được lộ ra bên dưới là "chalk".',
                ),
              ),
              ReadingQuestion(
                number: 9,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'The figure dates back to the Bronze Age or early [BLANK] Age.',
                correctAnswer: 'iron',
                explanation: AnswerExplanation(
                  questionKeyword: 'Bronze Age or early [BLANK] Age',
                  passageLocation:
                      'Đoạn 3: "...created in the late Bronze Age or early Iron Age..."',
                  paraphraseExplanation:
                      'Cụm từ tương ứng trong bài là "early Iron Age", từ cần điền là "iron".',
                ),
              ),
              ReadingQuestion(
                number: 10,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'One theory suggests the horse represented a tribal [BLANK] to signify territory.',
                correctAnswer: 'emblem',
                explanation: AnswerExplanation(
                  questionKeyword: 'theory / tribal [BLANK] / signify territory',
                  passageLocation:
                      'Đoạn 4: "Some believed it was a tribal emblem constructed by the local Celtic chieftain to claim territory."',
                  paraphraseExplanation:
                      'Sau "tribal" là danh từ "emblem" mang nghĩa biểu tượng bộ lạc.',
                ),
              ),
              ReadingQuestion(
                number: 11,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Other experts theorized it could be an offering to an equine [BLANK].',
                correctAnswer: 'deity',
                explanation: AnswerExplanation(
                  questionKeyword: 'offering to an equine [BLANK]',
                  passageLocation:
                      'Đoạn 4: "Others suggested it was a religious tribute to a sun god or equine deity."',
                  paraphraseExplanation:
                      'Trong bài dùng cụm "equine deity" (thần linh loài ngựa), từ cần điền là "deity".',
                ),
              ),
              ReadingQuestion(
                number: 12,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Without continuous maintenance, the hill figure would be covered by [BLANK] within decades.',
                correctAnswer: 'grass',
                explanation: AnswerExplanation(
                  questionKeyword: 'without continuous maintenance / covered by [BLANK]',
                  passageLocation:
                      'Đoạn 4: "...would have been reclaimed and overgrown by grass within thirty to fifty years."',
                  paraphraseExplanation:
                      'Từ chỉ thực vật che phủ hình khắc nếu không được chăm sóc là "grass".',
                ),
              ),
              ReadingQuestion(
                number: 13,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Historically, cleaning rituals took place alongside a community [BLANK] every seven years.',
                correctAnswer: 'fair',
                explanation: AnswerExplanation(
                  questionKeyword: 'cleaning rituals / alongside a community [BLANK]',
                  passageLocation:
                      'Đoạn 4: "The ritual scouring was celebrated with a local fair every seven years..."',
                  paraphraseExplanation:
                      'Sự kiện cộng đồng diễn ra cùng ngày dọn dẹp là "fair" (hội chợ).',
                ),
              ),
            ],
          ),
        ],
      ),

      // PART 2: Building the Skyline: The Birth and Growth of Manhattan's Skyscrapers
      ReadingPassage(
        partNumber: 2,
        title: "Building the Skyline: The Birth and Growth of Manhattan's Skyscrapers",
        subtitle: 'How geology, engineering, and commerce shaped New York City',
        content: '''Paragraph A:
The island of Manhattan boasts one of the most recognizable city skylines on Earth. Today, hundreds of steel and glass spires rise into the clouds, concentrated in two primary clusters: Downtown (the Financial District) and Midtown. For decades, a persistent urban myth held that skyscrapers were absent from the area between Downtown and Midtown because the subterranean bedrock was too deep beneath the surface. However, comprehensive geographical surveys published in 2011 demonstrated that builders could easily drive foundation piles into bedrock regardless of depth. The true reason for the famous "gap" in Manhattan's skyline was purely economic: Midtown grew rapidly around the central transport terminals of Grand Central and Penn Station, while businesses in Lower Manhattan clustered around Wall Street and the historic harbour.

Paragraph B:
Before the mid-19th century, urban buildings rarely exceeded five or six storeys. Human physiology placed a practical limitation on architecture: climbing more than five flights of stairs on a daily basis was exhausting for office workers and residents alike. The invention that dismantled this architectural barrier was the safety elevator, developed by Elisha Graves Otis in 1853. Otis engineered a spring-operated braking mechanism that prevented the lift cab from plummeting even if the supporting cables snapped. Suddenly, higher floors were transformed from undesirable garrets into prime real estate with superior natural light, ventilation, and prestige.

Paragraph C:
The second revolutionary milestone was the transition from load-bearing masonry to steel skeleton frames. In traditional brick and stone construction, the thickness of the exterior ground-floor walls had to increase exponentially with each additional storey to bear the weight. This meant that very tall stone buildings lost enormous amounts of rentable interior floor space on their lowest levels. In the late 1880s, pioneering Chicago architects realized that a grid of rolled steel beams could shoulder the entire gravitational load. Exterior walls could then become paper-thin "curtain walls", maximizing interior floor space and permitting giant windows that flooded rooms with daylight.

Paragraph D:
By the late 1920s, skyscraper construction in Manhattan had entered an era of fierce corporate rivalry. Prominent developers raced to erect the tallest tower on the planet. The pinnacle of this competition occurred between the Chrysler Building and the Empire State Building. Walter Chrysler ordered a 125-foot steel spire to be assembled secretly inside the building's fire tower and hoisted into place in just 90 minutes, briefly snatching the title of world's tallest building. However, just eleven months later in May 1931, the Empire State Building opened at 102 storeys (381 metres), retaining the global crown for more than four decades.''',
        questionGroups: [
          // Questions 14-19: Matching Paragraphs
          ReadingQuestionGroup(
            instructions:
                'Reading Passage 2 has four paragraphs, A-D. Which paragraph contains the following information? You may use any letter more than once.',
            type: ReadingQuestionType.matchingHeadings,
            questions: [
              ReadingQuestion(
                number: 14,
                type: ReadingQuestionType.matchingHeadings,
                prompt:
                    'Refutation of a common misconception about the location of tall buildings.',
                options: ['Paragraph A', 'Paragraph B', 'Paragraph C', 'Paragraph D'],
                correctAnswer: 'Paragraph A',
                explanation: AnswerExplanation(
                  questionKeyword: 'Refutation of a common misconception / location',
                  passageLocation:
                      'Đoạn A: "For decades, a persistent urban myth held that skyscrapers were absent... However, comprehensive geographical surveys demonstrated... The true reason was purely economic"',
                  paraphraseExplanation:
                      'Đoạn A bác bỏ hiểu lầm phổ biến (urban myth) rằng độ sâu của tầng đá ngầm quyết định vị trí xây nhà chọc trời, chứng minh lý do thực sự là kinh tế.',
                ),
              ),
              ReadingQuestion(
                number: 15,
                type: ReadingQuestionType.matchingHeadings,
                prompt:
                    'A description of how an innovative braking device enhanced building safety.',
                options: ['Paragraph A', 'Paragraph B', 'Paragraph C', 'Paragraph D'],
                correctAnswer: 'Paragraph B',
                explanation: AnswerExplanation(
                  questionKeyword: 'innovative braking device / enhanced safety',
                  passageLocation:
                      'Đoạn B: "Otis engineered a spring-operated braking mechanism that prevented the lift cab from plummeting even if the supporting cables snapped."',
                  paraphraseExplanation:
                      'Đoạn B miêu tả cơ chế phanh lò xo của thang máy an toàn Otis giúp cabin không bị rơi.',
                ),
              ),
              ReadingQuestion(
                number: 16,
                type: ReadingQuestionType.matchingHeadings,
                prompt:
                    'An explanation of why traditional stone structures had restricted interior areas.',
                options: ['Paragraph A', 'Paragraph B', 'Paragraph C', 'Paragraph D'],
                correctAnswer: 'Paragraph C',
                explanation: AnswerExplanation(
                  questionKeyword: 'traditional stone structures / restricted interior areas',
                  passageLocation:
                      'Đoạn C: "...thickness of exterior ground-floor walls had to increase... tall stone buildings lost enormous amounts of rentable interior floor space..."',
                  paraphraseExplanation:
                      'Đoạn C giải thích tại sao tường gạch đá chịu lực quá dày khiến diện tích sàn cho thuê bên trong bị hao hụt nặng nề.',
                ),
              ),
              ReadingQuestion(
                number: 17,
                type: ReadingQuestionType.matchingHeadings,
                prompt:
                    'A dramatic account of corporate rivalry to secure a global height record.',
                options: ['Paragraph A', 'Paragraph B', 'Paragraph C', 'Paragraph D'],
                correctAnswer: 'Paragraph D',
                explanation: AnswerExplanation(
                  questionKeyword: 'corporate rivalry / global height record',
                  passageLocation:
                      'Đoạn D: "...entered an era of fierce corporate rivalry. Prominent developers raced to erect the tallest tower on the planet... Chrysler Building and the Empire State Building."',
                  paraphraseExplanation:
                      'Đoạn D thuật lại cuộc đua tranh danh hiệu tòa nhà cao nhất thế giới giữa Chrysler Building và Empire State Building.',
                ),
              ),
              ReadingQuestion(
                number: 18,
                type: ReadingQuestionType.matchingHeadings,
                prompt:
                    'The role of transport hubs in concentrating commercial development.',
                options: ['Paragraph A', 'Paragraph B', 'Paragraph C', 'Paragraph D'],
                correctAnswer: 'Paragraph A',
                explanation: AnswerExplanation(
                  questionKeyword: 'transport hubs / concentrating commercial development',
                  passageLocation:
                      'Đoạn A: "Midtown grew rapidly around the central transport terminals of Grand Central and Penn Station..."',
                  paraphraseExplanation:
                      'Đoạn A nêu rõ các nhà ga trung tâm (Grand Central & Penn Station) đã tập trung hóa các tòa nhà văn phòng tại Midtown.',
                ),
              ),
              ReadingQuestion(
                number: 19,
                type: ReadingQuestionType.matchingHeadings,
                prompt:
                    'The transformation in financial desirability of upper floors.',
                options: ['Paragraph A', 'Paragraph B', 'Paragraph C', 'Paragraph D'],
                correctAnswer: 'Paragraph B',
                explanation: AnswerExplanation(
                  questionKeyword: 'transformation in financial desirability / upper floors',
                  passageLocation:
                      'Đoạn B: "Suddenly, higher floors were transformed from undesirable garrets into prime real estate with superior natural light, ventilation, and prestige."',
                  paraphraseExplanation:
                      'Đoạn B mô tả sự biến đổi giá trị bất động sản của các tầng cao sau khi có thang máy.',
                ),
              ),
            ],
          ),

          // Questions 20-26: Summary completion
          ReadingQuestionGroup(
            instructions:
                'Complete the summary below. Choose NO MORE THAN TWO WORDS from the passage for each answer.',
            type: ReadingQuestionType.noteCompletion,
            questions: [
              ReadingQuestion(
                number: 20,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Early buildings were constrained because walking up stairs caused extreme fatigue for human [BLANK].',
                correctAnswer: 'physiology',
                explanation: AnswerExplanation(
                  questionKeyword: 'constrained / human [BLANK]',
                  passageLocation:
                      'Đoạn B: "Human physiology placed a practical limitation on architecture: climbing more than five flights..."',
                  paraphraseExplanation:
                      'Yếu tố sinh học giới hạn con người được nhắc đến chính xác là "physiology".',
                ),
              ),
              ReadingQuestion(
                number: 21,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'In 1853, Elisha Graves Otis devised the safety [BLANK].',
                correctAnswer: 'elevator',
                explanation: AnswerExplanation(
                  questionKeyword: 'In 1853 / Otis devised / safety [BLANK]',
                  passageLocation:
                      'Đoạn B: "...developed by Elisha Graves Otis in 1853. Otis engineered a spring-operated braking mechanism..."',
                  paraphraseExplanation:
                      'Phát minh năm 1853 của Otis là "safety elevator".',
                ),
              ),
              ReadingQuestion(
                number: 22,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Late 19th-century architecture was revolutionized by replacing heavy stone with [BLANK] frames.',
                correctAnswer: 'steel skeleton',
                acceptableAnswers: ['steel', 'steel skeleton'],
                explanation: AnswerExplanation(
                  questionKeyword: 'replacing heavy stone with [BLANK] frames',
                  passageLocation:
                      'Đoạn C: "The second revolutionary milestone was the transition from load-bearing masonry to steel skeleton frames."',
                  paraphraseExplanation:
                      'Khung kết cấu thay thế khối gạch đá chịu lực là "steel skeleton" (hoặc "steel").',
                ),
              ),
              ReadingQuestion(
                number: 23,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Thin non-structural outer boundaries became known as [BLANK] walls.',
                correctAnswer: 'curtain',
                explanation: AnswerExplanation(
                  questionKeyword: 'outer boundaries / known as [BLANK] walls',
                  passageLocation:
                      'Đoạn C: "Exterior walls could then become paper-thin "curtain walls"..."',
                  paraphraseExplanation:
                      'Thuật ngữ trong ngoặc kép cho tường kính mỏng ngoài là "curtain" walls.',
                ),
              ),
              ReadingQuestion(
                number: 24,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'Walter Chrysler secretly fabricated a 125-foot steel [BLANK] inside his building.',
                correctAnswer: 'spire',
                explanation: AnswerExplanation(
                  questionKeyword: 'secretly fabricated a 125-foot steel [BLANK]',
                  passageLocation:
                      'Đoạn D: "Walter Chrysler ordered a 125-foot steel spire to be assembled secretly inside..."',
                  paraphraseExplanation:
                      'Vật thể dài 125 feet được lắp ráp bí mật là chiếc chóp nhọn "spire".',
                ),
              ),
              ReadingQuestion(
                number: 25,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'The rapid assembly of the Chrysler spire took merely [BLANK] minutes.',
                correctAnswer: '90',
                acceptableAnswers: ['90', 'ninety'],
                explanation: AnswerExplanation(
                  questionKeyword: 'assembly took merely [BLANK] minutes',
                  passageLocation:
                      'Đoạn D: "...and hoisted into place in just 90 minutes..."',
                  paraphraseExplanation:
                      'Thời gian kéo và cố định chiếc chóp nhọn là 90 phút ("90").',
                ),
              ),
              ReadingQuestion(
                number: 26,
                type: ReadingQuestionType.noteCompletion,
                prompt:
                    'The Empire State Building held the world record for more than four [BLANK].',
                correctAnswer: 'decades',
                explanation: AnswerExplanation(
                  questionKeyword: 'held the world record for more than four [BLANK]',
                  passageLocation:
                      'Đoạn D: "...retaining the global crown for more than four decades."',
                  paraphraseExplanation:
                      'Cụm từ "four decades" biểu thị hơn 4 thập kỷ giữ kỷ lục thế giới.',
                ),
              ),
            ],
          ),
        ],
      ),

      // PART 3: The Return of the Huia / Artificial Intelligence in Healthcare
      ReadingPassage(
        partNumber: 3,
        title: 'Artificial Intelligence and the Future of Clinical Diagnosis',
        subtitle: 'Can machine learning algorithms truly outperform human physicians?',
        content: '''The integration of Artificial Intelligence (AI) into clinical healthcare has sparked unprecedented debate among medical practitioners, ethicists, and computer scientists. Deep-learning convolutional neural networks (CNNs) can now scrutinise digital pathology slides, dermatological images, and radiological scans at speeds and accuracies that equal, and occasionally surpass, seasoned human specialists. Yet despite sensational media headlines proclaiming the imminent obsolescence of medical doctors, the reality of implementing clinical AI remains complex, nuanced, and fraught with systemic hurdles.

At the core of clinical AI's remarkable diagnostic prowess is pattern recognition at scale. A human radiologist might evaluate tens of thousands of X-rays across an entire career; a machine-learning algorithm can ingest and analyze millions of annotated scans in a single weekend. In a landmark 2020 study published in Nature, an AI system developed by Google Health outperformed six expert radiologists in detecting breast cancer from screening mammograms, decreasing false positives by 5.7% in the United States and 1.2% in the United Kingdom. Similar breakthroughs have been achieved in ophthalmology, where automated systems evaluate retinal photographs to detect diabetic retinopathy before patients experience noticeable vision loss.

However, the transition from pristine laboratory benchmarks to messy real-world clinical practice has exposed deep vulnerabilities. Chief among these is the problem of algorithmic bias and data fragmentation. The overwhelming majority of training datasets originate from affluent urban academic teaching hospitals. When these algorithms are deployed in rural clinics or diverse ethnic demographics with varying equipment brands and imaging protocols, their diagnostic sensitivity often degrades precipitously. Furthermore, machine-learning models remain notorious "black boxes": they can generate a probabilistic diagnosis, but cannot explain the underlying biological causal reasoning to a curious clinician or anxious patient.

Consequently, most healthcare authorities advocate for a paradigm of "collaborative intelligence" rather than full automation. When clinicians and algorithms work symbiotically—the AI handling exhaustive data-filtering while human doctors provide contextual judgement, holistic empathy, and bedside bedside communication—diagnostic error rates drop far lower than either entity achieves in isolation. The future of healthcare does not belong to machines replacing humans, but to physicians who harness AI replacing those who refuse to adapt.''',
        questionGroups: [
          // Questions 27-31: Multiple Choice
          ReadingQuestionGroup(
            instructions:
                'Choose the correct letter, A, B, C, or D for Questions 27–31.',
            type: ReadingQuestionType.multipleChoice,
            questions: [
              ReadingQuestion(
                number: 27,
                type: ReadingQuestionType.multipleChoice,
                prompt:
                    'What does the author state in the first paragraph about medical AI?',
                options: [
                  'A. It has already completely replaced human radiologists in most hospitals.',
                  'B. Media reports frequently exaggerate how soon doctors will become obsolete.',
                  'C. Deep-learning algorithms have proven too slow for practical clinical deployment.',
                  'D. Medical ethicists are entirely satisfied with current legal frameworks.'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: 'first paragraph / medical AI',
                  passageLocation:
                      'Đoạn 1: "...despite sensational media headlines proclaiming the imminent obsolescence of medical doctors, the reality... remains complex..."',
                  paraphraseExplanation:
                      'Tác giả nêu rõ các tiêu đề truyền thông giật gân (sensational media headlines) thổi phồng việc các bác sĩ sắp bị thay thế (obsolescence), trong khi thực tế phức tạp hơn nhiều (Đáp án B).',
                ),
              ),
              ReadingQuestion(
                number: 28,
                type: ReadingQuestionType.multipleChoice,
                prompt:
                    'Why does clinical AI possess such powerful diagnostic ability?',
                options: [
                  'A. It understands human emotional distress better than doctors.',
                  'B. It can process and identify patterns across immense volumes of data.',
                  'C. It requires no prior data training to make accurate predictions.',
                  'D. It has completely eliminated diagnostic errors across all fields.'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: 'why / powerful diagnostic ability',
                  passageLocation:
                      'Đoạn 2: "At the core of clinical AI\'s remarkable diagnostic prowess is pattern recognition at scale... ingest and analyze millions of annotated scans..."',
                  paraphraseExplanation:
                      'Nền tảng sức mạnh của AI là khả năng nhận diện mẫu ở quy mô lớn (pattern recognition at scale) và xử lý hàng triệu ảnh quét (Đáp án B).',
                ),
              ),
              ReadingQuestion(
                number: 29,
                type: ReadingQuestionType.multipleChoice,
                prompt:
                    'What did the 2020 Nature study on breast cancer detection demonstrate?',
                options: [
                  'A. Human radiologists made fewer mistakes than any computer program.',
                  'B. The AI system had higher rates of false positive diagnoses.',
                  'C. The algorithm surpassed expert radiologists by reducing false positives.',
                  'D. Mammogram screenings should be abandoned entirely in favour of blood tests.'
                ],
                correctAnswer: 'C',
                explanation: AnswerExplanation(
                  questionKeyword: '2020 Nature study / breast cancer detection',
                  passageLocation:
                      'Đoạn 2: "...outperformed six expert radiologists in detecting breast cancer... decreasing false positives by 5.7% in the United States..."',
                  paraphraseExplanation:
                      'Nghiên cứu trên tạp chí Nature chỉ ra AI vượt trội hơn 6 chuyên gia chẩn đoán hình ảnh nhờ giảm thiểu số ca chẩn đoán dương tính giả (false positives) (Đáp án C).',
                ),
              ),
              ReadingQuestion(
                number: 30,
                type: ReadingQuestionType.multipleChoice,
                prompt:
                    'A major flaw of current AI models when deployed in rural settings is that:',
                options: [
                  'A. They consume far too much electrical energy.',
                  'B. Their performance drops because training data lacked diverse demographics.',
                  'C. Rural patients uniformly refuse to permit computer diagnoses.',
                  'D. Modern computers cannot connect to Internet networks outside cities.'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: 'major flaw / rural settings',
                  passageLocation:
                      'Đoạn 3: "The overwhelming majority of training datasets originate from affluent urban... When these algorithms are deployed in rural clinics or diverse ethnic demographics... diagnostic sensitivity often degrades precipitously."',
                  paraphraseExplanation:
                      'Dữ liệu huấn luyện chủ yếu từ các bệnh viện lớn ở thành thị giàu có, nên khi đưa về vùng nông thôn hoặc nhóm dân tộc khác nhau, độ nhạy chẩn đoán sụt giảm nghiêm trọng (Đáp án B).',
                ),
              ),
              ReadingQuestion(
                number: 31,
                type: ReadingQuestionType.multipleChoice,
                prompt:
                    'The term "black box" in paragraph 3 refers to the fact that AI models:',
                options: [
                  'A. Are literally constructed inside impenetrable black containers.',
                  'B. Cannot articulate the logical biological reasoning behind their outputs.',
                  'C. Are prohibited from operating during daylight hospital hours.',
                  'D. Exclusively store private medical records without patient consent.'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: '"black box" / paragraph 3',
                  passageLocation:
                      'Đoạn 3: "...notorious "black boxes": they can generate a probabilistic diagnosis, but cannot explain the underlying biological causal reasoning to a curious clinician..."',
                  paraphraseExplanation:
                      'Khái niệm "hộp đen" chỉ việc AI đưa ra dự đoán nhưng không thể giải thích nguyên lý sinh học nhân quả bên dưới cho bác sĩ hiểu (Đáp án B).',
                ),
              ),
            ],
          ),

          // Questions 32-36: Yes / No / Not Given
          ReadingQuestionGroup(
            instructions:
                'Do the following statements agree with the views of the writer in Reading Passage 3? Write YES if the statement agrees with the views of the writer, NO if the statement contradicts the views of the writer, or NOT GIVEN if it is impossible to say what the writer thinks about this.',
            type: ReadingQuestionType.yesNoNotGiven,
            questions: [
              ReadingQuestion(
                number: 32,
                type: ReadingQuestionType.yesNoNotGiven,
                prompt:
                    'Medical professionals universally welcome the quick introduction of diagnostic AI.',
                correctAnswer: 'NO',
                explanation: AnswerExplanation(
                  questionKeyword: 'universally welcome / diagnostic AI',
                  passageLocation:
                      'Đoạn 1: "...sparked unprecedented debate among medical practitioners, ethicists, and computer scientists."',
                  paraphraseExplanation:
                      'Việc tích hợp AI gây ra tranh luận gay gắt chưa từng có (unprecedented debate), chứ không phải được chào đón đồng thuận trên toàn thế giới (NO).',
                ),
              ),
              ReadingQuestion(
                number: 33,
                type: ReadingQuestionType.yesNoNotGiven,
                prompt:
                    'Ophthalmology algorithms can identify eye disease before the patient perceives any symptoms.',
                correctAnswer: 'YES',
                explanation: AnswerExplanation(
                  questionKeyword: 'Ophthalmology algorithms / identify before patient perceives',
                  passageLocation:
                      'Đoạn 2: "...systems evaluate retinal photographs to detect diabetic retinopathy before patients experience noticeable vision loss."',
                  paraphraseExplanation:
                      'Hệ thống nhãn khoa phát hiện bệnh võng mạc đái tháo đường trước khi bệnh nhân nhận thấy thị lực bị suy giảm (YES).',
                ),
              ),
              ReadingQuestion(
                number: 34,
                type: ReadingQuestionType.yesNoNotGiven,
                prompt:
                    'Most countries have passed strict regulations preventing AI systems from operating without human oversight.',
                correctAnswer: 'NOT GIVEN',
                explanation: AnswerExplanation(
                  questionKeyword: 'passed strict regulations / without human oversight',
                  passageLocation:
                      'Toàn bài không đề cập đến luật pháp hoặc quy định cụ thể của các quốc gia về việc quản lý AI y tế.',
                  paraphraseExplanation:
                      'Bài viết chỉ bàn về công nghệ và khuyến nghị của các cơ quan y tế, không nêu thông tin về các đạo luật đã thông qua (NOT GIVEN).',
                ),
              ),
              ReadingQuestion(
                number: 35,
                type: ReadingQuestionType.yesNoNotGiven,
                prompt:
                    'Combining physician expertise with computer algorithms achieves the lowest diagnostic error rates.',
                correctAnswer: 'YES',
                explanation: AnswerExplanation(
                  questionKeyword: 'combining physician expertise with algorithms / lowest error rates',
                  passageLocation:
                      'Đoạn 4: "When clinicians and algorithms work symbiotically... diagnostic error rates drop far lower than either entity achieves in isolation."',
                  paraphraseExplanation:
                      'Khi bác sĩ và thuật toán phối hợp cộng sinh, tỷ lệ sai sót giảm xuống thấp hơn nhiều so với khi mỗi bên làm việc riêng rẽ (YES).',
                ),
              ),
              ReadingQuestion(
                number: 36,
                type: ReadingQuestionType.yesNoNotGiven,
                prompt:
                    'Doctors who embrace AI technologies are more likely to thrive in the future of medicine.',
                correctAnswer: 'YES',
                explanation: AnswerExplanation(
                  questionKeyword: 'doctors embrace AI / more likely to thrive in future',
                  passageLocation:
                      'Đoạn 4: "The future of healthcare does not belong to machines replacing humans, but to physicians who harness AI replacing those who refuse to adapt."',
                  paraphraseExplanation:
                      'Câu kết bài nhấn mạnh tương lai y học thuộc về những bác sĩ biết ứng dụng AI để thay thế những người từ chối đổi mới (YES).',
                ),
              ),
            ],
          ),

          // Questions 37-40: Sentence Completion
          ReadingQuestionGroup(
            instructions:
                'Complete each sentence with the correct ending, A–F, below.',
            type: ReadingQuestionType.sentenceCompletion,
            questions: [
              ReadingQuestion(
                number: 37,
                type: ReadingQuestionType.sentenceCompletion,
                prompt:
                    'Convolutional neural networks are specifically tailored to [BLANK].',
                options: [
                  'A. perform compassionate bedside communication with frightened families',
                  'B. scrutinise high-resolution medical imagery at remarkable velocity',
                  'C. synthesize new surgical medications without chemical lab tests',
                  'D. generate legal disclaimers for malpractice lawsuits'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: 'CNNs / tailored to',
                  passageLocation:
                      'Đoạn 1: "...convolutional neural networks (CNNs) can now scrutinise digital pathology slides, dermatological images, and radiological scans at speeds and accuracies..."',
                  paraphraseExplanation:
                      'Mạng nơ-ron tích chập (CNN) được phát triển để phân tích các hình ảnh y khoa độ phân giải cao với tốc độ cực nhanh (Đáp án B).',
                ),
              ),
              ReadingQuestion(
                number: 38,
                type: ReadingQuestionType.sentenceCompletion,
                prompt:
                    'A typical hospital radiologist evaluates [BLANK].',
                options: [
                  'A. millions of scans every single working day',
                  'B. tens of thousands of X-rays across an entire career',
                  'C. only pediatric bone fracture records',
                  'D. fewer images than a novice medical student'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: 'hospital radiologist evaluates',
                  passageLocation:
                      'Đoạn 2: "A human radiologist might evaluate tens of thousands of X-rays across an entire career..."',
                  paraphraseExplanation:
                      'Một bác sĩ X-quang thường chỉ đánh giá hàng chục nghìn phim chụp trong toàn bộ sự nghiệp của họ (Đáp án B).',
                ),
              ),
              ReadingQuestion(
                number: 39,
                type: ReadingQuestionType.sentenceCompletion,
                prompt:
                    'Training datasets derived solely from prestigious urban clinics [BLANK].',
                options: [
                  'A. guarantee 100% universal accuracy in every global village',
                  'B. cause diagnostic performance to falter when applied to diverse populations',
                  'C. are completely free of all corporate intellectual property claims',
                  'D. cannot be loaded into modern computing cloud clusters'
                ],
                correctAnswer: 'B',
                explanation: AnswerExplanation(
                  questionKeyword: 'training datasets / urban clinics',
                  passageLocation:
                      'Đoạn 3: "...originates from affluent urban academic teaching hospitals. When these algorithms are deployed in rural clinics or diverse ethnic demographics... diagnostic sensitivity often degrades precipitously."',
                  paraphraseExplanation:
                      'Dữ liệu chỉ thu thập từ các bệnh viện lớn ở thành thị khiến hiệu quả chẩn đoán giảm sút nghiêm trọng khi áp dụng cho các quần thể dân số đa dạng (Đáp án B).',
                ),
              ),
              ReadingQuestion(
                number: 40,
                type: ReadingQuestionType.sentenceCompletion,
                prompt:
                    'Human doctors will always remain indispensable because they [BLANK].',
                options: [
                  'A. possess holistic empathy and contextual clinical judgement',
                  'B. can memorize more image pixels than any supercomputer',
                  'C. charge significantly lower fees than commercial software licenses',
                  'D. do not require sleep or rest during emergency operations'
                ],
                correctAnswer: 'A',
                explanation: AnswerExplanation(
                  questionKeyword: 'human doctors indispensable / because',
                  passageLocation:
                      'Đoạn 4: "...while human doctors provide contextual judgement, holistic empathy, and bedside communication..."',
                  paraphraseExplanation:
                      'Bác sĩ con người không thể thay thế bởi họ mang lại sự đồng cảm toàn diện và khả năng phán đoán bối cảnh lâm sàng (Đáp án A).',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // CAMBRIDGE 19 - READING TEST 1
  // ==========================================
  static const ReadingTest _cambridge19Test1 = ReadingTest(
    id: 'cam19_test1',
    title: 'Cambridge IELTS 19 - Reading Test 1',
    bookSeries: 'Cambridge 19',
    bandTarget: 'Band 6.0 - 7.0',
    totalQuestions: 40,
    durationMinutes: 60,
    passages: [
      ReadingPassage(
        partNumber: 1,
        title: 'Tennis Racket Technology',
        subtitle: 'The engineering revolution behind modern sports performance',
        content: '''Since the origin of lawn tennis in the 1870s, the design of the tennis racket has undergone profound mechanical transformations. For nearly a century, rackets were crafted almost exclusively from laminated ash wood. While wooden rackets were durable and possessed a classic tactile feel, they suffered from significant inherent flaws: they were heavy (averaging around 400 grams), highly vulnerable to atmospheric humidity, and had tiny "sweet spots" of barely 65 square inches.

In the late 1960s, metal frames made of aluminium and steel began entering the mainstream market. These metal iterations allowed manufacturers to expand the racket head surface area, increasing the sweet spot and forgiving off-centre hits. However, metal frames were prone to excessive vibration, which frequently led to chronic elbow injuries among frequent players.

The true quantum leap occurred in the 1980s with the introduction of carbon-fibre reinforced polymer composites, colloquially known as graphite. Graphite combined featherlight weight with unprecedented structural rigidity. Engineers could customize the flex pattern of the frame to maximize power or control according to individual player preference. Today's professional tennis stars wield rackets that weigh less than 300 grams yet transfer immense kinetic energy to the ball, completely altering the pace and tactics of the modern sport.''',
        questionGroups: [
          ReadingQuestionGroup(
            instructions:
                'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.',
            type: ReadingQuestionType.trueFalseNotGiven,
            questions: [
              ReadingQuestion(
                number: 1,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt: 'Traditional wooden tennis rackets weighed on average 400 grams.',
                correctAnswer: 'TRUE',
                explanation: AnswerExplanation(
                  questionKeyword: 'wooden rackets / average 400 grams',
                  passageLocation: 'Đoạn 1: "...they were heavy (averaging around 400 grams)..."',
                  paraphraseExplanation: 'Bài đọc xác nhận rõ khối lượng trung bình của vợt gỗ là khoảng 400 gram (TRUE).',
                ),
              ),
              ReadingQuestion(
                number: 2,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt: 'Wooden rackets were completely unaffected by damp weather.',
                correctAnswer: 'FALSE',
                explanation: AnswerExplanation(
                  questionKeyword: 'unaffected by damp weather',
                  passageLocation: 'Đoạn 1: "...highly vulnerable to atmospheric humidity..."',
                  paraphraseExplanation: 'Vợt gỗ rất dễ bị hư hại bởi độ ẩm (highly vulnerable), không phải không bị ảnh hưởng (FALSE).',
                ),
              ),
              ReadingQuestion(
                number: 3,
                type: ReadingQuestionType.trueFalseNotGiven,
                prompt: 'Carbon-fibre rackets were first invented by an Olympic gold medallist.',
                correctAnswer: 'NOT GIVEN',
                explanation: AnswerExplanation(
                  questionKeyword: 'carbon-fibre / Olympic gold medallist',
                  passageLocation: 'Đoạn 3: "The true quantum leap occurred in the 1980s with the introduction of carbon-fibre..."',
                  paraphraseExplanation: 'Bài đọc không hề đề cập đến danh tính hay giải thưởng của người phát minh ra vợt carbon (NOT GIVEN).',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // CAMBRIDGE 18 - READING TEST 1
  // ==========================================
  static const ReadingTest _cambridge18Test1 = ReadingTest(
    id: 'cam18_test1',
    title: 'Cambridge IELTS 18 - Reading Test 1',
    bookSeries: 'Cambridge 18',
    bandTarget: 'Band 7.0 - 8.0',
    totalQuestions: 40,
    durationMinutes: 60,
    passages: [
      ReadingPassage(
        partNumber: 1,
        title: 'Urban Farming in Ancient and Modern Times',
        subtitle: 'Reviving metropolitan agriculture to feed twenty-first-century megacities',
        content: '''Urban agriculture is far from a contemporary novelty. Throughout human history, cities developed innovative systems to grow fresh produce within their municipal boundaries. Ancient civilizations, such as the Mayans in Mesoamerica and the inhabitants of Mesopotamian city-states, integrated extensive chinampas and rooftop irrigation channels directly into their urban infrastructure.

In modern times, rapid urbanisation and climate volatility have rekindled massive interest in high-tech vertical farms and hydroponic warehouses. By utilizing closed-loop nutrient circulation and precision LED spectrum lighting, modern vertical farms can produce up to 350 times more food per square metre than conventional outdoor open-field agriculture, while consuming 95% less water. Nonetheless, the substantial capital expenditure required to establish climate-controlled facilities remains a formidable commercial obstacle.''',
        questionGroups: [
          ReadingQuestionGroup(
            instructions:
                'Complete the notes below. Choose ONE WORD ONLY from the passage for each answer.',
            type: ReadingQuestionType.noteCompletion,
            questions: [
              ReadingQuestion(
                number: 1,
                type: ReadingQuestionType.noteCompletion,
                prompt: 'Ancient cities in Mesoamerica developed rooftop irrigation [BLANK] for food production.',
                correctAnswer: 'channels',
                explanation: AnswerExplanation(
                  questionKeyword: 'rooftop irrigation [BLANK]',
                  passageLocation: 'Đoạn 1: "...integrated extensive chinampas and rooftop irrigation channels directly..."',
                  paraphraseExplanation: 'Từ cần điền sau "irrigation" là "channels" (kênh tưới tiêu).',
                ),
              ),
              ReadingQuestion(
                number: 2,
                type: ReadingQuestionType.noteCompletion,
                prompt: 'Contemporary vertical farms use 95% less [BLANK] compared to outdoor farming.',
                correctAnswer: 'water',
                explanation: AnswerExplanation(
                  questionKeyword: '95% less [BLANK]',
                  passageLocation: 'Đoạn 2: "...while consuming 95% less water."',
                  paraphraseExplanation: 'Tài nguyên được tiết kiệm tới 95% là nước ("water").',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
