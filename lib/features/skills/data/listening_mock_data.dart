import 'package:flutter/material.dart';
import '../models/listening_test_model.dart';
import '../models/dictation_model.dart';
import '../models/archive_model.dart';

class ListeningMockData {
  /// Danh sách các bộ đề thi nghe Cambridge & Theo Band
  static const List<ListeningTest> allTests = [
    ListeningTest(
      id: 'cam20_test1',
      title: 'Cambridge 20 — Test 1',
      subtitle: 'Part 1 (Hội thoại đặt phòng) & Part 2 (Bản đồ công viên trung tâm)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 15,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Holiday Accommodation Enquiry',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
OFFICER: Good morning, South Coast Holidays. Can I help you?
CALLER: Oh, hello. I'm looking to book a holiday rental near the beach for my family next month.
OFFICER: Certainly! We have several options. Let me take down a few details first. What is your surname, please?
CALLER: It's Miller. That's M-I-L-L-E-R.
OFFICER: Thank you, Mr. Miller. And what dates were you thinking of?
CALLER: We'd like to check in on the 15th of July and stay for a week.
OFFICER: Right, 15th July. How many people will be staying?
CALLER: Just three of us: my wife, myself, and our teenage daughter.
OFFICER: Perfect. We have a lovely cottage called Seaview Lodge. It has two bedrooms and is only 200 metres from the coast.
CALLER: Does it have parking space?
OFFICER: Yes, there's private parking for up to two vehicles right next to the garden.
CALLER: That sounds ideal. How much is the total price for the week?
OFFICER: The standard rate is 650 pounds, but with our early booking discount, it comes to 580 pounds including all utilities.
CALLER: 580 pounds, excellent. What about kitchen facilities?
OFFICER: It comes fully equipped with a modern oven, microwave, and dishwasher.
CALLER: Wonderful. Can I secure this booking now?
OFFICER: Absolutely, I'll need a contact telephone number first.
CALLER: Sure, it's 07700 900342.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Customer Surname: [1]',
              correctAnswer: 'Miller',
              alternativeAnswers: ['miller'],
              explanation:
                  '• Từ khóa: surname, name\n• Phân tích bẫy: Người gọi đánh vần rõ từng chữ cái M-I-L-L-E-R.\n• Bằng chứng: "It\'s Miller. That\'s M-I-L-L-E-R."',
              audioTimestampSeconds: 15,
              transcriptEvidence: 'It\'s Miller. That\'s M-I-L-L-E-R.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Check-in date: 15th of [2]',
              correctAnswer: 'July',
              alternativeAnswers: ['july', '07'],
              explanation:
                  '• Từ khóa: check in, dates\n• Phân tích bẫy: Người gọi nói rõ "15th of July and stay for a week".\n• Bằng chứng: "We\'d like to check in on the 15th of July."',
              audioTimestampSeconds: 24,
              transcriptEvidence: 'We\'d like to check in on the 15th of July',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Total price with early discount: £[3]',
              correctAnswer: '580',
              alternativeAnswers: ['580 pounds'],
              explanation:
                  '• Từ khóa: total price, early discount\n• Phân tích bẫy: Người nghe dễ nhầm với giá gốc 650 pounds. Giá sau chiết khấu là 580.\n• Bằng chứng: "The standard rate is 650 pounds, but with our early booking discount, it comes to 580 pounds."',
              audioTimestampSeconds: 42,
              transcriptEvidence: 'comes to 580 pounds including all utilities',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Contact phone: [4]',
              correctAnswer: '07700 900342',
              alternativeAnswers: ['07700900342'],
              explanation:
                  '• Từ khóa: contact telephone number\n• Phân tích bẫy: Dãy số đọc liền, chú ý số 0 đọc là "oh" hoặc "zero".\n• Bằng chứng: "Sure, it\'s 07700 900342."',
              audioTimestampSeconds: 58,
              transcriptEvidence: 'Sure, it\'s 07700 900342.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: Greenwood Nature Park Tour',
          sectionInstruction: 'Choose the correct letter, A, B, or C.',
          fullTranscript: '''
GUIDE: Welcome everyone to Greenwood Nature Park! Before we begin our walking tour today, let me share a few key safety rules and highlights of our conservation project.
The park was originally established in 1985 by local volunteers. Although funding was cut in 2005, a major national lottery grant in 2012 revitalized the wetlands and woodland areas.
Today, we are home to more than 140 bird species. If you want to see the rare kingfisher, head straight to the Heron Hide. That's open all day, but early mornings around 7 AM give you the best chance of spotting one.
Please note that cycling is strictly prohibited on the wooden boardwalks to protect young children and strollers. However, you can freely ride bicycles along the perimeter gravel trails.
Finally, lunch is available at the Dragonfly Café until 3 PM. Remember, all food containers must be placed in recycling bins located outside. Enjoy your visit!
''',
          questions: [
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.multipleChoice,
              questionText: 'When did the park receive a major national lottery grant?',
              options: [
                'A. In 1985',
                'B. In 2005',
                'C. In 2012',
              ],
              correctAnswer: 'C',
              alternativeAnswers: ['C. In 2012', '2012'],
              explanation:
                  '• Từ khóa: national lottery grant\n• Phân tích bẫy: Năm 1985 là năm thành lập bởi tình nguyện viên, năm 2005 là bị cắt ngân sách. Năm 2012 mới nhận tài trợ từ xổ số quốc gia.\n• Bằng chứng: "...a major national lottery grant in 2012 revitalized the wetlands."',
              audioTimestampSeconds: 22,
              transcriptEvidence: 'a major national lottery grant in 2012 revitalized the wetlands',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.multipleChoice,
              questionText: 'Where are bicycles permitted within the park?',
              options: [
                'A. On the wooden boardwalks',
                'B. Along the perimeter gravel trails',
                'C. Anywhere inside the wetland reserve',
              ],
              correctAnswer: 'B',
              alternativeAnswers: ['B. Along the perimeter gravel trails', 'B'],
              explanation:
                  '• Từ khóa: bicycles, cycling\n• Phân tích bẫy: Cấm xe đạp trên cầu gỗ (boardwalks). Được phép đi trên đường sỏi bao quanh (perimeter gravel trails).\n• Bằng chứng: "However, you can freely ride bicycles along the perimeter gravel trails."',
              audioTimestampSeconds: 45,
              transcriptEvidence: 'you can freely ride bicycles along the perimeter gravel trails.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam20_test2',
      title: 'Cambridge 20 — Test 2',
      subtitle: 'Part 1 (Dịch vụ đón sân bay) & Part 2 (Tour kiến trúc cổ kính)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 16,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Airport Express Shuttle Booking',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
AGENT: Premier Airport Transfers, how can I help you?
CUSTOMER: Hello, I'd like to arrange an airport pick-up for my colleague arriving next Monday.
AGENT: Certainly. What is the passenger's full name?
CUSTOMER: His name is David Palmer. That's P-A-L-M-E-R.
AGENT: Got it. Which flight is he arriving on?
CUSTOMER: It's British Airways flight BA 482 arriving from Singapore.
AGENT: BA 482, scheduled arrival at 14:30. And what is his destination hotel?
CUSTOMER: He will be staying at the Grand Riverside Hotel on Victoria Street.
AGENT: Great. Does he require a standard sedan or an executive van for extra luggage?
CUSTOMER: A standard sedan is fine, he only has one suitcase and a briefcase.
AGENT: Excellent. The one-way fare will be 48 pounds. May I have your confirmation mobile number?
CUSTOMER: Yes, it is 07821 445901.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Passenger Surname: [1]',
              correctAnswer: 'Palmer',
              alternativeAnswers: ['palmer'],
              explanation:
                  '• Từ khóa: passenger surname, name\n• Phân tích: Người gọi đánh vần P-A-L-M-E-R.\n• Bằng chứng: "His name is David Palmer. That\'s P-A-L-M-E-R."',
              audioTimestampSeconds: 16,
              transcriptEvidence: 'His name is David Palmer. That\'s P-A-L-M-E-R.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Flight number: BA [2]',
              correctAnswer: '482',
              alternativeAnswers: ['BA482', 'BA 482'],
              explanation:
                  '• Từ khóa: flight arriving\n• Phân tích: Nghe rõ số hiệu chuyến bay BA 482.\n• Bằng chứng: "It\'s British Airways flight BA 482 arriving from Singapore."',
              audioTimestampSeconds: 26,
              transcriptEvidence: 'British Airways flight BA 482 arriving from Singapore.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Hotel Name: Grand [3] Hotel',
              correctAnswer: 'Riverside',
              alternativeAnswers: ['riverside'],
              explanation:
                  '• Từ khóa: destination hotel\n• Phân tích: Khách sạn tên là Grand Riverside.\n• Bằng chứng: "...staying at the Grand Riverside Hotel on Victoria Street."',
              audioTimestampSeconds: 40,
              transcriptEvidence: 'Grand Riverside Hotel on Victoria Street.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'One-way fare: £[4]',
              correctAnswer: '48',
              alternativeAnswers: ['48 pounds'],
              explanation:
                  '• Từ khóa: fare, price\n• Phân tích: Mức giá cước một chiều là 48 bảng.\n• Bằng chứng: "The one-way fare will be 48 pounds."',
              audioTimestampSeconds: 52,
              transcriptEvidence: 'The one-way fare will be 48 pounds.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: Historic Old Town Walking Tour',
          sectionInstruction: 'Choose the correct letter, A, B, or C.',
          fullTranscript: '''
GUIDE: Good afternoon everyone, welcome to the Old Town Heritage Trail!
The town walls behind me date back to the 14th century, though significant stone reinforcements were added in 1640 after the great flood.
As we walk down Cobblestone Lane, please be mindful of uneven pavers. Today the historic Guildhall is closed for a private civic reception, but we have special clearance to visit the ancient underground wine vaults.
Cameras with flash are strictly banned inside the vault to prevent deterioration of the historic murals.
We will reconvene at the Clock Tower plaza at 4:30 PM for complimentary hot tea and spiced gingerbread.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.multipleChoice,
              questionText: 'When were the stone wall reinforcements added?',
              options: [
                'A. In the 14th century',
                'B. In 1640',
                'C. After the great fire of 1705',
              ],
              correctAnswer: 'B',
              alternativeAnswers: ['B. In 1640', '1640'],
              explanation:
                  '• Từ khóa: stone reinforcements\n• Phân tích: Tường thành xây từ thế kỷ 14, nhưng gia cố đá được xây vào năm 1640.\n• Bằng chứng: "...stone reinforcements were added in 1640 after the great flood."',
              audioTimestampSeconds: 15,
              transcriptEvidence: 'stone reinforcements were added in 1640 after the great flood.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.multipleChoice,
              questionText: 'What is prohibited inside the underground wine vaults?',
              options: [
                'A. Audio recording devices',
                'B. Food and bottled water',
                'C. Cameras using flash',
              ],
              correctAnswer: 'C',
              alternativeAnswers: ['C. Cameras using flash', 'C'],
              explanation:
                  '• Từ khóa: prohibited, banned inside vault\n• Phân tích: Cấm dùng đèn flash máy ảnh để bảo vệ các bức bích họa cổ.\n• Bằng chứng: "Cameras with flash are strictly banned inside the vault."',
              audioTimestampSeconds: 38,
              transcriptEvidence: 'Cameras with flash are strictly banned inside the vault',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam20_test3',
      title: 'Cambridge 20 — Test 3',
      subtitle: 'Part 1 (Đăng ký CLB Nhiếp Ảnh) & Part 3 (Nghiên cứu rạn san hô)',
      bandTarget: 'Band 6.5 - 8.0',
      durationMinutes: 18,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: University Photography Club Membership',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
SECRETARY: Hi there! Interested in joining the campus Photography Society?
STUDENT: Yes! I bought a mirrorless camera recently and want to learn portrait and landscape techniques.
SECRETARY: Fantastic! Let me enroll you. First, what is your student ID number?
STUDENT: It's ST 92051.
SECRETARY: ST 92051. And your faculty?
STUDENT: Faculty of Architecture.
SECRETARY: Great, we do plenty of urban architecture field trips! Our weekly workshops meet every Thursday evening in Room 304 of the Arts Pavilion.
STUDENT: Thursday evenings work perfectly for me. How much is the term membership?
SECRETARY: It is 25 dollars per term, which includes unlimited darkroom chemicals and studio light access.
STUDENT: That is very affordable. Who is the faculty advisor in charge?
SECRETARY: Professor Henderson oversees all technical safety and equipment loans.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Student ID: ST [1]',
              correctAnswer: '92051',
              alternativeAnswers: ['ST92051'],
              explanation:
                  '• Từ khóa: student ID number\n• Phân tích: Dãy số sinh viên là 92051.\n• Bằng chứng: "It\'s ST 92051."',
              audioTimestampSeconds: 15,
              transcriptEvidence: 'It\'s ST 92051.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Weekly workshop day: [2] evening',
              correctAnswer: 'Thursday',
              alternativeAnswers: ['thursday'],
              explanation:
                  '• Từ khóa: weekly workshops meet\n• Phân tích: Lịch sinh hoạt là tối thứ Năm hàng tuần.\n• Bằng chứng: "...meet every Thursday evening in Room 304."',
              audioTimestampSeconds: 32,
              transcriptEvidence: 'meet every Thursday evening in Room 304',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Term membership fee: \$[3]',
              correctAnswer: '25',
              alternativeAnswers: ['25 dollars'],
              explanation:
                  '• Từ khóa: membership fee per term\n• Phân tích: Phí hội viên là 25 đô la một kỳ.\n• Bằng chứng: "It is 25 dollars per term..."',
              audioTimestampSeconds: 44,
              transcriptEvidence: 'It is 25 dollars per term',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Faculty Advisor: Professor [4]',
              correctAnswer: 'Henderson',
              alternativeAnswers: ['henderson'],
              explanation:
                  '• Từ khóa: faculty advisor\n• Phân tích: Giáo sư phụ trách là Henderson.\n• Bằng chứng: "Professor Henderson oversees all technical safety."',
              audioTimestampSeconds: 56,
              transcriptEvidence: 'Professor Henderson oversees all technical safety',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam20_test4',
      title: 'Cambridge 20 — Test 4',
      subtitle: 'Part 1 (Lớp học làm gốm thủ công) & Part 4 (Pin thế hệ mới)',
      bandTarget: 'Band 7.0 - 8.5',
      durationMinutes: 20,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Community Ceramic Workshop',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
INSTRUCTOR: Welcome to Clay Works Studio! Are you signing up for the weekend pottery course?
STUDENT: Yes, I'd like the beginner throwing and glazing class.
INSTRUCTOR: Wonderful. Let's confirm your registration. What is your full legal name?
STUDENT: Katherine Edwards. Katherine with a K.
INSTRUCTOR: Thanks Katherine. The next six-week session begins on Saturday, the 8th of October.
STUDENT: October 8th, noted. Do I need to bring my own clay and aprons?
INSTRUCTOR: No, all stoneware clay, glazes, and protective aprons are provided. You should simply bring a pair of old hand towels.
STUDENT: Got it, towels. Where is the studio parking located?
INSTRUCTOR: Behind the old bakery on Mill Lane. Parking is completely free for workshop participants.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Session Start Date: 8th of [1]',
              correctAnswer: 'October',
              alternativeAnswers: ['october', '10'],
              explanation:
                  '• Từ khóa: session begins, start date\n• Phân tích: Khóa học bắt đầu vào ngày 8 tháng 10.\n• Bằng chứng: "...begins on Saturday, the 8th of October."',
              audioTimestampSeconds: 20,
              transcriptEvidence: 'begins on Saturday, the 8th of October.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Item students must bring: hand [2]',
              correctAnswer: 'towels',
              alternativeAnswers: ['towel'],
              explanation:
                  '• Từ khóa: bring, items\n• Phân tích: Học viên chỉ cần tự mang khăn lau tay.\n• Bằng chứng: "You should simply bring a pair of old hand towels."',
              audioTimestampSeconds: 38,
              transcriptEvidence: 'bring a pair of old hand towels.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Parking location: Mill [3]',
              correctAnswer: 'Lane',
              alternativeAnswers: ['lane'],
              explanation:
                  '• Từ khóa: parking located\n• Phân tích: Bãi đỗ xe nằm ở Mill Lane.\n• Bằng chứng: "Behind the old bakery on Mill Lane."',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'Behind the old bakery on Mill Lane.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam19_test1',
      title: 'Cambridge 19 — Test 1',
      subtitle: 'Part 1 (Thẻ xe buýt thông minh) & Part 2 (Bảo tàng khoa học)',
      bandTarget: 'Band 5.5 - 7.0',
      durationMinutes: 16,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Metro Travel Pass Application',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
CLERK: City Transit Customer Service. How can I assist you with your smart card today?
APPLICANT: Hi, I've just relocated to Newcastle and need to get an annual commuter travel pass.
CLERK: Happy to help! May I take your street address first?
APPLICANT: It's 42 Highfield Crescent, postcode NE3 7BL.
CLERK: Highfield Crescent, NE3 7BL. And what type of discount category do you qualify for?
APPLICANT: I am a postgraduate student, so I qualify for the tertiary student concession.
CLERK: Perfect. The monthly unlimited bus and tram pass is 52 pounds with that concession.
APPLICANT: 52 pounds per month is great. How long does card issuance take?
CLERK: It will be dispatched by post within 3 working days. We can activate it automatically on the first Monday of next month.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Street Address: 42 Highfield [1]',
              correctAnswer: 'Crescent',
              alternativeAnswers: ['crescent'],
              explanation:
                  '• Từ khóa: street address\n• Phân tích: Tên đường là Highfield Crescent.\n• Bằng chứng: "It\'s 42 Highfield Crescent..."',
              audioTimestampSeconds: 18,
              transcriptEvidence: 'It\'s 42 Highfield Crescent, postcode NE3 7BL.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Applicant Status: [2] student',
              correctAnswer: 'postgraduate',
              alternativeAnswers: ['Postgraduate'],
              explanation:
                  '• Từ khóa: qualify, status\n• Phân tích: Người đăng ký là sinh viên sau đại học (postgraduate student).\n• Bằng chứng: "I am a postgraduate student..."',
              audioTimestampSeconds: 31,
              transcriptEvidence: 'I am a postgraduate student, so I qualify...',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Discounted monthly rate: £[3]',
              correctAnswer: '52',
              alternativeAnswers: ['52 pounds'],
              explanation:
                  '• Từ khóa: monthly pass, concession\n• Phân tích: Mức phí tháng ưu đãi là 52 bảng.\n• Bằng chứng: "...is 52 pounds with that concession."',
              audioTimestampSeconds: 43,
              transcriptEvidence: 'pass is 52 pounds with that concession.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam19_test2',
      title: 'Cambridge 19 — Test 2',
      subtitle: 'Part 1 (Đăng ký thành viên Gym) & Part 3 (Hội thảo năng lượng sạch)',
      bandTarget: 'Band 6.5 - 8.0',
      durationMinutes: 18,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Fitness Club Membership',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
RECEPTIONIST: Welcome to Apex Fitness Club! How can I assist you today?
MEMBER: Hi, I'd like to sign up for a gym membership. What options do you have?
RECEPTIONIST: We offer Gold, Silver, and Student tiers. Let's start with your details. Your full name, please?
MEMBER: Jessica Reynolds.
RECEPTIONIST: And what is your occupation, Jessica?
MEMBER: I work as a graphic designer.
RECEPTIONIST: Great. Which facility are you most keen on using?
MEMBER: Primarily the swimming pool and yoga classes.
RECEPTIONIST: Excellent. The Silver tier covers unlimited pool access and 5 studio classes a month for 45 dollars monthly.
MEMBER: Sounds good. What time does the pool open on weekends?
RECEPTIONIST: On Saturdays and Sundays, the pool opens early at 6:30 AM and closes at 9:00 PM.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Member Occupation: [1] designer',
              correctAnswer: 'graphic',
              alternativeAnswers: ['Graphic'],
              explanation:
                  '• Từ khóa: occupation, work as\n• Phân tích: Nghe rõ người đăng ký nói "I work as a graphic designer".\n• Bằng chứng: "I work as a graphic designer."',
              audioTimestampSeconds: 18,
              transcriptEvidence: 'I work as a graphic designer.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Silver tier monthly fee: \$[2]',
              correctAnswer: '45',
              alternativeAnswers: ['45 dollars'],
              explanation:
                  '• Từ khóa: monthly, Silver tier\n• Phân tích: Lắng nghe mức giá hàng tháng là 45 dollars.\n• Bằng chứng: "...for 45 dollars monthly."',
              audioTimestampSeconds: 32,
              transcriptEvidence: 'for 45 dollars monthly.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Weekend pool opens at [3] AM',
              correctAnswer: '6:30',
              alternativeAnswers: ['6.30', '6:30 AM'],
              explanation:
                  '• Từ khóa: weekend pool opens\n• Phân tích: Cuối tuần hồ bơi mở cửa từ 6:30 sáng.\n• Bằng chứng: "...pool opens early at 6:30 AM."',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'pool opens early at 6:30 AM and closes at 9:00 PM.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam19_test3',
      title: 'Cambridge 19 — Test 3',
      subtitle: 'Part 1 (Hợp đồng thuê nhà trọ) & Part 2 (Vườn sinh thái bách thảo)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 17,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Student Flat Tenancy Agreement',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
LANDLORD: Good morning, City Lettings Agency. Are you enquiring about the flat on Elmwood Road?
STUDENT: Yes, my friend and I saw the listing for the two-bedroom apartment.
LANDLORD: Excellent. First, what is your surname?
STUDENT: It is Sinclair. S-I-N-C-L-A-I-R.
LANDLORD: Thank you. The weekly rent is 220 pounds per tenant, including superfast broadband.
STUDENT: Does that include heating and water?
LANDLORD: Water is covered, but electricity and heating are billed separately every quarter.
STUDENT: Understandable. What about the security deposit?
LANDLORD: We require a refundable deposit of 600 pounds upon signing the lease.
STUDENT: Great, and when would the tenancy officially commence?
LANDLORD: From September 1st for a minimum contract of ten months.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Tenant Surname: [1]',
              correctAnswer: 'Sinclair',
              alternativeAnswers: ['sinclair'],
              explanation:
                  '• Từ khóa: surname\n• Phân tích: Người thuê đánh vần S-I-N-C-L-A-I-R.\n• Bằng chứng: "It is Sinclair. S-I-N-C-L-A-I-R."',
              audioTimestampSeconds: 15,
              transcriptEvidence: 'It is Sinclair. S-I-N-C-L-A-I-R.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Refundable deposit required: £[2]',
              correctAnswer: '600',
              alternativeAnswers: ['600 pounds'],
              explanation:
                  '• Từ khóa: refundable deposit\n• Phân tích: Tiền đặt cọc hoàn lại là 600 bảng.\n• Bằng chứng: "...refundable deposit of 600 pounds."',
              audioTimestampSeconds: 38,
              transcriptEvidence: 'refundable deposit of 600 pounds upon signing the lease.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Tenancy start date: September [3]',
              correctAnswer: '1st',
              alternativeAnswers: ['1', 'first'],
              explanation:
                  '• Từ khóa: tenancy commence, start date\n• Phân tích: Hợp đồng bắt đầu từ ngày 1 tháng 9.\n• Bằng chứng: "From September 1st for a minimum contract..."',
              audioTimestampSeconds: 50,
              transcriptEvidence: 'From September 1st for a minimum contract of ten months.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam19_test4',
      title: 'Cambridge 19 — Test 4',
      subtitle: 'Part 1 (Tình nguyện cứu hộ động vật) & Part 3 (Tâm lý học trí nhớ)',
      bandTarget: 'Band 7.0 - 8.5',
      durationMinutes: 20,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Animal Wildlife Shelter Volunteer',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
COORDINATOR: Welcome to Oakwood Wildlife Sanctuary. We are thrilled you want to volunteer with our rehabilitation team.
VOLUNTEER: I love animals and have previous experience fostering abandoned puppies and injured hedgehogs.
COORDINATOR: That is wonderful! Which volunteer department interests you most?
VOLUNTEER: I would love to work in the nursery section helping feed infant squirrels and foxes.
COORDINATOR: That requires special dedication. You must be available on Sundays from 8 AM to 1 PM.
VOLUNTEER: Sunday mornings are completely free for me.
COORDINATOR: Perfect. Before handling animals directly, you need to attend an induction course on safety hygiene next Tuesday.
VOLUNTEER: Noted. What clothing is mandatory?
COORDINATOR: Sturdy waterproof boots and thick denim trousers are required inside the enclosures.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Preferred volunteer department: [1] section',
              correctAnswer: 'nursery',
              alternativeAnswers: ['Nursery'],
              explanation:
                  '• Từ khóa: department interests\n• Phân tích: Tình nguyện viên muốn làm ở bộ phận chăm sóc sơ sinh (nursery section).\n• Bằng chứng: "...in the nursery section helping feed infant squirrels..."',
              audioTimestampSeconds: 22,
              transcriptEvidence: 'in the nursery section helping feed infant squirrels and foxes.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Available shift: [2] mornings',
              correctAnswer: 'Sunday',
              alternativeAnswers: ['sunday', 'Sundays'],
              explanation:
                  '• Từ khóa: available on\n• Phân tích: Ca làm việc vào các buổi sáng Chủ nhật.\n• Bằng chứng: "Sunday mornings are completely free for me."',
              audioTimestampSeconds: 36,
              transcriptEvidence: 'Sunday mornings are completely free for me.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Mandatory footwear: waterproof [3]',
              correctAnswer: 'boots',
              alternativeAnswers: ['boot'],
              explanation:
                  '• Từ khóa: mandatory clothing, footwear\n• Phân tích: Trang phục bắt buộc là ủng chống nước (waterproof boots).\n• Bằng chứng: "Sturdy waterproof boots and thick denim trousers..."',
              audioTimestampSeconds: 50,
              transcriptEvidence: 'Sturdy waterproof boots and thick denim trousers are required...',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam18_test1',
      title: 'Cambridge 18 — Test 1',
      subtitle: 'Part 1 (Khóa học nấu món Địa Trung Hải) & Part 2 (Bảo tàng hàng hải)',
      bandTarget: 'Band 5.0 - 6.5',
      durationMinutes: 15,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Weekend Cookery Masterclass',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
HOST: Hello and thank you for calling Culinary Heritage Academy!
CALLER: Hi, I'm enquiring about weekend cooking workshops for couples.
HOST: We have two popular series running this month: Artisan Bread Baking and Mediterranean Seafood.
CALLER: Mediterranean Seafood sounds mouth-watering! When does the workshop meet?
HOST: Every Saturday morning from 9:30 to 12:30.
CALLER: Three hours, perfect. Does the fee include ingredients and wine pairing?
HOST: Yes, all fresh seafood, herbs, and two glasses of paired organic wine are included for 75 pounds per person.
CALLER: 75 pounds, that is great value. What knife skill level is expected?
HOST: Complete beginners are welcome; our chef demonstrates all filleting techniques step by step.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Course theme: Mediterranean [1]',
              correctAnswer: 'Seafood',
              alternativeAnswers: ['seafood'],
              explanation:
                  '• Từ khóa: course theme\n• Phân tích: Khóa học là Mediterranean Seafood.\n• Bằng chứng: "Mediterranean Seafood sounds mouth-watering!"',
              audioTimestampSeconds: 18,
              transcriptEvidence: 'Mediterranean Seafood sounds mouth-watering!',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Session time: Saturday [2] to 12:30',
              correctAnswer: '9:30',
              alternativeAnswers: ['9.30'],
              explanation:
                  '• Từ khóa: workshop meet, time\n• Phân tích: Giờ học từ 9:30 đến 12:30.\n• Bằng chứng: "Every Saturday morning from 9:30 to 12:30."',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'Every Saturday morning from 9:30 to 12:30.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Cost per person: £[3]',
              correctAnswer: '75',
              alternativeAnswers: ['75 pounds'],
              explanation:
                  '• Từ khóa: included, per person\n• Phân tích: Chi phí là 75 bảng một người.\n• Bằng chứng: "...included for 75 pounds per person."',
              audioTimestampSeconds: 42,
              transcriptEvidence: 'included for 75 pounds per person.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam18_test2',
      title: 'Cambridge 18 — Test 2',
      subtitle: 'Part 1 (Thuê xe đạp công cộng) & Part 2 (Dự án làm sạch bờ biển)',
      bandTarget: 'Band 5.5 - 7.0',
      durationMinutes: 16,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: EcoBike City Rental Registration',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''
AGENT: EcoBike Helpdesk, how may I assist you with your bike hire today?
CUSTOMER: Hi, I'm visiting the city for a conference and want to rent a city cruiser bike.
AGENT: Excellent! You can pick up and drop off at any of our 35 docking stations. May I register your credit card details?
CUSTOMER: Sure. What is the daily rental rate?
AGENT: It is only 12 dollars per day for unlimited rides under 45 minutes each.
CUSTOMER: 12 dollars, that is super cheap. Is helmet rental included?
AGENT: Helmets are an extra 3 dollars, or you can bring your own certified bicycle helmet.
CUSTOMER: I will add the helmet. Where is the nearest docking station to the Central Railway Station?
AGENT: Station number 7 is located right outside the North Exit on Market Street.
''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Daily hire rate: \$[1]',
              correctAnswer: '12',
              alternativeAnswers: ['12 dollars'],
              explanation:
                  '• Từ khóa: daily rental rate\n• Phân tích: Mức giá thuê hàng ngày là 12 đô la.\n• Bằng chứng: "It is only 12 dollars per day..."',
              audioTimestampSeconds: 22,
              transcriptEvidence: 'It is only 12 dollars per day for unlimited rides...',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Extra fee for helmet: \$[2]',
              correctAnswer: '3',
              alternativeAnswers: ['3 dollars'],
              explanation:
                  '• Từ khóa: helmet extra fee\n• Phân tích: Phí thuê nón bảo hiểm thêm là 3 đô la.\n• Bằng chứng: "Helmets are an extra 3 dollars..."',
              audioTimestampSeconds: 34,
              transcriptEvidence: 'Helmets are an extra 3 dollars...',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Station 7 location: Market [3]',
              correctAnswer: 'Street',
              alternativeAnswers: ['street'],
              explanation:
                  '• Từ khóa: station located\n• Phân tích: Trạm số 7 nằm trên Market Street.\n• Bằng chứng: "...outside the North Exit on Market Street."',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'outside the North Exit on Market Street.',
            ),
          ],
        ),
      ],
    ),
  ];

  /// Dữ liệu luyện chép chính tả (Dictation)
  static const List<DictationExercise> dictationExercises = [
    // 1. IELTS Speaking - Robots & AI
    DictationExercise(
      id: 'dict_ielts_01',
      title: 'IELTS: Robots & Artificial Intelligence',
      bandLevel: 'Band 6.0 - 7.5',
      sourceTopic: 'Technology & Everyday Life',
      category: 'ielts_speaking',
      description: 'Bộ câu trả lời mẫu ghi điểm IELTS Speaking Part 1 & 2 về chủ đề Robots và AI.',
      durationMinutes: 7,
      sentences: [
        DictationSentence(
          sentenceNumber: 1,
          targetText: 'Are you interested in robots and automated technology?',
          hint: 'A__ y__ i_________ in r_____ a__ a________ t_________?',
          translationVi: 'Bạn có hứng thú với robot và công nghệ tự động hóa không?',
        ),
        DictationSentence(
          sentenceNumber: 2,
          targetText: 'I find humanoid robots absolutely fascinating because they can assist humans in dangerous tasks.',
          hint: 'I f___ h_______ r_____ a_________ f__________ b______ t___ c__ a_____ h_____ in d________ t____.',
          translationVi: 'Tôi thấy robot hình người cực kỳ cuốn hút vì chúng có thể hỗ trợ con người trong những nhiệm vụ nguy hiểm.',
        ),
        DictationSentence(
          sentenceNumber: 3,
          targetText: 'Robots have become increasingly common in manufacturing factories and modern surgical operations.',
          hint: 'R_____ h___ b_____ i___________ c_____ in m____________ f________ a__ m_____ s_______ o_________',
          translationVi: 'Robot ngày càng trở nên phổ biến trong các nhà máy sản xuất và các ca phẫu thuật hiện đại.',
        ),
        DictationSentence(
          sentenceNumber: 4,
          targetText: 'Some people worry that artificial intelligence might replace human workers in the creative industry.',
          hint: 'S___ p_____ w____ t___ a_________ i___________ m____ r______ h____ w______ in the c_______ i________.',
          translationVi: 'Một số người lo ngại rằng trí tuệ nhân tạo có thể thay thế người lao động trong ngành sáng tạo.',
        ),
        DictationSentence(
          sentenceNumber: 5,
          targetText: 'In the future, domestic robots will probably vacuum floors, cook meals, and look after elderly citizens.',
          hint: 'In the f_____, d_______ r_____ w___ p_______ v_____ f_____, c___ m____, a__ l___ a____ e______ c_______.',
          translationVi: 'Trong tương lai, robot gia đình có lẽ sẽ hút bụi sàn nhà, nấu ăn và chăm sóc người cao tuổi.',
        ),
        DictationSentence(
          sentenceNumber: 6,
          targetText: 'However, I believe robots can never truly experience human emotions like empathy or compassion.',
          hint: 'H______, I b______ r_____ c__ n____ t____ e_________ h____ e_______ l___ e______ or c_________',
          translationVi: 'Tuy nhiên, tôi tin rằng robot không bao giờ có thể thực sự trải nghiệm cảm xúc con người như sự thấu cảm hay lòng trắc ẩn.',
        ),
      ],
    ),

    // 2. IELTS Speaking - Travel & Journey
    DictationExercise(
      id: 'dict_ielts_02',
      title: 'IELTS: Memorable Journey & Travel',
      bandLevel: 'Band 5.5 - 7.0',
      sourceTopic: 'Travel & Personal Experience',
      category: 'ielts_speaking',
      description: 'Mô tả chuyến đi du lịch đáng nhớ, cảnh sắc thiên nhiên và bài học trải nghiệm.',
      durationMinutes: 8,
      sentences: [
        DictationSentence(
          sentenceNumber: 1,
          targetText: 'Last summer, I took an unforgettable road trip along the coastal highways.',
          hint: 'L___ s_____, I t___ an u____________ r___ t___ a____ the c______ h_______.',
          translationVi: 'Mùa hè năm ngoái, tôi đã có một chuyến phượt khó quên dọc theo những cung đường cao tốc ven biển.',
        ),
        DictationSentence(
          sentenceNumber: 2,
          targetText: 'The breathtaking scenery of turquoise ocean and towering cliffs left a lasting impression on me.',
          hint: 'The b____________ s______ of t________ o____ a__ t_______ c_____ l___ a l______ i_________ on m_.',
          translationVi: 'Khung cảnh ngoạn mục của đại dương ngọc bích và những vách đá sừng sững đã để lại ấn tượng sâu đậm trong tôi.',
        ),
        DictationSentence(
          sentenceNumber: 3,
          targetText: 'Traveling alone allows you to step outside your comfort zone and discover your hidden resilience.',
          hint: 'T________ a____ a_____ y__ to s___ o______ y___ c______ z___ a__ d_______ y___ h_____ r_________',
          translationVi: 'Du lịch một mình cho phép bạn bước ra khỏi vùng an toàn và khám phá sự kiên cường tiềm ẩn của bản thân.',
        ),
        DictationSentence(
          sentenceNumber: 4,
          targetText: 'I had the golden opportunity to taste authentic street delicacies prepared by welcoming locals.',
          hint: 'I h__ the g_____ o__________ to t____ a_________ s_____ d_________ p_______ by w________ l_____.',
          translationVi: 'Tôi đã có cơ hội vàng để thưởng thức những món ăn đường phố chính gốc do người dân địa phương hiếu khách chế biến.',
        ),
        DictationSentence(
          sentenceNumber: 5,
          targetText: 'Although the weather was occasionally unpredictable, the overall expedition was immensely rewarding.',
          hint: 'A_______ the w______ w__ o___________ u____________, the o______ e_________ w__ i_______ r________.',
          translationVi: 'Mặc dù thời tiết đôi khi thất thường khó đoán, toàn bộ chuyến thám hiểm vẫn vô cùng xứng đáng.',
        ),
        DictationSentence(
          sentenceNumber: 6,
          targetText: 'I would definitely recommend this scenic destination to anyone who appreciates untouched natural beauty.',
          hint: 'I w____ d_________ r________ t___ s_____ d__________ to a_____ w__ a___________ u________ n______ b_____',
          translationVi: 'Tôi chắc chắn sẽ giới thiệu điểm đến thơ mộng này cho bất kỳ ai yêu mến vẻ đẹp thiên nhiên hoang sơ.',
        ),
      ],
    ),

    // 3. TED-Ed - How Habits Rewire Your Brain
    DictationExercise(
      id: 'dict_ted_01',
      title: 'TED-Ed: How Habits Rewire the Brain',
      bandLevel: 'Band 6.5 - 8.0',
      sourceTopic: 'Neuroscience & Psychology',
      category: 'ted_ed',
      description: 'Khoa học hành vi: Cách bộ não thiết lập và củng cố các thói quen hàng ngày.',
      durationMinutes: 8,
      sentences: [
        DictationSentence(
          sentenceNumber: 1,
          targetText: 'Every single day, roughly forty percent of our daily actions are driven by subconscious habits.',
          hint: 'E____ s_____ d__, r______ f____ p______ of o__ d____ a______ a__ d_____ by s___________ h_____.',
          translationVi: 'Mỗi ngày, khoảng 40% các hành động thường nhật của chúng ta được dẫn dắt bởi thói quen tiềm thức.',
        ),
        DictationSentence(
          sentenceNumber: 2,
          targetText: 'When a routine becomes automatic, our brain conserves precious cognitive energy for complex decisions.',
          hint: 'W___ a r______ b______ a________, o__ b____ c________ p_______ c________ e_____ f__ c______ d________.',
          translationVi: 'Khi một thói quen trở nên tự động, não bộ sẽ bảo tồn nguồn năng lượng nhận thức quý giá cho các quyết định phức tạp.',
        ),
        DictationSentence(
          sentenceNumber: 3,
          targetText: 'The neurological habit loop consists of three distinct components: cue, routine, and reward.',
          hint: 'The n___________ h____ l___ c_______ of t____ d_______ c_________: c__, r______, a__ r_____.',
          translationVi: 'Vòng lặp thói quen thần kinh bao gồm 3 yếu tố riêng biệt: gợi ý, hành động và phần thưởng.',
        ),
        DictationSentence(
          sentenceNumber: 4,
          targetText: 'Neurons that fire together frequently strengthen their physical synaptic connections over time.',
          hint: 'N______ t___ f___ t_______ f_________ s_________ t____ p_______ s_______ c__________ over t___.',
          translationVi: 'Những tế bào thần kinh kích hoạt cùng nhau sẽ củng cố các kết nối khớp thần kinh vật lý qua thời gian.',
        ),
        DictationSentence(
          sentenceNumber: 5,
          targetText: 'To permanently break a detrimental habit, you must consciously identify its underlying emotional trigger.',
          hint: 'To p__________ b____ a d__________ h____, y__ m___ c__________ i_______ i__ u_________ e________ t______.',
          translationVi: 'Để từ bỏ vĩnh viễn một thói quen có hại, bạn phải chủ động nhận diện tác nhân kích hoạt cảm xúc tiềm ẩn của nó.',
        ),
        DictationSentence(
          sentenceNumber: 6,
          targetText: 'Small, consistent incremental changes accumulate into massive personal breakthroughs over time.',
          hint: 'S____, c_________ i__________ c______ a_________ i___ m______ p_______ b____________ over t___.',
          translationVi: 'Những thay đổi nhỏ nhưng đều đặn sẽ tích lũy thành những bước đột phá cá nhân vĩ đại theo năm tháng.',
        ),
      ],
    ),

    // 4. BBC 6 Minute English - The Culture of Coffee
    DictationExercise(
      id: 'dict_bbc_01',
      title: 'BBC: The Secrets of Great Coffee',
      bandLevel: 'Band 5.5 - 6.5',
      sourceTopic: 'Lifestyle & Global Culture',
      category: 'bbc_english',
      description: 'Tìm hiểu văn hóa cà phê toàn cầu, tác động của caffeine và quy trình rang xay.',
      durationMinutes: 7,
      sentences: [
        DictationSentence(
          sentenceNumber: 1,
          targetText: 'Millions of people across the globe cannot imagine starting their morning without a hot cup of coffee.',
          hint: 'M_______ of p_____ a_____ the g____ c_____ i______ s_______ t____ m______ w______ a h__ c__ of c_____.',
          translationVi: 'Hàng triệu người trên khắp địa cầu không thể tưởng tượng nổi việc bắt đầu buổi sáng mà thiếu tách cà phê nóng.',
        ),
        DictationSentence(
          sentenceNumber: 2,
          targetText: 'Caffeine works by temporarily blocking adenosine receptors in the central nervous system.',
          hint: 'C_______ w____ by t__________ b_______ a________ r________ in the c______ n______ s_____.',
          translationVi: 'Caffeine hoạt động bằng cách tạm thời ngăn chặn các thụ thể adenosine trong hệ thần kinh trung ương.',
        ),
        DictationSentence(
          sentenceNumber: 3,
          targetText: 'Specialty coffee shops now focus on sustainable farming practices and direct trade with growers.',
          hint: 'S________ c_____ s____ n__ f____ on s__________ f______ p________ a__ d_____ t____ w___ g______.',
          translationVi: 'Các quán cà phê đặc sản hiện tập trung vào canh tác bền vững và thương mại trực tiếp với nông dân.',
        ),
        DictationSentence(
          sentenceNumber: 4,
          targetText: 'The delicate aroma and acidic flavour depend heavily on the elevation where coffee cherries grow.',
          hint: 'The d_______ a____ a__ a_____ f______ d_____ h______ on the e________ w____ c_____ c______ g___.',
          translationVi: 'Hương thơm tinh tế và vị chua thanh phụ thuộc rất lớn vào độ cao nơi cây cà phê sinh trưởng.',
        ),
        DictationSentence(
          sentenceNumber: 5,
          targetText: 'Drinking moderate amounts of black coffee has been associated with various cardiovascular benefits.',
          hint: 'D_______ m_______ a______ of b____ c_____ h__ b___ a_________ w___ v______ c_____________ b_______.',
          translationVi: 'Uống một lượng cà phê đen vừa phải có liên quan đến nhiều lợi ích cho sức khỏe tim mạch.',
        ),
        DictationSentence(
          sentenceNumber: 6,
          targetText: 'Next time you sip an espresso, remember the meticulous craft required to roast those green beans.',
          hint: 'N___ t___ y__ s__ an e_______, r_______ the m_________ c____ r_______ to r____ t____ g____ b____.',
          translationVi: 'Lần tới khi nhâm nhi tách espresso, hãy nhớ đến sự tỉ mỉ cần thiết để rang những hạt cà phê xanh ấy.',
        ),
      ],
    ),

    // 5. Real Easy English - Ordering at a Coffee Shop
    DictationExercise(
      id: 'dict_easy_01',
      title: 'Giao Tiếp: Ordering at a Coffee Shop',
      bandLevel: 'Band 4.0 - 5.5',
      sourceTopic: 'Practical Daily Conversations',
      category: 'easy_english',
      description: 'Hội thoại giao tiếp thực tế hàng ngày: Cách gọi đồ uống, bánh ngọt và thanh toán.',
      durationMinutes: 6,
      sentences: [
        DictationSentence(
          sentenceNumber: 1,
          targetText: 'Good morning! Can I get a medium iced latte with oat milk, please?',
          hint: 'G___ m______! C__ I g__ a m_____ i___ l____ w___ o__ m___, p_____?',
          translationVi: 'Chào buổi sáng! Cho tôi gọi một ly latte đá cỡ vừa pha sữa yến mạch được không?',
        ),
        DictationSentence(
          sentenceNumber: 2,
          targetText: 'Would you like that for here or to take away with you today?',
          hint: 'W____ y__ l___ t___ f__ h___ or to t___ a___ w___ y__ t____?',
          translationVi: 'Bạn muốn dùng tại quán hay mang đi hôm nay ạ?',
        ),
        DictationSentence(
          sentenceNumber: 3,
          targetText: 'I would also like a warm chocolate chip cookie and a slice of banana bread.',
          hint: 'I w____ a___ l___ a w___ c________ c___ c_____ a__ a s____ of b_____ b____.',
          translationVi: 'Tôi cũng muốn thêm một chiếc bánh quy socola chip ấm và một lát bánh mì chuối.',
        ),
        DictationSentence(
          sentenceNumber: 4,
          targetText: 'Sure thing! That comes to six dollars and fifty cents altogether.',
          hint: 'S___ t____! T___ c____ to s__ d______ a__ f____ c____ a_________',
          translationVi: 'Dạ được ạ! Tổng cộng của bạn hết sáu đô la năm mươi xu.',
        ),
        DictationSentence(
          sentenceNumber: 5,
          targetText: 'Could I pay with contactless credit card on the payment terminal?',
          hint: 'C____ I p__ w___ c__________ c_____ c___ on the p______ t_______?',
          translationVi: 'Tôi có thể quẹt thẻ tín dụng không chạm trên máy thanh toán được không?',
        ),
        DictationSentence(
          sentenceNumber: 6,
          targetText: 'Of course! Please take a seat, and we will call your name when your order is ready.',
          hint: 'Of c_____! P_____ t___ a s___, a__ w_ w___ c___ y___ n___ w___ y___ o____ is r____.',
          translationVi: 'Tất nhiên rồi ạ! Xin mời bạn ngồi, chúng tôi sẽ gọi tên bạn khi đồ uống chuẩn bị xong.',
        ),
      ],
    ),

    // 6. TED Talk - The Secrets of Faster Language Learning
    DictationExercise(
      id: 'dict_ted_02',
      title: 'TED Talk: Faster Language Learning',
      bandLevel: 'Band 6.0 - 7.5',
      sourceTopic: 'Inspirational Wisdom',
      category: 'ted_ed',
      description: 'Phương pháp học ngôn ngữ tự nhiên từ những người thông thạo nhiều thứ tiếng.',
      durationMinutes: 7,
      sentences: [
        DictationSentence(
          sentenceNumber: 1,
          targetText: 'Polyglots are not born with a magical gene; they simply find enjoyable ways to practice every day.',
          hint: 'P________ a__ n__ b___ w___ a m______ g___; t___ s_____ f___ e________ w___ to p_______ e____ d__.',
          translationVi: 'Những người nói được nhiều thứ tiếng không sinh ra với gen kỳ diệu; họ chỉ tìm ra cách luyện tập thú vị mỗi ngày.',
        ),
        DictationSentence(
          sentenceNumber: 2,
          targetText: 'If you hate grammar textbooks, watch your favourite television series with bilingual subtitles instead.',
          hint: 'If y__ h___ g______ t________, w____ y___ f________ t_________ s_____ w___ b_________ s________ i______.',
          translationVi: 'Nếu bạn ghét sách ngữ pháp, hãy xem bộ phim truyền hình yêu thích với phụ đề song ngữ thay thế.',
        ),
        DictationSentence(
          sentenceNumber: 3,
          targetText: 'Language acquisition requires consistent exposure rather than exhausting weekend cramming sessions.',
          hint: 'L_______ a__________ r_______ c_________ e_______ r_____ t___ e_________ w______ c_______ s_______.',
          translationVi: 'Tiếp thu ngôn ngữ đòi hỏi sự tiếp xúc đều đặn hơn là những buổi nhồi nhét kiệt sức vào cuối tuần.',
        ),
        DictationSentence(
          sentenceNumber: 4,
          targetText: 'Embrace your pronunciation mistakes enthusiastically because each blunder is a stepping stone to fluency.',
          hint: 'E______ y___ p____________ m_______ e______________ b______ e___ b______ is a s_______ s____ to f______.',
          translationVi: 'Hãy đón nhận những lỗi phát âm một cách hào hứng vì mỗi sai lầm là một bước đệm tiến tới sự lưu loát.',
        ),
        DictationSentence(
          sentenceNumber: 5,
          targetText: 'Speaking aloud in private helps your facial muscles adapt to unfamiliar foreign vowels.',
          hint: 'S_______ a____ in p______ h____ y___ f_____ m______ a____ to u_________ f______ v_____.',
          translationVi: 'Tự nói to một mình giúp các cơ mặt của bạn thích nghi với những nguyên âm ngoại ngữ xa lạ.',
        ),
        DictationSentence(
          sentenceNumber: 6,
          targetText: 'Curiosity and genuine communication will always triumph over boring rote memorization.',
          hint: 'C________ a__ g______ c____________ w___ a_____ t______ over b______ r___ m___________',
          translationVi: 'Sự tò mò và giao tiếp chân thành sẽ luôn chiến thắng phương pháp học vẹt nhàm chán.',
        ),
      ],
    ),
  ];

  /// Dữ liệu luyện phân biệt âm IPA (Minimal Pairs)
  static const List<IpaMinimalPairCategory> ipaCategories = [
    // --- NGUYÊN ÂM (VOWELS) ---
    IpaMinimalPairCategory(
      id: 'bad-vs-bed',
      soundPairTitle: '/æ/ – /e/',
      wordPairLabel: 'bad / bed',
      soundType: IpaSoundType.vowel,
      description: 'Âm /æ/ hạ hàm rộng sang hai bên, âm /e/ mở miệng vừa phải, dứt khoát.',
      questions: [
        IpaQuestion(
          id: 'ae_e_q1',
          wordA: 'bad',
          ipaA: '/bæd/',
          meaningA: 'xấu / tồi tệ',
          wordB: 'bed',
          ipaB: '/bed/',
          meaningB: 'giường ngủ',
          targetWord: 'bed',
          exampleSentence: 'She went straight to bed after a long working day.',
        ),
        IpaQuestion(
          id: 'ae_e_q2',
          wordA: 'and',
          ipaA: '/ænd/',
          meaningA: 'và (liên từ)',
          wordB: 'end',
          ipaB: '/end/',
          meaningB: 'kết thúc',
          targetWord: 'end',
          exampleSentence: 'This is not the end of our journey.',
        ),
        IpaQuestion(
          id: 'ae_e_q3',
          wordA: 'jam',
          ipaA: '/dʒæm/',
          meaningA: 'mứt hoa quả / tắc nghẽn',
          wordB: 'gem',
          ipaB: '/dʒem/',
          meaningB: 'viên ngọc quý',
          targetWord: 'jam',
          exampleSentence: 'We got stuck in a huge traffic jam this morning.',
        ),
        IpaQuestion(
          id: 'ae_e_q4',
          wordA: 'pan',
          ipaA: '/pæn/',
          meaningA: 'chảo rán',
          wordB: 'pen',
          ipaB: '/pen/',
          meaningB: 'bút viết',
          targetWord: 'pen',
          exampleSentence: 'Could you lend me your pen for a moment?',
        ),
        IpaQuestion(
          id: 'ae_e_q5',
          wordA: 'sad',
          ipaA: '/sæd/',
          meaningA: 'buồn bã',
          wordB: 'said',
          ipaB: '/sed/',
          meaningB: 'đã nói',
          targetWord: 'sad',
          exampleSentence: 'He looked really sad after receiving the test results.',
        ),
        IpaQuestion(
          id: 'ae_e_q6',
          wordA: 'land',
          ipaA: '/lænd/',
          meaningA: 'vùng đất / hạ cánh',
          wordB: 'lend',
          ipaB: '/lend/',
          meaningB: 'cho vay, cho mượn',
          targetWord: 'land',
          exampleSentence: 'The airplane will land in fifteen minutes.',
        ),
        IpaQuestion(
          id: 'ae_e_q7',
          wordA: 'mat',
          ipaA: '/mæt/',
          meaningA: 'thảm lau chân',
          wordB: 'met',
          ipaB: '/met/',
          meaningB: 'đã gặp gỡ',
          targetWord: 'met',
          exampleSentence: 'We first met at university five years ago.',
        ),
        IpaQuestion(
          id: 'ae_e_q8',
          wordA: 'man',
          ipaA: '/mæn/',
          meaningA: 'người đàn ông (số ít)',
          wordB: 'men',
          ipaB: '/men/',
          meaningB: 'những người đàn ông (số nhiều)',
          targetWord: 'men',
          exampleSentence: 'Three men entered the conference hall.',
        ),
        IpaQuestion(
          id: 'ae_e_q9',
          wordA: 'gas',
          ipaA: '/ɡæs/',
          meaningA: 'khí đốt / xăng xe',
          wordB: 'guess',
          ipaB: '/ɡes/',
          meaningB: 'đoán xem',
          targetWord: 'guess',
          exampleSentence: 'Can you guess what happened next?',
        ),
        IpaQuestion(
          id: 'ae_e_q10',
          wordA: 'fad',
          ipaA: '/fæd/',
          meaningA: 'mốt nhất thời',
          wordB: 'fed',
          ipaB: '/fed/',
          meaningB: 'đã cho ăn',
          targetWord: 'fed',
          exampleSentence: 'The mother fed her baby some warm milk.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'had-vs-hard',
      soundPairTitle: '/æ/ – /ɑː/',
      wordPairLabel: 'had / hard',
      soundType: IpaSoundType.vowel,
      description: 'Âm /æ/ ngắn và dẹt môi; âm /ɑː/ kéo dài sâu trong vòm họng.',
      questions: [
        IpaQuestion(
          id: 'ae_ar_q1',
          wordA: 'had',
          ipaA: '/hæd/',
          meaningA: 'đã có',
          wordB: 'hard',
          ipaB: '/hɑːd/',
          meaningB: 'chăm chỉ / khó khăn',
          targetWord: 'hard',
          exampleSentence: 'She works very hard to achieve high IELTS scores.',
        ),
        IpaQuestion(
          id: 'ae_ar_q2',
          wordA: 'cat',
          ipaA: '/kæt/',
          meaningA: 'con mèo',
          wordB: 'cart',
          ipaB: '/kɑːt/',
          meaningB: 'xe đẩy hàng',
          targetWord: 'cat',
          exampleSentence: 'A little cat was sleeping quietly under the table.',
        ),
        IpaQuestion(
          id: 'ae_ar_q3',
          wordA: 'back',
          ipaA: '/bæk/',
          meaningA: 'phía sau / lưng',
          wordB: 'bark',
          ipaB: '/bɑːk/',
          meaningB: 'tiếng sủa / vỏ cây',
          targetWord: 'bark',
          exampleSentence: 'The dogs began to bark loudly at night.',
        ),
        IpaQuestion(
          id: 'ae_ar_q4',
          wordA: 'hat',
          ipaA: '/hæt/',
          meaningA: 'chiếc mũ',
          wordB: 'heart',
          ipaB: '/hɑːt/',
          meaningB: 'trái tim',
          targetWord: 'heart',
          exampleSentence: 'Regular exercise keeps your heart healthy.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'it-vs-eat',
      soundPairTitle: '/ɪ/ – /iː/',
      wordPairLabel: 'it / eat',
      soundType: IpaSoundType.vowel,
      description: 'Âm /ɪ/ ngắn và thả lỏng cơ miệng; âm /iː/ căng khóe miệng như đang cười.',
      questions: [
        IpaQuestion(
          id: 'i_ii_q1',
          wordA: 'it',
          ipaA: '/ɪt/',
          meaningA: 'nó (đại từ)',
          wordB: 'eat',
          ipaB: '/iːt/',
          meaningB: 'ăn uống',
          targetWord: 'eat',
          exampleSentence: 'We usually eat dinner together at seven.',
        ),
        IpaQuestion(
          id: 'i_ii_q2',
          wordA: 'ship',
          ipaA: '/ʃɪp/',
          meaningA: 'con tàu thủy',
          wordB: 'sheep',
          ipaB: '/ʃiːp/',
          meaningB: 'con cừu',
          targetWord: 'sheep',
          exampleSentence: 'A flock of white sheep is grazing on the hill.',
        ),
        IpaQuestion(
          id: 'i_ii_q3',
          wordA: 'hit',
          ipaA: '/hɪt/',
          meaningA: 'đánh / đâm trúng',
          wordB: 'heat',
          ipaB: '/hiːt/',
          meaningB: 'nhiệt độ / sức nóng',
          targetWord: 'hit',
          exampleSentence: 'The tennis player hit the ball with great power.',
        ),
        IpaQuestion(
          id: 'i_ii_q4',
          wordA: 'live',
          ipaA: '/lɪv/',
          meaningA: 'sinh sống',
          wordB: 'leave',
          ipaB: '/liːv/',
          meaningB: 'rời đi / để lại',
          targetWord: 'live',
          exampleSentence: 'Where do you live in Vietnam?',
        ),
        IpaQuestion(
          id: 'i_ii_q5',
          wordA: 'fit',
          ipaA: '/fɪt/',
          meaningA: 'vừa vặn / khỏe khoắn',
          wordB: 'feet',
          ipaB: '/fiːt/',
          meaningB: 'bàn chân (số nhiều)',
          targetWord: 'feet',
          exampleSentence: 'Her feet were cold after walking in the snow.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'bet-vs-bit',
      soundPairTitle: '/e/ – /ɪ/',
      wordPairLabel: 'bet / bit',
      soundType: IpaSoundType.vowel,
      description: 'Âm /e/ mở rộng miệng vừa phải; âm /ɪ/ nâng lưỡi cao hơn và dứt khoát.',
      questions: [
        IpaQuestion(
          id: 'e_i_q1',
          wordA: 'bet',
          ipaA: '/bet/',
          meaningA: 'cá cược / chắc chắn',
          wordB: 'bit',
          ipaB: '/bɪt/',
          meaningB: 'một chút',
          targetWord: 'bit',
          exampleSentence: 'Can you wait a little bit longer?',
        ),
        IpaQuestion(
          id: 'e_i_q2',
          wordA: 'desk',
          ipaA: '/desk/',
          meaningA: 'bàn làm việc',
          wordB: 'disk',
          ipaB: '/dɪsk/',
          meaningB: 'ổ đĩa / đĩa tròn',
          targetWord: 'desk',
          exampleSentence: 'He placed the laptop on the wooden desk.',
        ),
        IpaQuestion(
          id: 'e_i_q3',
          wordA: 'pen',
          ipaA: '/pen/',
          meaningA: 'bút viết',
          wordB: 'pin',
          ipaB: '/pɪn/',
          meaningB: 'ghim kẹp',
          targetWord: 'pen',
          exampleSentence: 'Sign the registration form with a black pen.',
        ),
        IpaQuestion(
          id: 'e_i_q4',
          wordA: 'set',
          ipaA: '/set/',
          meaningA: 'bộ / thiết lập',
          wordB: 'sit',
          ipaB: '/sɪt/',
          meaningB: 'ngồi xuống',
          targetWord: 'sit',
          exampleSentence: 'Please sit down and make yourself comfortable.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'pull-vs-pool',
      soundPairTitle: '/ʊ/ – /uː/',
      wordPairLabel: 'pull / pool',
      soundType: IpaSoundType.vowel,
      description: 'Âm /ʊ/ tròn môi ngắn thả lỏng; âm /uː/ chu môi tròn hẹp kéo dài.',
      questions: [
        IpaQuestion(
          id: 'u_uu_q1',
          wordA: 'pull',
          ipaA: '/pʊl/',
          meaningA: 'kéo vào',
          wordB: 'pool',
          ipaB: '/puːl/',
          meaningB: 'bể bơi / vũng nước',
          targetWord: 'pool',
          exampleSentence: 'The children are swimming in the outdoor pool.',
        ),
        IpaQuestion(
          id: 'u_uu_q2',
          wordA: 'full',
          ipaA: '/fʊl/',
          meaningA: 'đầy đủ / no nê',
          wordB: 'fool',
          ipaB: '/fuːl/',
          meaningB: 'kẻ ngốc / đánh lừa',
          targetWord: 'full',
          exampleSentence: 'The hotel is full of tourists during summer.',
        ),
        IpaQuestion(
          id: 'u_uu_q3',
          wordA: 'look',
          ipaA: '/lʊk/',
          meaningA: 'nhìn ngắm',
          wordB: 'Luke',
          ipaB: '/luːk/',
          meaningB: 'tên riêng Luke',
          targetWord: 'look',
          exampleSentence: 'Look at that beautiful sunset over the river.',
        ),
      ],
    ),

    // --- PHỤ ÂM (CONSONANTS) ---
    IpaMinimalPairCategory(
      id: 'big-vs-pig',
      soundPairTitle: '/b/ – /p/',
      wordPairLabel: 'big / pig',
      soundType: IpaSoundType.consonant,
      description: 'Âm /b/ rung thanh quản (hữu thanh); âm /p/ bật hơi mạnh không rung (vô thanh).',
      questions: [
        IpaQuestion(
          id: 'b_p_q1',
          wordA: 'big',
          ipaA: '/bɪɡ/',
          meaningA: 'to lớn',
          wordB: 'pig',
          ipaB: '/pɪɡ/',
          meaningB: 'con heo',
          targetWord: 'big',
          exampleSentence: 'They live in a very big house downtown.',
        ),
        IpaQuestion(
          id: 'b_p_q2',
          wordA: 'bat',
          ipaA: '/bæt/',
          meaningA: 'con dơi / gậy bóng chày',
          wordB: 'pat',
          ipaB: '/pæt/',
          meaningB: 'vỗ nhẹ',
          targetWord: 'pat',
          exampleSentence: 'He gave the dog a friendly pat on the head.',
        ),
        IpaQuestion(
          id: 'b_p_q3',
          wordA: 'bear',
          ipaA: '/beə(r)/',
          meaningA: 'con gấu',
          wordB: 'pear',
          ipaB: '/peə(r)/',
          meaningB: 'quả lê',
          targetWord: 'pear',
          exampleSentence: 'She sliced a fresh pear for breakfast.',
        ),
        IpaQuestion(
          id: 'b_p_q4',
          wordA: 'back',
          ipaA: '/bæk/',
          meaningA: 'phía sau',
          wordB: 'pack',
          ipaB: '/pæk/',
          meaningB: 'đóng gói đồ đạc',
          targetWord: 'pack',
          exampleSentence: 'I need to pack my suitcase for the flight tomorrow.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'ban-vs-van',
      soundPairTitle: '/b/ – /v/',
      wordPairLabel: 'ban / van',
      soundType: IpaSoundType.consonant,
      description: 'Âm /b/ khép hai môi bật ra; âm /v/ chạm răng cửa hàm trên vào môi dưới.',
      questions: [
        IpaQuestion(
          id: 'b_v_q1',
          wordA: 'ban',
          ipaA: '/bæn/',
          meaningA: 'cấm đoán',
          wordB: 'van',
          ipaB: '/væn/',
          meaningB: 'xe tải nhỏ',
          targetWord: 'van',
          exampleSentence: 'A white delivery van is parked in front of the gate.',
        ),
        IpaQuestion(
          id: 'b_v_q2',
          wordA: 'berry',
          ipaA: '/ˈberi/',
          meaningA: 'quả mọng',
          wordB: 'very',
          ipaB: '/ˈveri/',
          meaningB: 'rất nhiều',
          targetWord: 'very',
          exampleSentence: 'She was very pleased with the examination score.',
        ),
        IpaQuestion(
          id: 'b_v_q3',
          wordA: 'best',
          ipaA: '/best/',
          meaningA: 'tốt nhất',
          wordB: 'vest',
          ipaB: '/vest/',
          meaningB: 'áo gi-lê / áo lót',
          targetWord: 'best',
          exampleSentence: 'We always strive to provide the best service.',
        ),
        IpaQuestion(
          id: 'b_v_q4',
          wordA: 'boat',
          ipaA: '/bəʊt/',
          meaningA: 'chiếc thuyền',
          wordB: 'vote',
          ipaB: '/vəʊt/',
          meaningB: 'bỏ phiếu bầu',
          targetWord: 'vote',
          exampleSentence: 'Citizens have the democratic right to vote.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'cheap-vs-sheep',
      soundPairTitle: '/tʃ/ – /ʃ/',
      wordPairLabel: 'cheap / sheep',
      soundType: IpaSoundType.consonant,
      description: 'Âm /tʃ/ chặn luồng khí rồi bật mạnh; âm /ʃ/ thổi luồng khí xì nhẹ liên tục.',
      questions: [
        IpaQuestion(
          id: 'ch_sh_q1',
          wordA: 'cheap',
          ipaA: '/tʃiːp/',
          meaningA: 'giá rẻ',
          wordB: 'sheep',
          ipaB: '/ʃiːp/',
          meaningB: 'con cừu',
          targetWord: 'cheap',
          exampleSentence: 'The flight tickets were surprisingly cheap.',
        ),
        IpaQuestion(
          id: 'ch_sh_q2',
          wordA: 'chair',
          ipaA: '/tʃeə(r)/',
          meaningA: 'chiếc ghế',
          wordB: 'share',
          ipaB: '/ʃeə(r)/',
          meaningB: 'chia sẻ',
          targetWord: 'chair',
          exampleSentence: 'Please take a chair and sit down.',
        ),
        IpaQuestion(
          id: 'ch_sh_q3',
          wordA: 'chin',
          ipaA: '/tʃɪn/',
          meaningA: 'chiếc cằm',
          wordB: 'shin',
          ipaB: '/ʃɪn/',
          meaningB: 'cẳng chân',
          targetWord: 'chin',
          exampleSentence: 'He stroked his chin thoughtfully during the meeting.',
        ),
        IpaQuestion(
          id: 'ch_sh_q4',
          wordA: 'choose',
          ipaA: '/tʃuːz/',
          meaningA: 'lựa chọn',
          wordB: 'shoes',
          ipaB: '/ʃuːz/',
          meaningB: 'đôi giày',
          targetWord: 'shoes',
          exampleSentence: 'Take off your dirty shoes before entering.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'think-vs-sink',
      soundPairTitle: '/θ/ – /s/',
      wordPairLabel: 'think / sink',
      soundType: IpaSoundType.consonant,
      description: 'Âm /θ/ đặt đầu lưỡi giữa 2 hàm răng thổi gió; âm /s/ khép răng xì hơi.',
      questions: [
        IpaQuestion(
          id: 'th_s_q1',
          wordA: 'think',
          ipaA: '/θɪŋk/',
          meaningA: 'suy nghĩ',
          wordB: 'sink',
          ipaB: '/sɪŋk/',
          meaningB: 'bồn rửa / chìm',
          targetWord: 'think',
          exampleSentence: 'I think that this solution is the most effective.',
        ),
        IpaQuestion(
          id: 'th_s_q2',
          wordA: 'thick',
          ipaA: '/θɪk/',
          meaningA: 'dày cộm',
          wordB: 'sick',
          ipaB: '/sɪk/',
          meaningB: 'ốm đau',
          targetWord: 'thick',
          exampleSentence: 'The professor handed out a thick textbook.',
        ),
        IpaQuestion(
          id: 'th_s_q3',
          wordA: 'thank',
          ipaA: '/θæŋk/',
          meaningA: 'cảm ơn',
          wordB: 'sank',
          ipaB: '/sæŋk/',
          meaningB: 'đã chìm xuống',
          targetWord: 'thank',
          exampleSentence: 'I want to thank everyone for their support.',
        ),
        IpaQuestion(
          id: 'th_s_q4',
          wordA: 'theme',
          ipaA: '/θiːm/',
          meaningA: 'chủ đề bài học',
          wordB: 'seem',
          ipaB: '/siːm/',
          meaningB: 'dường như',
          targetWord: 'theme',
          exampleSentence: 'The central theme of the novel is forgiveness.',
        ),
      ],
    ),
    IpaMinimalPairCategory(
      id: 'light-vs-right',
      soundPairTitle: '/l/ – /r/',
      wordPairLabel: 'light / right',
      soundType: IpaSoundType.consonant,
      description: 'Âm /l/ đầu lưỡi chạm lợi răng trên; âm /r/ uốn đầu lưỡi về sau không chạm lợi.',
      questions: [
        IpaQuestion(
          id: 'l_r_q1',
          wordA: 'light',
          ipaA: '/laɪt/',
          meaningA: 'ánh sáng / nhẹ nhàng',
          wordB: 'right',
          ipaB: '/raɪt/',
          meaningB: 'bên phải / đúng đắn',
          targetWord: 'right',
          exampleSentence: 'Turn right at the traffic lights.',
        ),
        IpaQuestion(
          id: 'l_r_q2',
          wordA: 'lead',
          ipaA: '/liːd/',
          meaningA: 'dẫn dắt',
          wordB: 'read',
          ipaB: '/riːd/',
          meaningB: 'đọc sách',
          targetWord: 'read',
          exampleSentence: 'She loves to read novels before sleeping.',
        ),
        IpaQuestion(
          id: 'l_r_q3',
          wordA: 'lock',
          ipaA: '/lɒk/',
          meaningA: 'khóa cửa',
          wordB: 'rock',
          ipaB: '/rɒk/',
          meaningB: 'tảng đá / nhạc rock',
          targetWord: 'lock',
          exampleSentence: 'Remember to lock the front door when leaving.',
        ),
        IpaQuestion(
          id: 'l_r_q4',
          wordA: 'long',
          ipaA: '/lɒŋ/',
          meaningA: 'dài lâu',
          wordB: 'wrong',
          ipaB: '/rɒŋ/',
          meaningB: 'sai lầm',
          targetWord: 'long',
          exampleSentence: 'It was a long journey across the mountains.',
        ),
      ],
    ),
  ];

  /// Danh sách kho lưu trữ thư viện (Library Archives) theo phong cách The IELTS Dictionary
  static const List<ArchiveGroup> libraryArchiveGroups = [
    // 1. CAMBRIDGE 20
    ArchiveGroup(
      id: 'arch_cam20',
      title: 'CAMBRIDGE 20',
      badgeText: '4 Tests Listening',
      tagNumber: '20',
      tagBgColor: Color(0xFFEFF6FF),
      tagTextColor: Color(0xFF2563EB),
      isActive: true,
      category: ArchiveCategoryType.cambridge,
      subSections: [
        ArchiveSubSection(
          subTitle: 'TEST 1',
          lessons: [
            ArchiveLessonItem(
              id: 'c20_t1_p1',
              lessonName: 'Part 1',
              topicDescription: 'Holiday Accommodation Enquiry',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 1,
              dictationId: 'dict_01',
            ),
            ArchiveLessonItem(
              id: 'c20_t1_p2',
              lessonName: 'Part 2',
              topicDescription: 'Greenfield Community Sports Complex',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 2,
            ),
            ArchiveLessonItem(
              id: 'c20_t1_p3',
              lessonName: 'Part 3',
              topicDescription: 'Renewable Energy Research Project',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 3,
            ),
            ArchiveLessonItem(
              id: 'c20_t1_p4',
              lessonName: 'Part 4',
              topicDescription: 'The Impact of Microplastics on Marine Life',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 4,
            ),
          ],
        ),
        ArchiveSubSection(
          subTitle: 'TEST 2',
          lessons: [
            ArchiveLessonItem(
              id: 'c20_t2_p1',
              lessonName: 'Part 1',
              topicDescription: 'Joining a Local Photography Club',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 1,
              dictationId: 'dict_02',
            ),
            ArchiveLessonItem(
              id: 'c20_t2_p2',
              lessonName: 'Part 2',
              topicDescription: 'Visitor Information for Heritage Railway',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 2,
            ),
            ArchiveLessonItem(
              id: 'c20_t2_p3',
              lessonName: 'Part 3',
              topicDescription: 'Urban Architecture and Public Spaces',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 3,
            ),
            ArchiveLessonItem(
              id: 'c20_t2_p4',
              lessonName: 'Part 4',
              topicDescription: 'Evolutionary History of Honeybees',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 4,
            ),
          ],
        ),
        ArchiveSubSection(
          subTitle: 'TEST 3',
          lessons: [
            ArchiveLessonItem(
              id: 'c20_t3_p1',
              lessonName: 'Part 1',
              topicDescription: 'Apartment Rental & Tenancy Agreement',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 1,
              dictationId: 'dict_01',
            ),
            ArchiveLessonItem(
              id: 'c20_t3_p2',
              lessonName: 'Part 2',
              topicDescription: 'Volunteering in National Parks',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 2,
            ),
            ArchiveLessonItem(
              id: 'c20_t3_p3',
              lessonName: 'Part 3',
              topicDescription: 'Psychology of Consumer Behavior in Retail',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 3,
            ),
            ArchiveLessonItem(
              id: 'c20_t3_p4',
              lessonName: 'Part 4',
              topicDescription: 'Ancient Shipbuilding Techniques in the Mediterranean',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 4,
            ),
          ],
        ),
        ArchiveSubSection(
          subTitle: 'TEST 4',
          lessons: [
            ArchiveLessonItem(
              id: 'c20_t4_p1',
              lessonName: 'Part 1',
              topicDescription: 'Booking Tickets for an International Jazz Festival',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 1,
              dictationId: 'dict_02',
            ),
            ArchiveLessonItem(
              id: 'c20_t4_p2',
              lessonName: 'Part 2',
              topicDescription: 'Guide to Cycling Trails and Safety',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 2,
            ),
            ArchiveLessonItem(
              id: 'c20_t4_p3',
              lessonName: 'Part 3',
              topicDescription: 'Reviewing an Environmental Science Dissertation',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 3,
            ),
            ArchiveLessonItem(
              id: 'c20_t4_p4',
              lessonName: 'Part 4',
              topicDescription: 'Deep-sea Exploration and Submersible Robotics',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 4,
            ),
          ],
        ),
      ],
    ),

    // 2. CAMBRIDGE 19
    ArchiveGroup(
      id: 'arch_cam19',
      title: 'CAMBRIDGE 19',
      badgeText: '4 Tests Listening',
      tagNumber: '19',
      tagBgColor: Color(0xFFEFF6FF),
      tagTextColor: Color(0xFF2563EB),
      isActive: true,
      category: ArchiveCategoryType.cambridge,
      subSections: [
        ArchiveSubSection(
          subTitle: 'TEST 1',
          lessons: [
            ArchiveLessonItem(
              id: 'c19_t1_p1',
              lessonName: 'Part 1',
              topicDescription: 'Inquiry About Sailing Lessons',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 1,
              dictationId: 'dict_01',
            ),
            ArchiveLessonItem(
              id: 'c19_t1_p2',
              lessonName: 'Part 2',
              topicDescription: 'City Farm & Garden Volunteer Program',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 2,
            ),
            ArchiveLessonItem(
              id: 'c19_t1_p3',
              lessonName: 'Part 3',
              topicDescription: 'Student Presentation on Ancient Roman Roads',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 3,
            ),
            ArchiveLessonItem(
              id: 'c19_t1_p4',
              lessonName: 'Part 4',
              topicDescription: 'The Science of Sleep and Memory Consolidation',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 4,
            ),
          ],
        ),
        ArchiveSubSection(
          subTitle: 'TEST 2',
          lessons: [
            ArchiveLessonItem(
              id: 'c19_t2_p1',
              lessonName: 'Part 1',
              topicDescription: 'Hotel Reservation & Airport Shuttle',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 1,
              dictationId: 'dict_02',
            ),
            ArchiveLessonItem(
              id: 'c19_t2_p2',
              lessonName: 'Part 2',
              topicDescription: 'Local Art Gallery Renovation Tour',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 2,
            ),
            ArchiveLessonItem(
              id: 'c19_t2_p3',
              lessonName: 'Part 3',
              topicDescription: 'Academic Presentation Feedback Session',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 3,
            ),
            ArchiveLessonItem(
              id: 'c19_t2_p4',
              lessonName: 'Part 4',
              topicDescription: 'History and Preservation of Ancient Manuscripts',
              questionCount: 10,
              testId: 'cam19_test2',
              partNumber: 4,
            ),
          ],
        ),
      ],
    ),

    // 3. SPELLING
    ArchiveGroup(
      id: 'arch_spelling',
      title: 'SPELLING',
      badgeText: '3 Bài Luyện Tập',
      tagNumber: 'A-Z',
      tagBgColor: Color(0xFFFDF2F8),
      tagTextColor: Color(0xFFDB2777),
      category: ArchiveCategoryType.spelling,
      subSections: [
        ArchiveSubSection(
          subTitle: 'ĐÁNH VẦN TÊN & ĐỊA DANH',
          lessons: [
            ArchiveLessonItem(
              id: 'spell_names',
              lessonName: 'English First & Last Names',
              topicDescription: 'Luyện nghe đánh vần tên người Anh-Mỹ (Miller, Thompson, Campbell...)',
              questionCount: 10,
              dictationId: 'dict_01',
              testId: 'cam20_test1',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'spell_streets',
              lessonName: 'UK Street Names & Postal Codes',
              topicDescription: 'Luyện nghe tên đường phố và mã bưu điện Anh quốc (SW1A 1AA, Oxford St...)',
              questionCount: 10,
              dictationId: 'dict_01',
              testId: 'cam20_test1',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'spell_cities',
              lessonName: 'International Cities & Flight Codes',
              topicDescription: 'Luyện nghe tên thành phố quốc tế và mã sân bay (LHR, JFK, SYD...)',
              questionCount: 10,
              dictationId: 'dict_02',
              testId: 'cam19_test2',
              partNumber: 1,
            ),
          ],
        ),
      ],
    ),

    // 4. NUMBERS
    ArchiveGroup(
      id: 'arch_numbers',
      title: 'NUMBERS',
      badgeText: '3 Bài Luyện Tập',
      tagNumber: '#123',
      tagBgColor: Color(0xFFFEF3C7),
      tagTextColor: Color(0xFFD97706),
      category: ArchiveCategoryType.numbers,
      subSections: [
        ArchiveSubSection(
          subTitle: 'SỐ LIỆU, THỜI GIAN & TIỀN TỆ',
          lessons: [
            ArchiveLessonItem(
              id: 'num_phones',
              lessonName: 'Telephone & Credit Card Numbers',
              topicDescription: 'Luyện bắt số điện thoại và dãy số thẻ ngân hàng 16 số',
              questionCount: 10,
              dictationId: 'dict_02',
              testId: 'cam19_test2',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'num_dates',
              lessonName: 'Times, Dates & Booking Schedules',
              topicDescription: 'Luyện nghe giờ giấc (AM/PM), ngày tháng năm và lịch hẹn',
              questionCount: 10,
              dictationId: 'dict_01',
              testId: 'cam20_test1',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'num_prices',
              lessonName: 'Prices, Currency (£, \$, €) & Discounts',
              topicDescription: 'Luyện nghe giá tiền bảng Anh, đô la, euro và phần trăm giảm giá',
              questionCount: 10,
              dictationId: 'dict_02',
              testId: 'cam19_test2',
              partNumber: 1,
            ),
          ],
        ),
      ],
    ),

    // 5. PRONUNCIATION
    ArchiveGroup(
      id: 'arch_pronunciation',
      title: 'PRONUNCIATION',
      badgeText: '3 Cặp Âm Dễ Lẫn',
      tagNumber: 'IPA',
      tagBgColor: Color(0xFFECFDF5),
      tagTextColor: Color(0xFF059669),
      category: ArchiveCategoryType.pronunciation,
      subSections: [
        ArchiveSubSection(
          subTitle: 'MINIMAL PAIRS & PHÂN BIỆT ÂM',
          lessons: [
            ArchiveLessonItem(
              id: 'ipa_i',
              lessonName: 'Cặp âm /iː/ vs /ɪ/',
              topicDescription: 'Phân biệt sheep/ship, eat/it, reach/rich, leave/live',
              questionCount: 10,
              dictationId: 'dict_01',
              testId: 'cam20_test1',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'ipa_ae',
              lessonName: 'Cặp âm /æ/ vs /e/',
              topicDescription: 'Phân biệt bad/bed, man/men, pan/pen, bat/bet',
              questionCount: 10,
              dictationId: 'dict_02',
              testId: 'cam19_test2',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'ipa_lr',
              lessonName: 'Cặp âm /l/ vs /r/',
              topicDescription: 'Phân biệt light/right, lock/rock, long/wrong, lead/read',
              questionCount: 10,
              dictationId: 'dict_01',
              testId: 'cam20_test1',
              partNumber: 1,
            ),
          ],
        ),
      ],
    ),

    // 6. CONVERSATIONS
    ArchiveGroup(
      id: 'arch_conversations',
      title: 'CONVERSATIONS',
      badgeText: '3 Tình Huống Giao Tiếp',
      tagNumber: '💬',
      tagBgColor: Color(0xFFF0FDF4),
      tagTextColor: Color(0xFF16A34A),
      category: ArchiveCategoryType.conversations,
      subSections: [
        ArchiveSubSection(
          subTitle: 'HỘI THOẠI ĐỜI SỐNG (PART 1 & 2)',
          lessons: [
            ArchiveLessonItem(
              id: 'conv_hotel',
              lessonName: 'Holiday Accommodation Enquiry',
              topicDescription: 'Tình huống thuê phòng nghỉ ven biển, số lượng người và tiện ích',
              questionCount: 10,
              dictationId: 'dict_01',
              testId: 'cam20_test1',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'conv_airport',
              lessonName: 'Hotel Reception & Airport Shuttle',
              topicDescription: 'Tình huống đón tiễn sân bay, thời gian xe chạy và hành lý',
              questionCount: 10,
              dictationId: 'dict_02',
              testId: 'cam19_test2',
              partNumber: 1,
            ),
            ArchiveLessonItem(
              id: 'conv_gym',
              lessonName: 'Community Sports Center Membership',
              topicDescription: 'Đăng ký thẻ thành viên trung tâm thể dục thể thao địa phương',
              questionCount: 10,
              testId: 'cam20_test1',
              partNumber: 2,
            ),
          ],
        ),
      ],
    ),
  ];
}


