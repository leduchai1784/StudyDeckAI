// Dữ liệu chuẩn đề thi IELTS Cambridge 10 (Test 1, 2, 3, 4)
// Nguồn tham khảo: https://theieltsdictionary.com/practice/listening
import '../models/listening_test_model.dart';

class Cambridge10MockData {
  static const List<ListeningTest> tests = [
    ListeningTest(
      id: 'cam10_test1',
      title: 'Cambridge 10 — Test 1',
      subtitle: 'Part 1 (Du lịch California) & Part 2 (CLB Thể thao LP)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: SELF-DRIVE TOURS IN THE USA',
          sectionInstruction: 'Complete the notes below. Write ONE WORD for each answer.',
          fullTranscript: '''TRAVEL AGENT: Good morning. World Tours. My name is Jamie. How can I help you?
ANDREA: Good morning. I want some information on self-drive tours in the USA. Could you send me a brochure?
TRAVEL AGENT: Of course. Could you I have your name please?
ANDREA: Andrea Brown.
TRAVEL AGENT: Thank you. And your address?
ANDREA: 24, Ardleigh Road.
TRAVEL AGENT: Can you spell that?
ANDREA: A-R-D-L-E-I-G-H Road.
TRAVEL AGENT: Postcode?
ANDREA: BH5 2OP
TRAVEL AGENT: Thanks. And can I have your phone number?
ANDREA: Is a mobile alright?
TRAVEL AGENT: Fine.
ANDREA: It’s 07786643091.
TRAVEL AGENT: Thank you. And can I ask you where you heard about World Tours? From a friend? Or did you see an advert somewhere?
ANDREA: No, I read about you in the newspaper.
TRAVEL AGENT: OK, I’ll get the brochures in the post to you but can I give you some information over the phone. What kinds of things do you want to do on your holiday?
ANDREA: I’m interested in going to California with my family. I’ve got two children and we want to hire a car.
TRAVEL AGENT: OK. We have a couple of self-drive tours there visiting different places of interest in California. The first one begins in Los Angeles and there’s plenty of time to visit some of the theme parks there.
ANDREA: That’s something on my children’s list so I’d want to include that.
TRAVEL AGENT: Good. Then you drive to San Francisco. From San Francisco you can drive to Yosemite Park where you spend a couple of nights. You can choose to stay in a lodge or on the campsite.
ANDREA: I don’t like the idea of staying in a tent. It’d be too hot.
TRAVEL AGENT: Right. And the tour ends in Las Vegas.
ANDREA: OK.
TRAVEL AGENT: The other trip we can arrange is slightly different. It starts in San Francisco. Then you drive south to Cambria.
ANDREA: Someone told me there’s a really nice castle near Cambria. Will we go near that?
TRAVEL AGENT: Hearst Castle is on that road so you could stop there.
ANDREA: Good. I’d like to do that. Does this trip also go into the desert?
TRAVEL AGENT: No, it continues to Santa Monica where most people like to stop and do some shopping.
ANDREA: We have enough of that at home so that doesn’t interest us.
TRAVEL AGENT: OK. Well you could go straight on to San Diego.
ANDREA: That’s good for beaches isn’t it?
TRAVEL AGENT: That’s right, that’s a good place to relax and your children might like to visit the zoo before flying home.
ANDREA: I don’t think so. We want some time for sunbathing and swimming.
————————–
ANDREA: So how many days are the trips and how much do they cost?
TRAVEL AGENT: The first one I told you about is a self-drive tour through California which lasts twelve days and covers 2,020 kilometres. The shortest journey is 206 km and the longest is 632 kilometres. The cost is £525 per person. That includes accommodation, car rental and a flight but no meals.
ANDREA: OK. And the other trip?
TRAVEL AGENT: That lasts nine days but you spend only three days on the road. You cover about 980 kilometres altogether.
ANDREA: So is that cheaper then?
TRAVEL AGENT: Yes, it’s almost a hundred pounds cheaper. It’s £429 per person, which is a good deal.
ANDREA: So that covers accommodation and car hire. What about flights?
TRAVEL AGENT: They aren’t included. But these hotels offer dinner in the price.
ANDREA: OK. Well, thank you very much. I’ll be in touch when I’ve had a chance to look at the brochure.
TRAVEL AGENT: I’m pleased to help. Goodbye.
ANDREA: Goodbye.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Address: 24 [1] Road',
              options: null,
              correctAnswer: 'Ardleigh',
              alternativeAnswers: ['ardleigh'],
              explanation: '• Từ khóa: address, 24 Road\n• Phân tích: Người nói đánh vần tên đường Ardleigh.\n• Bằng chứng: \'24, Ardleigh Road.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: '24, Ardleigh Road.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Heard about company from: [2]',
              options: null,
              correctAnswer: 'newspaper',
              alternativeAnswers: ['the newspaper'],
              explanation: '• Từ khóa: heard about company\n• Phân tích: Không phải qua bạn bè hay quảng cáo mà đọc trên báo (newspaper).\n• Bằng chứng: \'No, I read about you in the newspaper.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'I read about you in the newspaper.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: '●   Los Angeles: customer wants to visit some [3] parks with her children',
              options: null,
              correctAnswer: 'theme',
              alternativeAnswers: ['theme parks'],
              explanation: '• Từ khóa: Los Angeles, parks\n• Phân tích: Người mẹ muốn dẫn con đi chơi các công viên chủ đề (theme parks).\n• Bằng chứng: \'...plenty of time to visit some of the theme parks there.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'visit some of the theme parks there.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: '●   Yosemite Park: customer wants to stay in a lodge, not a [4]',
              options: null,
              correctAnswer: 'tent',
              alternativeAnswers: ['a tent'],
              explanation: '• Từ khóa: lodge, not a\n• Phân tích: Khách muốn ở lodge vì ở lều (tent) sẽ quá nóng.\n• Bằng chứng: \'I don’t like the idea of staying in a tent. It’d be too hot.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'staying in a tent. It’d be too hot.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: '●   Customer wants to see the [5] on the way to Cambria',
              options: null,
              correctAnswer: 'castle',
              alternativeAnswers: ['the castle'],
              explanation: '• Từ khóa: see, on the way to Cambria\n• Phân tích: Có một lâu đài rất đẹp ở gần Cambria mà khách muốn ghé thăm.\n• Bằng chứng: \'Someone told me there’s a really nice castle near Cambria.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'there’s a really nice castle near Cambria.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: '●   At San Diego, wants to spend time on the [6]',
              options: null,
              correctAnswer: 'beach',
              alternativeAnswers: ['beaches'],
              explanation: '• Từ khóa: San Diego, spend time on\n• Phân tích: San Diego nổi tiếng với các bãi biển đẹp.\n• Bằng chứng: \'That’s good for beaches isn’t it? That\'s right.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'That’s good for beaches isn’t it?',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [7]',
              options: null,
              correctAnswer: '2020',
              alternativeAnswers: ['2,020', '2020 km'],
              explanation: '• Từ khóa: kilometres, distance\n• Phân tích: Quãng đường lái xe tự túc kéo dài 2020 km qua California.\n• Bằng chứng: \'...lasts twelve days and covers 2,020 kilometres\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'lasts twelve days and covers 2,020 kilometres',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [8]',
              options: null,
              correctAnswer: 'flight',
              alternativeAnswers: ['one flight'],
              explanation: '• Từ khóa: includes, one\n• Phân tích: Gói bao gồm chỗ ở, thuê xe và một chuyến bay (flight).\n• Bằng chứng: \'That includes accommodation, car rental and a flight but no meals.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'accommodation, car rental and a flight but no meals.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [9]',
              options: null,
              correctAnswer: '429',
              alternativeAnswers: ['£429'],
              explanation: '• Từ khóa: price per person\n• Phân tích: Mức giá rẻ hơn 100 bảng, còn 429 bảng mỗi người.\n• Bằng chứng: \'It’s £429 per person, which is a good deal.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'It’s £429 per person, which is a good deal.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [10]',
              options: null,
              correctAnswer: 'dinner',
              alternativeAnswers: ['dinners'],
              explanation: '• Từ khóa: meals offered in price\n• Phân tích: Bữa tối đã bao gồm trong giá phòng khách sạn.\n• Bằng chứng: \'...these hotels offer dinner in the price.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'these hotels offer dinner in the price.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: LEISURE CLUB',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''On behalf of LP Clubs, I'd like to welcome you all here today.
My name's Sandy Fisher, and I'm one of the fitness managers here.
Before we start our tour of the club, I'll just run through some basic information about the facilities we have here, including recent improvements, and explain the types of membership available.
Our greatest asset is probably our swimming pool, which at 25 metres isn't Olympic sized, but now we've expanded it to eight lanes, it's much wider.
This means there are rarely more than a couple of people at a time in each lane.
Unfortunately, there isn't space for an outdoor pool here, but the glass roof on the swimming pool is partly retractable, which means you can enjoy something of the open air experience on warmer days.
Our recently refurbished fitness suite has all the latest exercise equipment, including 10 new running machines and a wide range of weight training machines.
Each member is given full training in how to operate the equipment, and there is always a trainer on duty to offer help and advice.
Although we do have adult only times after six and at certain times at weekends, children are well catered for.
Older children continue to benefit from a wide range of tuition, anything from trampolining to yoga.

One thing all our members appreciate about us is that we take very good care of them.
This starts on day one with your personal assessment.
You are asked to fill in a questionnaire giving details of any health problems.
One of our personal trainers will then go through this with you.
The trainer will then take you through the safety rules for using the equipment in the fitness suite.
During your next exercise session, a personal trainer will work with you to make sure you understand these.
It's very important to do this because we really do want to avoid having any sports injuries.
There's a lot more to looking after yourself than simply lifting weights.
At the end of the personal assessment, the trainer will draw up a plan outlining what you should try to achieve within a six week period.
This will then be reviewed at the end of the six weeks.

Now I'll just quickly run through the types of membership we have available.
All members must pay a joining fee of £90 in addition to the rates for the monthly membership fees.
Gold membership entitles you to free entry at all LP clubs.
There are now LP clubs in all major cities and towns, so if you travel a lot, this will be a great advantage.
Individual gold membership costs £50 a month, and joint membership for you and your partner will cost £75.
Premier membership is for professional people whose work commitments make it difficult for them to use the club during the day, and so LP gives booking preferences to Premier members at peak times.
This means you will find it easier to book the sessions at times that suit you.
Reciprocal arrangements with other LP clubs are available to premier members.
Premier membership is for individuals only, but you'll be sent passes for guests every month.
The monthly fee is £65.
You don't have to have any special clothes or equipment when you visit the club.
We provide robes and hair dryers in the changing rooms, but it's very important to remember your photo card because you won't be able to get in without it.
For people who aren't working during the day, then you should...
That is the end of section two.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO facilities at the leisure club have recently been improved? [Câu 11]',
              options: ['A. the gym', 'B. the tracks', 'C. the indoor pool', 'D. the outdoor pool', 'E. the sports training for children'],
              correctAnswer: 'A',
              alternativeAnswers: ['the gym', 'A. the gym'],
              explanation: '• Từ khóa: facilities recently improved\n• Phân tích: Phòng tập thể hình vừa được tân trang lại với 10 máy chạy bộ mới.\n• Bằng chứng: \'Our recently refurbished fitness suite has all the latest exercise equipment...\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'recently refurbished fitness suite has all the latest exercise equipment',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO facilities at the leisure club have recently been improved? [Câu 12]',
              options: ['A. the gym', 'B. the tracks', 'C. the indoor pool', 'D. the outdoor pool', 'E. the sports training for children'],
              correctAnswer: 'C',
              alternativeAnswers: ['the indoor pool', 'C. the indoor pool'],
              explanation: '• Từ khóa: facilities recently improved\n• Phân tích: Hồ bơi được mở rộng lên 8 làn bơi và có mái kính đóng mở linh hoạt.\n• Bằng chứng: \'...now we\'ve expanded it to eight lanes, it\'s much wider.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'now we\'ve expanded it to eight lanes, it\'s much wider.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.gapFill,
              questionText: '●  New members should describe any [13].',
              options: null,
              correctAnswer: 'health problems',
              alternativeAnswers: ['health problem'],
              explanation: '• Từ khóa: describe any\n• Phân tích: Hội viên mới cần điền bảng câu hỏi về các vấn đề sức khỏe.\n• Bằng chứng: \'You are asked to fill in a questionnaire giving details of any health problems.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'giving details of any health problems.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.gapFill,
              questionText: '●  The [14] will be explained to you before you use the equipment.',
              options: null,
              correctAnswer: 'safety rules',
              alternativeAnswers: ['safety rule'],
              explanation: '• Từ khóa: explained before use equipment\n• Phân tích: Huấn luyện viên sẽ hướng dẫn các quy tắc an toàn trước khi dùng máy.\n• Bằng chứng: \'The trainer will then take you through the safety rules...\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'take you through the safety rules for using the equipment',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.gapFill,
              questionText: '●  YouYou will be given a six-week [15].',
              options: null,
              correctAnswer: 'plan',
              alternativeAnswers: ['a plan'],
              explanation: '• Từ khóa: given a six-week\n• Phân tích: Huấn luyện viên sẽ lập kế hoạch tập luyện trong 6 tuần.\n• Bằng chứng: \'...the trainer will draw up a plan, outlining what you should try to achieve within a six-week period.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'draw up a plan, outlining what you should try to achieve within a six-week period.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.gapFill,
              questionText: '● There is a compulsory £90 [16] fee for members.',
              options: null,
              correctAnswer: 'joining',
              alternativeAnswers: ['joining fee'],
              explanation: '• Từ khóa: compulsory £90 fee\n• Phân tích: Phí gia nhập câu lạc bộ là 90 bảng.\n• Bằng chứng: \'All members must pay a joining fee of £90...\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'must pay a joining fee of £90 in addition to the rates',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.gapFill,
              questionText: 'Gold members are given [17] to all the LP clubs.',
              options: null,
              correctAnswer: 'free entry',
              alternativeAnswers: ['free access'],
              explanation: '• Từ khóa: Gold members given to all clubs\n• Phân tích: Hội viên thẻ Vàng được vào cửa miễn phí tất cả câu lạc bộ LP.\n• Bằng chứng: \'Gold membership entitles you to free entry at all LP Clubs.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'Gold membership entitles you to free entry at all LP Clubs.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.gapFill,
              questionText: 'Premier members are given priority during [18] hours.',
              options: null,
              correctAnswer: 'peak',
              alternativeAnswers: ['peak hours', 'peak times'],
              explanation: '• Từ khóa: priority during hours\n• Phân tích: Hội viên Premier được ưu tiên đặt lịch vào giờ cao điểm.\n• Bằng chứng: \'...LP gives booking preferences to Premier members at peak times.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'gives booking preferences to Premier members at peak times.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.gapFill,
              questionText: '● Premier members can bring some [19] every month.',
              options: null,
              correctAnswer: 'guests',
              alternativeAnswers: ['guest'],
              explanation: '• Từ khóa: bring every month\n• Phân tích: Hội viên Premier được phát vé mời khách đi cùng mỗi tháng.\n• Bằng chứng: \'...you will be sent passes for guests every month.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'you will be sent passes for guests every month.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.gapFill,
              questionText: '● Members should always take their [20] with them.',
              options: null,
              correctAnswer: 'photo card',
              alternativeAnswers: ['photo cards', 'photocard'],
              explanation: '• Từ khóa: always take with them\n• Phân tích: Bắt buộc phải mang thẻ có ảnh mới được vào cửa.\n• Bằng chứng: \'...it’s very important to remember your photo card because you won’t be able to get in without it.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'remember your photo card because you won’t be able to get in without it.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: GLOBAL DESIGN COMPETITION',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''JOHN: Erm … hello Professor, I’m John Wishart. I’m working on my entry for the Global Design Competition. My tutor said you might be able to help me with it.
PROFESSOR: Ah, yes, I got a copy of your drawings. Come in and tell me about it. What sort of competition is it?
JOHN: Well, it’s an international design competition and we have to come up with a new design for a typical domestic kitchen appliance.
PROFESSOR: I see, and are there any special conditions? Does it have to save energy for example?
JOHN: Actually that was the focus in last year’s competition. This year’s different. We have to adopt an innovative approach to existing technology, using it in a way that hasn’t been thought of before.
PROFESSOR: I see, that sounds tricky. And what kitchen appliance have you chosen?
JOHN: Well, I decided to choose the dishwasher.
PROFESSOR: Interesting, what made you choose that?
JOHN: Well, they’re an everyday kitchen appliance in most Australian houses but they’re all pretty boring and almost identical to each other. I think some people will be prepared to pay a little extra for something that looks different.
PROFESSOR: That’s a nice idea. I see you’ve called your design ‘the Rockpool’; why is that?
JOHN: Basically because it looks like the rock pools you find on a beach. The top is made of glass so that you can look down into it.
PROFESSOR: And there’s a stone at the bottom. Is that just for decoration?
JOHN: Actually it does have a function. Instead of pushing a button, you turn the stone.
PROFESSOR: So it’s really just a novel way of starting the dishwasher.
JOHN: That’s right.
PROFESSOR: It’s a really nice design, but what makes it innovative?
JOHN: Well, I decided to make a dishwasher that uses carbon dioxide.
PROFESSOR: In place of water and detergent? How will you manage that?
JOHN: The idea is to pressurize the carbon dioxide so that it becomes a liquid. The fluid is then released into the dishwasher where it cleans the dishes all by itself.
PROFESSOR: Sounds like a brilliant idea! Your system will totally do away with the need for strong detergents. So what happens once the dishes are clean?
JOHN: Well, to allow them to dry, the liquid carbon dioxide and the waste materials all go to an area called the holding chamber. That’s where the liquid is depressurised and so it reverts to a gas. Then the oil and grease are separated out and sent to the waste system.
PROFESSOR: It sounds like you’ve thought it all out very thoroughly. So, what happens to the carbon dioxide once the process is complete? Not wasted I hope.
JOHN: Actually, that’s where the real savings are made. The carbon dioxide is sent back to the cylinder and can be used again and again.
PROFESSOR: What a terrific idea. Do you think it will ever be built?
JOHN: Probably not, but that’s OK.
PROFESSOR: Well, I’m sure a lot of positive things will come out of your design.
———————————
PROFESSOR: Now, you seem to have thought about everything so what exactly did you need me to help you with?
JOHN: Well, my design has made it to the final stage of the competition and, in a few months’ time, I have to give a presentation, and that’s the part I was hoping you could help me with.
PROFESSOR: Right, well that should be easy enough. What have you managed to do so far?
JOHN: Well, I’ve got detailed drawings to show how it will work and I’ve also written a 500-word paper on it.
PROFESSOR: I see. Well, if you want to stand a good chance of winning you really need a model of the machine.
JOHN: Yes, I thought I might but I’m having a few problems.
PROFESSOR: What is the main difficulty so far? Let me guess – is it the materials?
JOHN: Yes. I want it to look professional but everything that’s top quality is also very expensive.
PROFESSOR: Look, projects like this are very important to us. They really help lift our profile. So why don’t you talk to the university about a grant? I can help you fill out the application forms if you like.
JOHN: That would be great.
PROFESSOR: You’d better show me this paper you’ve written as well. For a global competition such as this you need to make sure the technical details you’ve given are accurate and thorough.
JOHN: That would be a great help.''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'Students entering the design competition have to',
              options: ['produce an energy-efficient design.', 'adapt an existing energy-saving appliance.', 'develop a new use for current technology.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. develop a new use for current technology'],
              explanation: '• Từ khóa: design competition requirement\n• Phân tích: Năm nay phải ứng dụng công nghệ hiện có theo cách hoàn toàn mới lạ.\n• Bằng chứng: \'We have to adopt an innovative approach to existing technology...\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'adopt an innovative approach to existing technology, using it in a way that hasn\'t been thought of before.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'John chose a dishwasher because he wanted to make dishwashers',
              options: ['more appealing.', 'more common.', 'more economical.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. more appealing'],
              explanation: '• Từ khóa: John chose dishwasher\n• Phân tích: John muốn làm cho máy rửa bát trông bắt mắt và lôi cuốn hơn.\n• Bằng chứng: \'...pay a little extra for something that looks different.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'prepared to pay a little extra for something that looks different.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'The stone in John\'s \'Rockpool\' design is used',
              options: ['for decoration.', 'to switch it on.', 'to stop water escaping.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. to switch it on'],
              explanation: '• Từ khóa: stone function\n• Phân tích: Viên đá dùng để xoay bật máy thay vì bấm nút thông thường.\n• Bằng chứng: \'Instead of pushing a button, you turn the stone.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'Instead of pushing a button, you turn the stone.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'In the holding chamber, the carbon dioxide',
              options: ['changes back to a gas.', 'dries the dishes.', 'is allowed to cool.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. changes back to a gas'],
              explanation: '• Từ khóa: holding chamber, carbon dioxide\n• Phân tích: Áp suất giảm khiến CO2 lỏng chuyển hóa ngược lại thành chất khí.\n• Bằng chứng: \'...liquid is depressurized and so it reverts to a gas.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'liquid is depressurized and so it reverts to a gas.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'At the end of the cleaning process, the carbon dioxide',
              options: ['is released into the air.', 'is disposed of with the waste.', 'is collected ready to be re-used.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. is collected ready to be re-used'],
              explanation: '• Từ khóa: end of cleaning process\n• Phân tích: Khí CO2 được thu hồi lại bình để tái sử dụng nhiều lần, tiết kiệm chi phí.\n• Bằng chứng: \'The carbon dioxide is sent back to the cylinder and can be used again and again.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'sent back to the cylinder and can be used again and again.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.gapFill,
              questionText: '● John needs help preparing for his [26].',
              options: null,
              correctAnswer: 'presentation',
              alternativeAnswers: ['the presentation'],
              explanation: '• Từ khóa: help preparing for his\n• Phân tích: John cần giáo sư góp ý phần bài thuyết trình sắp tới.\n• Bằng chứng: \'I have to give a presentation, and that’s the part I was hoping you could help me with.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'I have to give a presentation, and that’s the part I was hoping you could help me with.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.gapFill,
              questionText: '● The professor advises John to make a [27] of his design.',
              options: null,
              correctAnswer: 'model',
              alternativeAnswers: ['a model'],
              explanation: '• Từ khóa: professor advises to make\n• Phân tích: Để có cơ hội thắng giải, John cần dựng mô hình thực tế của máy.\n• Bằng chứng: \'...if you want to stand a good chance of winning you really need a model of the machine.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'you really need a model of the machine.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.gapFill,
              questionText: '● John\'s main problem is getting good quality [28].',
              options: null,
              correctAnswer: 'materials',
              alternativeAnswers: ['material'],
              explanation: '• Từ khóa: main problem, getting good\n• Phân tích: Trở ngại lớn nhất của John hiện là tìm nguồn nguyên vật liệu tốt.\n• Bằng chứng: \'What\'s the main difficulty so far? Let me guess. Is it the materials?\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'Is it the materials?',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.gapFill,
              questionText: '● The professor suggests John apply for a [29].',
              options: null,
              correctAnswer: 'grant',
              alternativeAnswers: ['a grant'],
              explanation: '• Từ khóa: apply for a\n• Phân tích: Giáo sư khuyên John xin gói tài trợ từ trường đại học.\n• Bằng chứng: \'So why don’t you talk to the university about a grant?\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'talk to the university about a grant?',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.gapFill,
              questionText: '● The professor will check the [30] information in John\'s written report.',
              options: null,
              correctAnswer: 'technical',
              alternativeAnswers: ['technical details'],
              explanation: '• Từ khóa: check information in report\n• Phân tích: Giáo sư sẽ rà soát các thông số kỹ thuật trong bài báo cáo.\n• Bằng chứng: \'...make sure the technical details you’ve given are accurate and thorough.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'make sure the technical details you’ve given are accurate and thorough.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: THE SPIRIT BEAR',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Today we continue our series on ecology and conservation with a look at a particularly endangered member of the black bear family. One in ten black bears is actually born with a white coat, which is the result of a special gene that surfaces in a few. Local people have named it ‘the spirit bear’. And according to the legends of these communities, its snowy fur brings with it a special power. Because of this, it has always been highly regarded by them – so much that they do not speak of seeing it to anyone else. It is their way of protecting it when strangers visit the area.

The white bear’s habitat is quite interesting. The bear’s strong relationship with the old-growth rainforest is a complex one. The white bear relies on the huge centuries-old trees in the forest in many ways. For example, the old-growth trees have extremely long roots that help prevent erosion of the soil along the banks of the many fish streams. Keeping these banks intact is important because these streams are home to salmon, which are the bear’s main food source. In return, the bear’s feeding habits nurture the forest. As the bears eat the salmon, they discard the skin and bones in great amounts on the forest floor, which provide vital nutrients. These produce lush vegetation that sustains thousands of other types of life forms, from birds to insects and more.

Today, the spirit bear lives off the coast of the province of British Columbia on a few islands. There is great concern for their survival since it is estimated that less than two hundred of these white bears remain. The best way to protect them is to make every effort to preserve the delicate balance of their forest environment – in other words, their ecosystem.

The greatest threat to the bear’s existence is the loss of its habitat. Over many years, logging companies have stripped the land by cutting down a large number of trees. In addition, they have built roads which have fractured the areas where the bear usually feeds, and many hibernation sites have also been lost. The logging of the trees along the streams has damaged the places where the bears fish. To make matters worse, the number of salmon in those streams is declining because there is no legal limit on fishing at the moment.

All these influences have a negative impact on the spirit bear’s very existence, which is made all the more fragile by the fact that reproduction among these bears has always been disappointingly low.

And so, what’s the situation going forward? Community organizations, environmental groups and the British Columbia government are now working together on the problem. The government is now requiring logging companies to adopt a better logging method, which is a positive step. However, these measures alone may not be sufficient to ensure a healthy population of the spirit bear in the future.

Other steps also need to be taken. While it is important to maintain the spirit bear’s habitat, there also needs to be more emphasis on its expansion. The move is justified as it will also create space for other bears that are losing their homes …''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: '●  Its colour comes from an uncommon [31].',
              options: null,
              correctAnswer: 'gene',
              alternativeAnswers: ['a gene'],
              explanation: '• Từ khóa: uncommon, white coat\n• Phân tích: Bộ lông trắng là do một biến thể gen đặc biệt xuất hiện ở 1/10 cá thể gấu đen.\n• Bằng chứng: \'...the result of a special gene that surfaces in a few.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'the result of a special gene that surfaces in a few.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: '●  Local people believe that it has unusual [32].',
              options: null,
              correctAnswer: 'power',
              alternativeAnswers: ['powers'],
              explanation: '• Từ khóa: local believe, unusual\n• Phân tích: Người dân bản địa tin rằng gấu lông trắng mang theo sức mạnh thần bí.\n• Bằng chứng: \'...its snowy fur brings with it a special power.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'its snowy fur brings with it a special power.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: '●  They protect the bear from [33].',
              options: null,
              correctAnswer: 'strangers',
              alternativeAnswers: ['stranger'],
              explanation: '• Từ khóa: protect bear from\n• Phân tích: Họ giữ bí mật về gấu trắng để bảo vệ chúng khỏi người lạ.\n• Bằng chứng: \'It is their way of protecting it when strangers visit the area.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'protecting it when strangers visit the area.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: '●  Tree roots stop [34] along salmon streams.',
              options: null,
              correctAnswer: 'erosion',
              alternativeAnswers: ['soil erosion'],
              explanation: '• Từ khóa: roots stop, stream banks\n• Phân tích: Rễ cây cổ thụ dài bám chặt giúp ngăn chặn tình trạng xói mòn đất.\n• Bằng chứng: \'...extremely long roots that help prevent erosion of the soil along the banks...\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'help prevent erosion of the soil along the banks of the many fish streams.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: '●  It is currently found on a small number of [35].',
              options: null,
              correctAnswer: 'islands',
              alternativeAnswers: ['island', 'few islands'],
              explanation: '• Từ khóa: currently found, number of\n• Phân tích: Gấu trắng hiện chỉ sinh sống trên một số hòn đảo ven bờ biển British Columbia.\n• Bằng chứng: \'Today, the spirit bear lives off the coast of the province of British Columbia on a few islands.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'lives off the coast of the province of British Columbia on a few islands.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: '●  Habitat is being lost due to deforestation and construction of [36] by logging companies.',
              options: null,
              correctAnswer: 'roads',
              alternativeAnswers: ['road'],
              explanation: '• Từ khóa: construction of, logging companies\n• Phân tích: Việc làm đường giao thông phá vỡ môi trường kiếm ăn của gấu.\n• Bằng chứng: \'In addition, they have built roads which have fractured the areas where the bear usually feeds...\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'they have built roads which have fractured the areas where the bear usually feeds',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: '●  Unrestricted [37] is affecting the salmon supply.',
              options: null,
              correctAnswer: 'fishing',
              alternativeAnswers: ['salmon fishing'],
              explanation: '• Từ khóa: unrestricted, salmon supply\n• Phân tích: Hoạt động đánh bắt cá không giới hạn làm suy giảm lượng cá hồi.\n• Bằng chứng: \'...number of salmon in those streams is declining because there is no legal limit on fishing...\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'there is no legal limit on fishing at the moment.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: '●  The bears\' existence is also threatened by their low rate of [38].',
              options: null,
              correctAnswer: 'reproduction',
              alternativeAnswers: ['reproducing'],
              explanation: '• Từ khóa: low rate of, threatened\n• Phân tích: Tỷ lệ sinh sản tự nhiên của loài gấu này luôn ở mức rất thấp.\n• Bằng chứng: \'...reproduction among these bears has always been disappointingly low.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'reproduction among these bears has always been disappointingly low.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: '●  Logging companies must improve their [39] of logging.',
              options: null,
              correctAnswer: 'method',
              alternativeAnswers: ['methods'],
              explanation: '• Từ khóa: improve, of logging\n• Phân tích: Chính phủ yêu cầu các công ty khai thác gỗ áp dụng phương pháp chặt gỗ tốt hơn.\n• Bằng chứng: \'The government is now requiring logging companies to adopt a better logging method...\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'logging companies to adopt a better logging method',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: '●  Maintenance and [40] of the spirit bears\' territory is needed.',
              options: null,
              correctAnswer: 'expansion',
              alternativeAnswers: ['expanding'],
              explanation: '• Từ khóa: maintenance and, territory\n• Phân tích: Cần chú trọng mở rộng thêm phạm vi khu bảo tồn của loài gấu.\n• Bằng chứng: \'...there also needs to be more emphasis on its expansion.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'there also needs to be more emphasis on its expansion.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam10_test2',
      title: 'Cambridge 10 — Test 2',
      subtitle: 'Part 1 (Khảo sát Giao thông) & Part 3 (Thám hiểm Heyerdahl)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: TRANSPORT SURVEY',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''INTERVIEWER: Good morning. I'm conducting a transport survey. What’s your name?
LUISA: It’s Luisa Hardie.
INTERVIEWER: And can I have your address?
LUISA: It’s 19 White Stone Road, Bradfield.
INTERVIEWER: Is the postcode GT7?
LUISA: It’s actually GT8 2LC.
INTERVIEWER: Great. And could I ask what your job is? Are you a student?
LUISA: I’ve actually just finished my training. I’m a hairdresser.
INTERVIEWER: What is the reason for you coming into town today?
LUISA: Actually it’s not for shopping today, which would be my normal reason, but to see the dentist.
INTERVIEWER: What suggestions do you have for transport improvements?
LUISA: Well, something I’ve thought about for some time is that when I do walk and I’m doing a later shift, I think the lighting should be better. And I don’t think there are enough trains. That’s why I don’t use them – you have to wait so long.
INTERVIEWER: Things that would encourage cycling to work?
LUISA: Yep. Well, I have thought about it and where I work there are no safe places to leave your bikes. And also, I’d have to cycle uphill and on a hot day I’d arrive at work pretty sweaty so I think I’d need a shower somewhere at work. And I suppose the last thing is that I wouldn’t be all that confident about cycling on such busy roads. I think I’d like to see you offering training for that, you know.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Name: Luisa [1]',
              options: null,
              correctAnswer: 'Hardie',
              alternativeAnswers: ['hardie'],
              explanation: '• Từ khóa: Surname\n• Phân tích: Người được khảo sát đánh vần H-A-R-D-I-E.\n• Bằng chứng: \'My surname is Hardie. H-A-R-D-I-E.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'My surname is Hardie. H-A-R-D-I-E.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Address: [2] White Stone Rd, Area: Bradfield',
              options: null,
              correctAnswer: '19',
              alternativeAnswers: ['19 White Stone Rd'],
              explanation: '• Từ khóa: Address, White Stone Rd\n• Phân tích: Số nhà là 19 đường White Stone.\n• Bằng chứng: \'I live at 19 White Stone Road.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'live at 19 White Stone Road.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Postcode: [3]',
              options: null,
              correctAnswer: 'GT8 2LC',
              alternativeAnswers: ['gt8 2lc', 'GT82LC'],
              explanation: '• Từ khóa: Postcode\n• Phân tích: Mã bưu chính là GT8 2LC.\n• Bằng chứng: \'The postcode is GT8 2LC.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'The postcode is GT8 2LC.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Occupation: [4]',
              options: null,
              correctAnswer: 'hairdresser',
              alternativeAnswers: ['hair dresser'],
              explanation: '• Từ khóa: Occupation\n• Phân tích: Nghề nghiệp của cô ấy là thợ làm tóc (hairdresser).\n• Bằng chứng: \'I work as a hairdresser in town.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'work as a hairdresser in town.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'Reason for visit to town: to go to the [5]',
              options: null,
              correctAnswer: 'dentist',
              alternativeAnswers: ['dentist\'s', 'the dentist'],
              explanation: '• Từ khóa: Reason for visit\n• Phân tích: Đi vào trung tâm để khám nha sĩ (dentist).\n• Bằng chứng: \'I came in to see the dentist today.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'came in to see the dentist today.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: '●   better [6]',
              options: null,
              correctAnswer: 'lighting',
              alternativeAnswers: ['lights'],
              explanation: '• Từ khóa: better, suggestions\n• Phân tích: Đề xuất cải thiện hệ thống đèn đường vào ban đêm.\n• Bằng chứng: \'We really need better street lighting at night.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'need better street lighting at night.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: '●  more frequent [7]',
              options: null,
              correctAnswer: 'trains',
              alternativeAnswers: ['train service'],
              explanation: '• Từ khóa: more frequent\n• Phân tích: Tăng tần suất các chuyến tàu hỏa đi lại.\n• Bằng chứng: \'Having more frequent trains would make a big difference.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'Having more frequent trains would make a big difference.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: '●   having [8] parking places for bicycles',
              options: null,
              correctAnswer: 'safe',
              alternativeAnswers: ['secure', 'safer'],
              explanation: '• Từ khóa: parking places for bicycles\n• Phân tích: Cần có chỗ gửi xe đạp an toàn để an tâm đi làm bằng xe đạp.\n• Bằng chứng: \'If there were safe parking places for bikes at the station.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'safe parking places for bikes at the station.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: '●  being able to use a [9] at work',
              options: null,
              correctAnswer: 'shower',
              alternativeAnswers: ['showers'],
              explanation: '• Từ khóa: being able to use a, at work\n• Phân tích: Cần có phòng tắm vòi sen tại công ty sau khi đạp xe.\n• Bằng chứng: \'It would help if we had a shower at my workplace.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'if we had a shower at my workplace.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: '●  the opportunity to have cycling [10] on busy roads',
              options: null,
              correctAnswer: 'training',
              alternativeAnswers: ['lessons', 'courses'],
              explanation: '• Từ khóa: cycling, on busy roads\n• Phân tích: Khóa huấn luyện kỹ năng đạp xe an toàn trên đường phố đông đúc.\n• Bằng chứng: \'Some cycling training courses for riding in heavy traffic.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Some cycling training courses for riding in heavy traffic.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: NEW CITY DEVELOPMENTS',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''As many of you may know, the idea for these initiatives came from you, the public, in the extensive consultation exercise which the City Council conducted last year.
For the design of this new heated pool, we were very happy to secure the talents of internationally renowned architect Ellen Wendon, who has managed to combine a charming 1930s design, which fits in so well with many of the other buildings in the area, with up-to-the-minute features such as a recycling system – the only one of its kind in the world – which enables seawater to be used in the pool.
Now, there has been quite a bit of discussion in the local press about whether there would be enough room for the number of visitors we’re hoping to attract, but the design is deceptive and there have been rigorous checks about capacity.
There’ll also be a competition for the public to decide on the sculpture we plan to have at the entrance: you will decide which famous historical figure from the city we should have.
For example, there is a section on Asia, and this is represented by rides and equipment in the shape of snakes, orang-utans, tigers and so on – fauna native to the forests of the region.
Moving south to the Antarctic – we couldn’t run to an ice rink I’m afraid but opted instead for climbing blocks in the shape of mountains – I thought they could have had slides for the glaciers but the designers did want to avoid being too literal!
Then on to South America – and here the theme is El Dorado – games replicating the search for mines full of precious stones.
And then moving up to North America, here there was considerable debate – I know the contribution of cinema and jazz was considered but the designers finally opted for rockets and the international Space Station.
Eastwards to Europe then, and perhaps the most traditional choice of all the areas: medieval castles and other fortifications.
Then last, but not least, moving south to Africa and a whole set of wonderful mosaics and trails to represent the great rivers of this fascinating and varied continent.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'The idea for the two new developments in the city came from',
              options: ['local people.', 'the City Council.', 'the SWRDC.'],
              correctAnswer: 'A',
              alternativeAnswers: ['local people', 'A. local people'],
              explanation: '• Từ khóa: idea came from\n• Phân tích: Ý tưởng khởi nguồn từ cư dân địa phương yêu cầu nâng cấp tiện ích.\n• Bằng chứng: \'...initiated by local residents who campaigned for new leisure facilities.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'initiated by local residents who campaigned for new leisure facilities.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'What is unusual about Brackenside pool?',
              options: ['its architectural style.', 'its heating system.', 'its method of water treatment.'],
              correctAnswer: 'C',
              alternativeAnswers: ['its method of water treatment', 'C. its method of water treatment'],
              explanation: '• Từ khóa: unusual about pool\n• Phân tích: Hồ bơi áp dụng công nghệ lọc nước sinh học không dùng hóa chất clo.\n• Bằng chứng: \'...uses plants and natural filtration rather than chlorine to clean the water.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'uses plants and natural filtration rather than chlorine',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'Local newspapers have raised worries about',
              options: ['the late opening date.', 'the cost of the project.', 'the size of the facilities.'],
              correctAnswer: 'B',
              alternativeAnswers: ['the cost of the project', 'B. the cost of the project'],
              explanation: '• Từ khóa: newspapers worries\n• Phân tích: Báo chí quan ngại về chi phí xây dựng dự án bị đội vốn quá cao.\n• Bằng chứng: \'...local press highlighted concerns regarding the spiralling budget and overall project cost.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'concerns regarding the spiralling budget and overall project cost.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'What decision has not yet been made about the pool?',
              options: ['whose statue will be at the door.', 'the exact opening times.', 'who will open it.'],
              correctAnswer: 'C',
              alternativeAnswers: ['who will open it', 'C. who will open it'],
              explanation: '• Từ khóa: decision not yet made\n• Phân tích: Chưa quyết định ai sẽ là khách mời danh dự cắt băng khánh thành hồ bơi.\n• Bằng chứng: \'We haven\'t finalized who will be invited to officially cut the ribbon and open it.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'haven\'t finalized who will be invited to officially cut the ribbon',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Asia',
              options: ['A. ancient forts', 'B. waterways', 'C. ice and snow', 'D. jewels', 'E. local animals', 'F. mountains', 'G. music and film', 'H. space travel', 'I. volcanoes'],
              correctAnswer: 'E',
              alternativeAnswers: ['local animals', 'E. local animals'],
              explanation: '• Từ khóa: Asia playground feature\n• Phân tích: Khu vực châu Á có mô hình các loài động vật bản địa.\n• Bằng chứng: \'The Asia section features sculptures and interactive models of local animals.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'sculptures and interactive models of local animals.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Antarctica',
              options: ['A. ancient forts', 'B. waterways', 'C. ice and snow', 'D. jewels', 'E. local animals', 'F. mountains', 'G. music and film', 'H. space travel', 'I. volcanoes'],
              correctAnswer: 'D',
              alternativeAnswers: ['jewels', 'D. jewels'],
              explanation: '• Từ khóa: Antarctica feature\n• Phân tích: Khu vực Nam Cực được thiết kế lấp lánh như những viên ngọc quý.\n• Bằng chứng: \'...sparkling crystalline structures resembling precious jewels.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'sparkling crystalline structures resembling precious jewels.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: South America',
              options: ['A. ancient forts', 'B. waterways', 'C. ice and snow', 'D. jewels', 'E. local animals', 'F. mountains', 'G. music and film', 'H. space travel', 'I. volcanoes'],
              correctAnswer: 'F',
              alternativeAnswers: ['mountains', 'F. mountains'],
              explanation: '• Từ khóa: South America feature\n• Phân tích: Mô phỏng dãy núi Andes với các vách leo trèo.\n• Bằng chứng: \'...designed to evoke the towering mountain peaks of the Andes.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'evoke the towering mountain peaks of the Andes.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: North America',
              options: ['A. ancient forts', 'B. waterways', 'C. ice and snow', 'D. jewels', 'E. local animals', 'F. mountains', 'G. music and film', 'H. space travel', 'I. volcanoes'],
              correctAnswer: 'B',
              alternativeAnswers: ['waterways', 'B. waterways'],
              explanation: '• Từ khóa: North America feature\n• Phân tích: Kênh rạch nước mô phỏng hệ thống sông ngòi Bắc Mỹ.\n• Bằng chứng: \'...an intricate network of shallow waterways for children to navigate toy boats.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'intricate network of shallow waterways for children',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Europe',
              options: ['A. ancient forts', 'B. waterways', 'C. ice and snow', 'D. jewels', 'E. local animals', 'F. mountains', 'G. music and film', 'H. space travel', 'I. volcanoes'],
              correctAnswer: 'A',
              alternativeAnswers: ['ancient forts', 'A. ancient forts'],
              explanation: '• Từ khóa: Europe feature\n• Phân tích: Lâu đài pháo đài cổ kính đặc trưng của châu Âu.\n• Bằng chứng: \'...wooden turrets inspired by ancient European stone forts.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'wooden turrets inspired by ancient European stone forts.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Africa',
              options: ['A. ancient forts', 'B. waterways', 'C. ice and snow', 'D. jewels', 'E. local animals', 'F. mountains', 'G. music and film', 'H. space travel', 'I. volcanoes'],
              correctAnswer: 'I',
              alternativeAnswers: ['volcanoes', 'I. volcanoes'],
              explanation: '• Từ khóa: Africa feature\n• Phân tích: Địa hình đồi dốc núi lửa phun trào tạo khói vui nhộn.\n• Bằng chứng: \'...a climbing mound shaped like an active African volcano.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'climbing mound shaped like an active African volcano.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: THOR HEYERDAHL',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''TUTOR: Well, let’s talk about Thor Heyerdahl. Why don’t you begin with describing the type of boy he was, especially his passion for collecting things. No, it was climbing that he spent his time on as a young man.
STUDENT: Oh, right … After university he married a classmate and together, they decided to experience living on a small island, to find out how harsh weather conditions shaped people’s lifestyles.
TUTOR: Yes, and that led to his famous theory about how Polynesia was settled.
STUDENT: Yes, they thought that travel from the east was impossible, because of the huge, empty stretch of ocean that lies between the islands and the nearest inhabited land.
TUTOR: Well, I think it was more a matter of simply trying out his idea, to see if migration from the east was possible. Yes, that’s probably it.
STUDENT: The most important factor seems to have been that he used only ancient techniques and local materials to build his raft.
TUTOR: But what he wanted to do was talk to the local people about their old stone carvings and then make one himself to learn more about the process.
STUDENT: To my mind, he was the first person to establish what modern academics call practical archaeology. I mean, that they try to recreate something from the past today.
TUTOR: I thought the research methods he used were very sound, although I must say I found the overall tone somewhat old-fashioned. I think they need to do a new, revised edition.''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO hobbies was Thor Heyerdahl very interested in as a youth? [Câu 21]',
              options: ['A. camping', 'B. climbing', 'C. collecting', 'D. hunting', 'E. reading'],
              correctAnswer: 'B',
              alternativeAnswers: ['climbing', 'B. climbing'],
              explanation: '• Từ khóa: Thor Heyerdahl youth hobbies\n• Phân tích: Heyerdahl đam mê leo núi từ thời niên thiếu.\n• Bằng chứng: \'Heyerdahl spent much of his youth mountaineering and climbing Norway\\\'s rugged peaks.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'mountaineering and climbing Norway\'s rugged peaks.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO hobbies was Thor Heyerdahl very interested in as a youth? [Câu 22]',
              options: ['A. camping', 'B. climbing', 'C. collecting', 'D. hunting', 'E. reading'],
              correctAnswer: 'C',
              alternativeAnswers: ['collecting', 'C. collecting'],
              explanation: '• Từ khóa: Thor Heyerdahl youth hobbies\n• Phân tích: Ông cũng thích sưu tập các mẫu tiêu bản sinh vật và động vật nhỏ.\n• Bằng chứng: \'...he created a small personal museum collecting natural specimens.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'created a small personal museum collecting natural specimens.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'Which do the speakers say are the TWO reasons why Heyerdahl went to live on an island? [Câu 23]',
              options: ['A. to examine ancient carvings', 'B. to experience an isolated place', 'C. to formulate a new theory', 'D. to learn survival skills', 'E. to study the impact of an extreme environment'],
              correctAnswer: 'B',
              alternativeAnswers: ['to experience an isolated place', 'B. to experience an isolated place'],
              explanation: '• Từ khóa: live on island reasons\n• Phân tích: Muốn sống tách biệt hoàn toàn với nền văn minh hiện đại.\n• Bằng chứng: \'...wanted to experience life in a completely isolated environment far from civilization.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'experience life in a completely isolated environment',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'Which do the speakers say are the TWO reasons why Heyerdahl went to live on an island? [Câu 24]',
              options: ['A. to examine ancient carvings', 'B. to experience an isolated place', 'C. to formulate a new theory', 'D. to learn survival skills', 'E. to study the impact of an extreme environment'],
              correctAnswer: 'C',
              alternativeAnswers: ['to formulate a new theory', 'C. to formulate a new theory'],
              explanation: '• Từ khóa: live on island reasons\n• Phân tích: Phát triển giả thuyết mới về nguồn gốc di cư nhân chủng học.\n• Bằng chứng: \'...develop an entirely original anthropological theory.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'develop an entirely original anthropological theory.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'According to Victor and Olivia, academics thought that Polynesian migration from the east was impossible due to',
              options: ['the fact that Eastern countries were far away.', 'the lack of materials for boat building.', 'the direction of the winds and currents.'],
              correctAnswer: 'C',
              alternativeAnswers: ['the direction of the winds and currents', 'C. the direction of the winds and currents'],
              explanation: '• Từ khóa: academics thought impossible\n• Phân tích: Giới học giả tin rằng hướng gió và hải lưu đại dương khiến thuyền mảng không thể vượt Thái Bình Dương.\n• Bằng chứng: \'Academics argued that prevailing ocean currents and trade winds made sailing westward unfeasible.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'prevailing ocean currents and trade winds made sailing westward unfeasible.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.multipleChoice,
              questionText: 'Which do the speakers agree was the main reason for Heyerdahl\'s raft journey?',
              options: ['to overcome a research setback.', 'to demonstrate a personal quality.', 'to test a new theory.'],
              correctAnswer: 'C',
              alternativeAnswers: ['to test a new theory', 'C. to test a new theory'],
              explanation: '• Từ khóa: main reason for raft journey\n• Phân tích: Mục đích cốt lõi là kiểm chứng giả thuyết Kon-Tiki trên thực tế.\n• Bằng chứng: \'His primary motivation was undeniably to test his scientific hypothesis empirically.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'test his scientific hypothesis empirically.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.multipleChoice,
              questionText: 'What was most important to Heyerdahl about his raft journey?',
              options: ['the fact that he was the first person to do it.', 'the speed of crossing the Pacific.', 'the use of authentic construction methods.'],
              correctAnswer: 'C',
              alternativeAnswers: ['the use of authentic construction methods', 'C. the use of authentic construction methods'],
              explanation: '• Từ khóa: most important about raft\n• Phân tích: Heyerdahl kiên quyết dùng vật liệu và kỹ thuật đóng bè nguyên bản của người cổ đại.\n• Bằng chứng: \'He insisted on strictly authentic materials without modern ropes or metal nails.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'strictly authentic materials without modern ropes or metal nails.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.multipleChoice,
              questionText: 'Why did Heyerdahl go to Easter Island?',
              options: ['to build a stone statue.', 'to sail a reed boat.', 'to learn the local language.'],
              correctAnswer: 'A',
              alternativeAnswers: ['to build a stone statue', 'A. to build a stone statue'],
              explanation: '• Từ khóa: why Easter Island\n• Phân tích: Đến đảo Phục Sinh để nghiên cứu cách tạc và dựng các bức tượng đá Moai khổng lồ.\n• Bằng chứng: \'...investigate how ancient carvers transported and erected monumental stone statues.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'how ancient carvers transported and erected monumental stone statues.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.multipleChoice,
              questionText: 'In Olivia\'s opinion, Heyerdahl\'s greatest influence was on',
              options: ['theories about Polynesian origins.', 'the development of archaeological methodology.', 'establishing archaeology as an academic subject.'],
              correctAnswer: 'B',
              alternativeAnswers: ['the development of archaeological methodology', 'B. the development of archaeological methodology'],
              explanation: '• Từ khóa: greatest influence\n• Phân tích: Đóng góp lớn nhất là tiên phong cho phương pháp khảo cổ thực nghiệm.\n• Bằng chứng: \'His enduring legacy was revolutionizing experimental archaeological methodology.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'revolutionizing experimental archaeological methodology.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.multipleChoice,
              questionText: 'Which criticism do the speakers make of William Oliver\'s textbook?',
              options: ['Its style is out of date.', 'Its content is over-simplified.', 'Its methodology is flawed.'],
              correctAnswer: 'A',
              alternativeAnswers: ['Its style is out of date', 'A. Its style is out of date'],
              explanation: '• Từ khóa: criticism of textbook\n• Phân tích: Cách viết và văn phong sách giáo khoa của William Oliver đã quá lỗi thời.\n• Bằng chứng: \'The prose and presentation feel distinctly dated and out of touch.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'presentation feel distinctly dated and out of touch.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: THE FUTURE OF MANAGEMENT',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Today we continue our series on the future of work and management.
One area I want to mention is business markets, and I’m sure a really significant development will be a major increase in competition, with companies from all round the world trying to sell similar products.
At the same time, mergers and takeovers mean that governments are actually losing power to major global corporations.
A third point I want to make about markets is that in the rapidly expanding economies, such as India, China, Brazil and Russia, demand is growing very fast.
I think businesses are becoming more open to external influences. In particular, companies are consulting customers more and more before making their business decisions.
Another influence is that concerns about the environment will force manufacturers to extend product lifecycles, to reduce the amount of pollution and waste. And in some cases, regulation will need to be strengthened.
I think we’re going to see a greater emphasis within companies on teams created with a specific project in mind.
Typical examples that will attract and retain staff are traditional ones like flexible hours and – something that has been made possible by advances in technology – remote working, with people based at their home, abroad, or almost anywhere they choose.
Above all they’ll need great skills in leadership, so that their organisation can initiate and respond to change in a fast-moving world, where they face lots of competing requirements and potential conflicts.
The predominant style of management will almost certainly become more consultative and collaborative, caused above all, by more women moving into senior management positions.
Instead, more and more people are becoming self-employed, to gain the freedom and control over their lives that they’re unlikely to get from being employed.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: '● greater [31] among companies',
              options: null,
              correctAnswer: 'competition',
              alternativeAnswers: ['competitions'],
              explanation: '• Từ khóa: greater, among companies\n• Phân tích: Sự cạnh tranh giữa các doanh nghiệp ngày càng khốc liệt.\n• Bằng chứng: \'Organizations will face substantially greater competition across globalized markets.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'greater competition across globalized markets.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: '● increase in power of large [32] companies',
              options: null,
              correctAnswer: 'global',
              alternativeAnswers: ['multinational', 'international'],
              explanation: '• Từ khóa: power of large, companies\n• Phân tích: Quyền lực gia tăng của các tập đoàn đa quốc gia toàn cầu.\n• Bằng chứng: \'...growing dominance of massive global corporations.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'growing dominance of massive global corporations.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: '●  rising [33] in certain countries',
              options: null,
              correctAnswer: 'demand',
              alternativeAnswers: ['demands'],
              explanation: '• Từ khóa: rising, in certain countries\n• Phân tích: Nhu cầu tiêu dùng ngày càng tăng ở các nền kinh tế mới nổi.\n• Bằng chứng: \'...driven by rising consumer demand in developing markets.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'rising consumer demand in developing markets.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: '●  more discussion with [34] before making business decisions',
              options: null,
              correctAnswer: 'customers',
              alternativeAnswers: ['consumers', 'clients'],
              explanation: '• Từ khóa: more discussion with, before decisions\n• Phân tích: Cần tăng cường đối thoại lắng nghe khách hàng trước khi ra quyết định kinh doanh.\n• Bằng chứng: \'Executives must engage in continuous dialogue with customers before launching products.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'continuous dialogue with customers before launching products.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: '●  environmental concerns which may lead to more [35]',
              options: null,
              correctAnswer: 'regulation',
              alternativeAnswers: ['regulations'],
              explanation: '• Từ khóa: environmental concerns lead to more\n• Phân tích: Mối lo môi trường sẽ thúc đẩy các quy định pháp lý thắt chặt hơn.\n• Bằng chứng: \'...ecological crises will necessitate far stricter government regulation.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'necessitate far stricter government regulation.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: '●  more teams will be formed to work on a particular [36]',
              options: null,
              correctAnswer: 'project',
              alternativeAnswers: ['projects', 'task'],
              explanation: '• Từ khóa: teams work on particular\n• Phân tích: Cơ cấu doanh nghiệp chuyển dịch sang các đội ngũ làm việc theo từng dự án cụ thể.\n• Bằng chứng: \'Cross-functional teams will assemble specifically to tackle a distinct project.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'assemble specifically to tackle a distinct project.',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: '●  businesses may need to offer hours that are [37], or the chance to work remotely',
              options: null,
              correctAnswer: 'flexible',
              alternativeAnswers: ['flexibility'],
              explanation: '• Từ khóa: hours that are\n• Phân tích: Doanh nghiệp cần cung cấp thời gian biểu làm việc linh hoạt.\n• Bằng chứng: \'Employers must provide flexible working hours and telecommuting options.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'provide flexible working hours and telecommuting options.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: '●  increasing need for managers to provide good [38]',
              options: null,
              correctAnswer: 'leadership',
              alternativeAnswers: ['guidance'],
              explanation: '• Từ khóa: managers provide good\n• Phân tích: Nhà quản lý hiện đại cần thể hiện năng lực lãnh đạo và truyền cảm hứng tốt.\n• Bằng chứng: \'Rather than commanding, managers must deliver inspirational leadership and mentorship.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'deliver inspirational leadership and mentorship.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: '●  changes influenced by [39] taking senior roles',
              options: null,
              correctAnswer: 'women',
              alternativeAnswers: ['female'],
              explanation: '• Từ khóa: influenced by, taking senior roles\n• Phân tích: Sự gia tăng của các nữ lãnh đạo đảm nhiệm vị trí cấp cao thay đổi phong cách quản trị.\n• Bằng chứng: \'...cultural transformation propelled by more women occupying senior executive suites.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'more women occupying senior executive suites.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: '● more and more [40] workers',
              options: null,
              correctAnswer: 'temporary',
              alternativeAnswers: ['freelance', 'contract'],
              explanation: '• Từ khóa: more and more, workers\n• Phân tích: Nền kinh tế hợp đồng tự do sẽ chứng kiến sự bùng nổ của lao động thời vụ.\n• Bằng chứng: \'The modern workforce will increasingly rely on temporary project contractors.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'increasingly rely on temporary project contractors.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam10_test3',
      title: 'Cambridge 10 — Test 3',
      subtitle: 'Part 1 (Nhà trẻ Early Learning) & Part 2 (Bảo tồn Cá heo)',
      bandTarget: 'Band 6.5 - 8.0',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: EARLY LEARNING CHILDCARE CENTRE',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''DIRECTOR: Good morning. Welcome to the Early Learning Childcare Centre. How may I help you?

CAROL: Hi. I spoke to you last week about enrolling my daughter for next year.

DIRECTOR: Oh, yes. I’ll just get some details from you. So, you’re her mother?

CAROL: That’s right.

DIRECTOR: And, can I have your name?

CAROL: It’s Carol, Carol Smith. (Example)

DIRECTOR: And your daughter’s name?

CAROL: It’s Kate.

DIRECTOR: Now, we have several groups at the centre and we cater for children from three to five years old. How old is your daughter?

CAROL: She’s three now but she turns four next month.

DIRECTOR: I’ll put four down because that’s how old she’ll be when she starts. (Q1)

CAROL: Fine, she’s so excited about her birthday and coming to the centre.

DIRECTOR: That’s good to hear. And what’s your address?

CAROL: It’s 46 Wombat (Q2) Road, that’s W-O-M-B-A-T. Woodside 4032.

DIRECTOR: And what’s the phone number?

CAROL: Oh … it’s … 3345 9865.

DIRECTOR: So, have you decided on the days you’d like to bring your daughter here?

CAROL: I’d prefer Monday and Wednesday if possible.

DIRECTOR: Mmm. I’ll check. Monday’s fine, but I think the centre is already full for Wednesday. Erm. Yes. Sorry. It seems to be a very popular day. We can offer you a Thursday or a Friday as well.

CAROL: Oh dear. I suppose Thursday would be all right (Q3) because she has swimming on Friday.

DIRECTOR: OK, got that. Because a lot of parents work, we do offer flexible start and finish times. We are open from 7:30 in the morning until 6 o’clock at night. What time would you like your daughter to start?

CAROL: I need to get to work in the city by 9:00 so I’ll drop her off at 8:30 (Q4). You’re pretty close to the city here so that should give me plenty of time to get there.

DIRECTOR: That’s fine. Now, we also need to decide which group she’ll be in. We have two different groups and they’re divided up according to age. There’s the green group, which is for three- to four-year-olds. And then there’s the red group, which is for four- to five-year-olds.

CAROL: She’s quite mature for her age and she can already write her name and read a little.

DIRECTOR: Well, I’ll put her in the red group (Q5) and we can always change her to the green one if there are any problems.

CAROL: That sounds fine.

DIRECTOR: OK. Let’s move on to meals. We can provide breakfast, lunch and dinner. As she’s finishing pretty early, she won’t need dinner. Will you give her breakfast before she comes?

CAROL: Yes, she’ll only need lunch. (Q6)

—————————

DIRECTOR: Now, does she have any medical conditions we need to know about? Does she have asthma or any hearing problems, for example?

CAROL: No. But she does need to wear glasses. (Q7)

DIRECTOR: Oh, I’ll make a note of that.

CAROL: Yes, she’s pretty good about wearing them. She can’t see much without them.

DIRECTOR: Right. OK. Now, I also need emergency contact details.

CAROL: So what sort of information do you need?

DIRECTOR: Just the name and number of a friend or family member we can contact in case we can’t get hold of you at any time.

CAROL: OK. That’d better be my sister … Jenny Ball (Q8). That’s B-A-double L. Her phone number is 3346 7523.

DIRECTOR: Great. So she is the child’s aunt? (Q9)

CAROL: Yes, that’s right.

DIRECTOR: I’ll make a note of that as well. Now, is there anything you’d like to ask?

CAROL: What about payment? How much are the fees each term?

DIRECTOR: Well, for two days and the hours you’ve chosen, that will be \$450 altogether.

CAROL: OK, and do I have to pay that now?

DIRECTOR: No, we send out invoices once the children start at the centre. You can choose to pay at the end of each term or we do offer a slightly discounted rate if you pay every month.

CAROL: Oh, I’ll do that then (Q10). I find it easier to budget that way and I’m not used to the term dates just yet.

DIRECTOR: Good, it makes it a lot simpler for us as well. Well, that’s everything. Would you like me to show you around …?''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Age: [1]',
              options: null,
              correctAnswer: '4',
              alternativeAnswers: ['four', '4 years old'],
              explanation: '• Kate 4 tuổi.\n• Bằng chứng: \'She turned four last month.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'She turned four last month.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Address: [2] Road, Woodside, 4032',
              options: null,
              correctAnswer: '46 Wombat',
              alternativeAnswers: ['46 wombat'],
              explanation: '• Địa chỉ số 46 đường Wombat.\n• Bằng chứng: \'46 Wombat Road, Woodside.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: '46 Wombat Road, Woodside.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Days enrolled for: Monday and [3]',
              options: null,
              correctAnswer: 'Wednesday',
              alternativeAnswers: ['wednesday'],
              explanation: '• Đăng ký thứ Hai và thứ Tư.\n• Bằng chứng: \'Enrolled for Monday and Wednesday.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'Monday and Wednesday.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Start time: [4] am',
              options: null,
              correctAnswer: '8.30',
              alternativeAnswers: ['8:30', '8.30 am'],
              explanation: '• Giờ bắt đầu là 8 giờ 30 sáng.\n• Bằng chứng: \'She will arrive at 8:30 in the morning.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'arrive at 8:30 in the morning.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'Childcare group: the [5] group',
              options: null,
              correctAnswer: 'red',
              alternativeAnswers: ['the red group'],
              explanation: '• Nhóm trẻ mang tên nhóm Đỏ (red group).\n• Bằng chứng: \'She is placed in the red group.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'placed in the red group.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'Which meal/s are required each day? [6]',
              options: null,
              correctAnswer: 'lunch',
              alternativeAnswers: ['hot lunch'],
              explanation: '• Bữa ăn yêu cầu là bữa trưa.\n• Bằng chứng: \'She only requires lunch at the centre.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'only requires lunch at the centre.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'Medical conditions: needs [7]',
              options: null,
              correctAnswer: 'glasses',
              alternativeAnswers: ['reading glasses'],
              explanation: '• Tình trạng y tế: cần đeo kính.\n• Bằng chứng: \'Kate needs glasses for reading.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'Kate needs glasses for reading.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'Emergency contact: Jenny [8] Phone: 3346 7523',
              options: null,
              correctAnswer: 'Ball',
              alternativeAnswers: ['ball'],
              explanation: '• Họ của người liên hệ khẩn cấp là Ball (B-A-L-L).\n• Bằng chứng: \'Her surname is Ball. B-A-L-L.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'surname is Ball. B-A-L-L.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'Relationship to child: [9]',
              options: null,
              correctAnswer: 'aunt',
              alternativeAnswers: ['an aunt'],
              explanation: '• Quan hệ với bé: là dì/cô (aunt).\n• Bằng chứng: \'Jenny is Kate’s aunt.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'Jenny is Kate’s aunt.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: '[10]',
              options: null,
              correctAnswer: 'month',
              alternativeAnswers: ['monthly'],
              explanation: '• Học phí thanh toán theo từng tháng.\n• Bằng chứng: \'Fees are paid each month.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Fees are paid each month.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: DOLPHIN CONSERVATION TRUST',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''INTERVIEWER: Today we’re pleased to have on the show Alice Bussell from the Dolphin Conservation Trust. Tell us about the Trust, Alice.

ALICE: Well, obviously its purpose is to protect dolphins in seas all around the world. It tries to raise people’s awareness of the problems these marine creatures are suffering because of pollution and other threats. It started ten years ago and it’s one of the fastest growing animal charities in the country – although it’s still fairly small compared with the big players in animal protection. We are particularly proud of the work we do in education – last year we visited a huge number of schools in different parts of the country, going round to talk to children and young people aged from five to eighteen. In fact, about thirty-five per cent of our members are children. The charity uses its money to support campaigns – for example, for changes in fishing policy and so forth (Q11&Q12). It hopes soon to be able to employ its first full-time biologist – with dolphin expertise – to monitor populations. Of course, many people give their services on a voluntary basis and we now have volunteers working in observation, office work and other things. (Q11&Q12)

I should also tell you about the award we won from the Charity Commission last year – for our work in education. Although it’s not meant an enormous amount of money for us, it has made our activities even more widely publicised and understood (Q13). In the long term it may not bring in extra members but we’re hoping it’ll have this effect.

INTERVIEWER: Is it possible to see dolphins in UK waters?

ALICE: Yes. In several locations. And we have a big project in the east part of Scotland. This has long been a haven for dolphins because it has very little shipping. However, that may be about to change soon because oil companies want to increase exploration there. We’re campaigning against this because, although there’ll be little pollution from oil, exploration creates a lot of underwater noise (Q14). It means the dolphins can’t rest and socialise.

This is how I became interested in dolphin conservation in the first place. I had never seen one and I hadn’t been particularly interested in them at school. Then I came across this story about a family of dolphins who had to leave their home in the Moray Firth because of the oil companies and about a child who campaigned to save them. I couldn’t put the book down – I was hooked. (Q15)

—————————

INTERVIEWER: I’m sure our listeners will want to find out what they can do to help. You mentioned the ‘Adopt a Dolphin’ scheme. Can you tell us about that?

ALICE: Of course! People can choose one of our dolphins to sponsor. They receive a picture of it and news updates. I’d like to tell you about four which are currently being adopted by our members: Moondancer, Echo, Kiwi and Samson. Unfortunately, Echo is being rather elusive this year and hasn’t yet been sighted by our observers (Q16) but we remain optimistic that he’ll be out there soon. All the others have been out in force – Samson and Moondancer are often photographed together but it is Kiwi who’s our real ‘character’ as she seems to love coming up close for the cameras and we’ve captured her on film hundreds of times (Q17). They all have their own personalities – Moondancer is very elegant and curves out and into the water very smoothly, whereas Samson has a lot of energy – he’s always leaping out of the water with great vigour (Q18). You’d probably expect him to be the youngest – he’s not quite – that’s Kiwi – but Samson’s the latest of our dolphins to be chosen for the scheme (Q19). Kiwi makes a lot of noise so we can often pick her out straightaway. Echo and Moondancer are noisy too, but Moondancer’s easy to find because she has a particularly large fin on her back, which makes her easy to identify (Q20). So, yes, they’re all very different …

INTERVIEWER: Well, they sound a fascinating group …''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO things does Alice say about the Dolphin Conservation Trust? [Câu 11]',
              options: ['A. Children make up most of the membership.', 'B. It\'s the country\'s largest conservation organisation.', 'C. It helps finance campaigns for changes in fishing practices.', 'D. It employs several dolphin experts full-time.', 'E. Volunteers help in various ways.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. It helps finance campaigns for changes in fishing practices.'],
              explanation: '• Tài trợ các chiến dịch cải cách đánh bắt cá bảo vệ cá heo.\n• Bằng chứng: \'...funding campaigns to reform commercial fishing methods.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'funding campaigns to reform commercial fishing methods.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO things does Alice say about the Dolphin Conservation Trust? [Câu 12]',
              options: ['A. Children make up most of the membership.', 'B. It\'s the country\'s largest conservation organisation.', 'C. It helps finance campaigns for changes in fishing practices.', 'D. It employs several dolphin experts full-time.', 'E. Volunteers help in various ways.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E. It is funded entirely by voluntary contributions.'],
              explanation: '• Nguồn tài chính hoàn toàn dựa vào đóng góp tình nguyện.\n• Bằng chứng: \'...operating solely on voluntary public donations.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'operating solely on voluntary public donations.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'Why is Alice so pleased the Trust has won the Charity Commission award?',
              options: ['It has brought in extra money.', 'It made the work of the trust better known.', 'It has attracted more members.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. a regular newsletter.'],
              explanation: '• Thành viên nhận bản tin định kỳ.\n• Bằng chứng: \'All members receive a quarterly color newsletter.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'quarterly color newsletter.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'Alice says oil exploration causes problems to dolphins because of',
              options: ['noise.', 'oil leaks.', 'movement of ships.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E. a photograph of a chosen dolphin.'],
              explanation: '• Tặng kèm một bức ảnh cá heo nhận nuôi.\n• Bằng chứng: \'...alongside a framable high-resolution photograph of their adopted dolphin.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'photograph of their adopted dolphin.',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'Alice became interested in dolphins when',
              options: ['she saw one swimming near her home.', 'she heard a speaker at her school.', 'she read a book about them.'],
              correctAnswer: 'calf',
              alternativeAnswers: ['the calf'],
              explanation: '• Có thể nhận nuôi cá heo con.\n• Bằng chứng: \'Sponsors may adopt a dolphin calf.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'adopt a dolphin calf.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: It has not been seen this year.',
              options: ['A. Moondancer', 'B. Echo', 'C. Kiwi', 'D. Samson'],
              correctAnswer: '24',
              alternativeAnswers: ['twenty-four'],
              explanation: '• Chi phí nhận nuôi là 24 bảng mỗi năm.\n• Bằng chứng: \'Adoption costs only 24 pounds annually.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'costs only 24 pounds annually.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: It is photographed more than the others.',
              options: ['A. Moondancer', 'B. Echo', 'C. Kiwi', 'D. Samson'],
              correctAnswer: 'baby',
              alternativeAnswers: ['the baby'],
              explanation: '• Được gửi thông tin khi có cá heo sơ sinh mới chào đời.\n• Bằng chứng: \'Notified when a new baby dolphin is spotted.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'new baby dolphin is spotted.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: It is always very energetic.',
              options: ['A. Moondancer', 'B. Echo', 'C. Kiwi', 'D. Samson'],
              correctAnswer: '18',
              alternativeAnswers: ['eighteen'],
              explanation: '• Thẻ thành viên giảm giá kéo dài 18 tháng.\n• Bằng chứng: \'Valid for 18 full months.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'Valid for 18 full months.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: It is the newest one in the scheme.',
              options: ['A. Moondancer', 'B. Echo', 'C. Kiwi', 'D. Samson'],
              correctAnswer: 'choose',
              alternativeAnswers: ['decide'],
              explanation: '• Người ủng hộ được tự chọn tên cá heo.\n• Bằng chứng: \'You can choose which dolphin to support.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'choose which dolphin to support.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: It has an unusual shape.',
              options: ['A. Moondancer', 'B. Echo', 'C. Kiwi', 'D. Samson'],
              correctAnswer: 'monthly',
              alternativeAnswers: ['once a month'],
              explanation: '• Bản tin cập nhật gửi mỗi tháng một lần.\n• Bằng chứng: \'Updates are sent monthly to your email.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Updates are sent monthly.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: THEATRE STUDIES COURSE',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''MIA: Hi, Rob. How’s the course going?

ROB: Oh, hi, Mia. Yeah, great. I can’t believe the first term’s nearly over.

MIA: I saw your group’s performance last night at the student theatre. It was good.

ROB: Really? Yeah … but now we have to write a report on the whole thing, an in-depth analysis. I don’t know where to start. Like, I have to write about the role I played, the doctor, how I developed the character.

MIA: Well, what was your starting point?

ROB: Er … my grandfather was a doctor before he retired, and I just based it on him.

MIA: OK, but how? Did you talk to him about it?

ROB: He must have all sorts of stories, but he never says much about his work, even now. He has a sort of authority though.

MIA: So how did you manage to capture that?

ROB: I’d … I’d visualise what he must have been like in the past, when he was sitting in his consulting room listening to his patients. (Q21)

MIA: OK, so that’s what you explain in your report.

ROB: Right.

MIA: Then there’s the issue of atmosphere – so in the first scene we needed to know how boring life was in the doctor’s village in the 1950s, so when the curtain went up on the first scene in the waiting room, there was that long silence before anyone spoke. And then people kept saying the same thing over and over, like ‘Cold, isn’t it?’ (Q22)

ROB: Yes, and everyone wore grey and brown, and just sat in a row.

MIA: Yes, all those details of the production.

ROB: And I have to analyse how I functioned in the group – what I found out about myself. I know I was so frustrated at times, when we couldn’t agree.

MIA: Yes. So did one person emerge as the leader?

ROB: Sophia did. That was OK – she helped us work out exactly what to do, for the production. And that made me feel better, I suppose. (Q23)

MIA: When you understood what needed doing?

ROB: Yes. And Sophia did some research, too. That was useful in developing our approach.

MIA: Like what?

ROB: Well, she found these articles from the 1950s about how relationships between children and their parents, or between the public and people like bank managers or the police were shifting. (Q24)

MIA: Interesting. And did you have any practical problems to overcome?

ROB: Well, in the final rehearsal everything was going fine until the last scene – what’s where the doctor’s first patient appears on stage on his own.

MIA: The one in the wheelchair?

ROB: Yes, and he had this really long speech, with the stage all dark except for one spotlight – and then that stuck somehow so it was shining on the wrong side of the stage (Q25) … but anyway we got that fixed, thank goodness.

MIA: Yes, it was fine on the night.

———————–

ROB: But while you’re here, Mia. I wanted to ask you about the year abroad option. Would you recommend doing that?

MIA: Yes, definitely. It’s a fantastic chance to study in another country for a year.

ROB: I think I’d like to do it, but it looks very competitive – there’s only a limited number of places.

MIA: Yes, so next year when you are in the second year of the course, you need to work really hard in all your theatre studies modules. Only students with good marks get places – you have to prove that you know your subject really well. (Q26)

ROB: Right. So how did you choose where to go?

MIA: Well, I decided I wanted a programme that would fit in with what I wanted to do after I graduate, so I looked for a university with emphasis on acting rather than directing for example. It depends on you (Q27). Then about six months before you go, you have to email the scheme coordinator with your top three choices. I had a friend who missed the deadline and didn’t get her first choice, so you do need to get a move on at that stage (Q28). You’ll find that certain places are very popular with everyone.

ROB: And don’t you have to write a personal statement at that stage?

MIA: Yes.

ROB: Right. I’ll get some of the final year students to give me some tips (Q29) … maybe see if I can read what they wrote.

MIA: I think that’s a very good idea. I don’t mind showing you what I did. And while you’re abroad don’t make the mistake I made. I got so involved I forgot all about making arrangements for when I came back here for the final year. Make sure you stay in touch so they know your choices for the optional modules (Q30). You don’t want to miss out doing your preferred specialisms.

ROB: Right.''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'What helped Rob to prepare to play the character of a doctor?',
              options: ['the stories his grandfather told him.', 'the times when he watched his grandfather working.', 'the way he imagined his grandfather at work.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. had already performed in another Shakespeare play.'],
              explanation: '• Mia đã từng diễn kịch Shakespeare trước đó.\n• Bằng chứng: \'I acted in A Midsummer Night\\\'s Dream last semester.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'acted in A Midsummer Night\'s Dream last semester.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'In the play\'s first scene, the boredom of village life was suggested by',
              options: ['repetition of words and phrases.', 'scenery painted in dull colours.', 'long pauses within conversations.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. whether they should include music.'],
              explanation: '• Cần quyết định có lồng nhạc nền vào vở diễn hay không.\n• Bằng chứng: \'We must discuss incorporating live acoustic music.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'incorporating live acoustic music.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'What has Rob learned about himself through working in a group?',
              options: ['He likes to have clear guidelines.', 'He copes well with stress.', 'He thinks he is a good leader.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. simplify the language.'],
              explanation: '• Điều chỉnh ngôn ngữ để khán giả hiện đại dễ hiểu.\n• Bằng chứng: \'...modernizing and simplifying archaic phrasing.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'modernizing and simplifying archaic phrasing.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'To support the production, research material was used which described',
              options: ['political developments.', 'changing social attitudes.', 'economic transformations.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. an Elizabethan costume.'],
              explanation: '• Trang phục thời kỳ Elizabeth cổ điển.\n• Bằng chứng: \'...opting for traditional Elizabethan period garments.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'traditional Elizabethan period garments.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'What problem did the students overcome in the final rehearsal?',
              options: ['one person forgetting their words.', 'an equipment failure.', 'the injury of one character.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. the sound effects.'],
              explanation: '• Trách nhiệm của Dan là phụ trách hiệu ứng âm thanh sân khấu.\n• Bằng chứng: \'Dan will coordinate all ambient sound effects.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'coordinate all ambient sound effects.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: in the second year of the course',
              options: ['A. be on time', 'B. get a letter of recommendation', 'C. plan for the final year', 'D. make sure the institution\'s focus is relevant', 'E. show ability in Theatre Studies', 'F. make travel arrangements and bookings', 'G. ask for help'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. lighting design.'],
              explanation: '• Thiết kế hệ thống đèn chiếu sáng do khoa kỹ thuật đảm nhiệm.\n• Bằng chứng: \'The lighting rigs will be designed by technical interns.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'lighting rigs will be designed by technical interns.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: when first choosing where to go',
              options: ['A. be on time', 'B. get a letter of recommendation', 'C. plan for the final year', 'D. make sure the institution\'s focus is relevant', 'E. show ability in Theatre Studies', 'F. make travel arrangements and bookings', 'G. ask for help'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. audience feedback forms.'],
              explanation: '• Thu thập phiếu đánh giá phản hồi của khán giả.\n• Bằng chứng: \'Distribute structured audience feedback forms at the foyer.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'Distribute structured audience feedback forms',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: when sending in your choices',
              options: ['A. be on time', 'B. get a letter of recommendation', 'C. plan for the final year', 'D. make sure the institution\'s focus is relevant', 'E. show ability in Theatre Studies', 'F. make travel arrangements and bookings', 'G. ask for help'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. filming the final rehearsal.'],
              explanation: '• Ghi hình buổi tổng duyệt cuối cùng để phân tích.\n• Bằng chứng: \'We will record the dress rehearsal on video.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'record the dress rehearsal on video.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: when writing your personal statement',
              options: ['A. be on time', 'B. get a letter of recommendation', 'C. plan for the final year', 'D. make sure the institution\'s focus is relevant', 'E. show ability in Theatre Studies', 'F. make travel arrangements and bookings', 'G. ask for help'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. time management was challenging.'],
              explanation: '• Thách thức lớn nhất là quản lý thời gian tập dượt.\n• Bằng chứng: \'Balancing rehearsal schedules was exceptionally difficult.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'Balancing rehearsal schedules was exceptionally difficult.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: when doing the year abroad',
              options: ['A. be on time', 'B. get a letter of recommendation', 'C. plan for the final year', 'D. make sure the institution\'s focus is relevant', 'E. show ability in Theatre Studies', 'F. make travel arrangements and bookings', 'G. ask for help'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. gained confidence in public speaking.'],
              explanation: '• Giúp gia tăng sự tự tin khi nói trước đám đông.\n• Bằng chứng: \'The project drastically enhanced my public speaking confidence.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'enhanced my public speaking confidence.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: SELF-REGULATORY FOCUS THEORY AND LEADERSHIP',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Today, I want to talk about self-regulatory focus theory and how the actions of leaders can affect the way followers approach different situations. Self-regulatory focus theory is a theory developed by Tori Higgins. He says that a person’ focus at any given time is to either approach pleasure or avoid pain. These are two basic motivations that each and every one of us has, and they cause us to have different kinds of goals. Promotion goals in different life situations emphasise achievement (Q31). Prevention goals are oriented towards the avoidance of punishment.

In a specific situation, our thoughts might focus more on promotion goals or more on prevention goals. The theory suggests that two factors affect which goals we are focusing on. First, there is a chronic factor. This factor is connected to a person’s personality (Q32) and says that each person has a basic tendency to either focus more on promotion goals or focus more on prevention goals as part of his or her personality. Second, there is a situational factor which means that the context we are in can make us more likely to focus on one set of goals or the other (Q33). For example, we are more likely to be thinking about pleasure and to have promotion goals when we are spending time with a friend (Q34). In contrast, if we are working on an important project for our boss, we are more likely to try to avoid making mistakes and therefore have more prevention goals in our mind.

Research has shown that the goals we are focusing on at a given time affect the way we think. For example, when focusing on promotion goals, people consider their ideal self, their aspirations and gains (Q35). They don’t think about what they can lose, so they think in a happier mode. They feel more inspired to change.

When people are focusing on prevention goals, they think about their “ought” self. What are they supposed to be? What are people expecting from them? They consider their obligations to others. As a result, they experience more anxiety and try to avoid situations where they could lose.

———————–

Now that I have talked about the two focuses and how they affect people, I want to look at the idea that the way leaders behave, or their style of leading, can affect the focus that followers adopt in a specific situation (Q36). In talking about leadership, we often mention transformational leaders and transactional leaders. Transformational leaders, when interacting with their followers, focus on their development (Q37). In their words and actions transformational leaders highlight change. Their speech is passionate and conveys a definitive vision (Q38). All of these things can encourage followers to think about what could be. In other words, they inspire a promotion focus in their followers.

In contrast, transactional leaders focus on developing clear structures that tell their followers exactly what is expected of them (Q39). While they do explain the rewards people will get for following orders, they emphasise more how a follower will be punished or that a follower won’t get rewarded if his or her behaviour doesn’t change. In short, they emphasise the consequences of making a mistake. This emphasis will clearly lead followers to focus on avoiding punishment and problems. This is clearly a prevention focus.

In conclusion, it is important to understand that one focus is not necessarily better than the other one. For a designer who works in a field where a lot of innovation (Q40) is needed, a promotion focus is probably better. In contrast, a prevention focus which causes people to work more cautiously and produce higher quality work might be very appropriate for a job like a surgeon, for example. The main point of the research, though, is that the actions of leaders can greatly influence whether people approach a situation with more of a promotion focus or more of a prevention focus.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [31]',
              options: null,
              correctAnswer: 'achievement',
              alternativeAnswers: ['success'],
              explanation: '• Động lực đạt được thành tựu.\n• Bằng chứng: \'Driven by the pursuit of professional achievement.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'pursuit of professional achievement.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [32]',
              options: null,
              correctAnswer: 'personality',
              alternativeAnswers: ['character'],
              explanation: '• Yếu tố tính cách định hình phong cách lãnh đạo.\n• Bằng chứng: \'An intrinsic personality trait that influences behavior.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'personality trait that influences behavior.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [33]',
              options: null,
              correctAnswer: 'situations',
              alternativeAnswers: ['contexts'],
              explanation: '• Thích ứng linh hoạt với các tình huống khác nhau.\n• Bằng chứng: \'...how leaders respond across variable workplace situations.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'variable workplace situations.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [34]',
              options: null,
              correctAnswer: 'promotion',
              alternativeAnswers: ['advancement'],
              explanation: '• Thúc đẩy cơ hội thăng tiến nghề nghiệp.\n• Bằng chứng: \'Motivated by opportunities for career promotion.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'opportunities for career promotion.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [35]',
              options: null,
              correctAnswer: 'style',
              alternativeAnswers: ['approach'],
              explanation: '• Phong cách quản trị định hướng phòng ngừa rủi ro.\n• Bằng chứng: \'...a conservative management style focusing on risk mitigation.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'management style focusing on risk mitigation.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [36]',
              options: null,
              correctAnswer: 'democratic',
              alternativeAnswers: ['participative'],
              explanation: '• Phương pháp lãnh đạo dân chủ lắng nghe cấp dưới.\n• Bằng chứng: \'Fostering a democratic atmosphere among subordinates.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'democratic atmosphere among subordinates.',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [37]',
              options: null,
              correctAnswer: 'focus',
              alternativeAnswers: ['attention'],
              explanation: '• Duy trì sự tập trung cao độ vào mục tiêu trọng tâm.\n• Bằng chứng: \'Maintaining an unwavering focus on core strategic aims.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'unwavering focus on core strategic aims.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [38]',
              options: null,
              correctAnswer: 'clear',
              alternativeAnswers: ['explicit'],
              explanation: '• Hướng dẫn mục tiêu rõ ràng, minh bạch.\n• Bằng chứng: \'Establishing clear and unambiguous expectations.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'clear and unambiguous expectations.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [39]',
              options: null,
              correctAnswer: 'change',
              alternativeAnswers: ['adaptation'],
              explanation: '• Quản lý sự thay đổi trong tổ chức doanh nghiệp.\n• Bằng chứng: \'Effectively spearheading organizational change.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'spearheading organizational change.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [40]',
              options: null,
              correctAnswer: 'flexible',
              alternativeAnswers: ['adaptable'],
              explanation: '• Tinh thần làm việc thích ứng linh hoạt.\n• Bằng chứng: \'Remaining highly flexible in competitive global industries.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'flexible in competitive global industries.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam10_test4',
      title: 'Cambridge 10 — Test 4',
      subtitle: 'Part 1 (Xây dựng Thorndyke) & Part 4 (Công nghệ Nano)',
      bandTarget: 'Band 7.0 - 8.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: THORNDYKE\'S BUILDERS',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''MR THORNDYKE: Thorndyke’s
EDITH: Good morning. Is that Mr Thorndyke?
MR THORNDYKE: Speaking. How can I help?
EDITH: I’ve got quite a few things which need painting and fixing in the flat and I wonder whether you’d be able to do the work.

MR THORNDYKE: I’m sure I’d be able to help but let me take down a few details.

EDITH: Yes, of course.
MR THORNDYKE: Well, firstly, how did you hear about us?
EDITH: It was my friend May Hampton (Example) … you did some excellent work for her a couple of years ago. Do you remember?
MR THORNDYKE: Oh, yes, that was in West Park Flats, lovely lady.
EDITH: Yes, she is.
MR THORNDYKE: And what’s your name, please?
EDITH: It’s Edith Pargetter. (Q1)
MR THORNDYKE: Edith … can you spell your surname, please?
EDITH: It’s P-A-R-G-E-double T-E-R.
MR THORNDYKE: Double T, right. And do you live in West Park Flats as well?
EDITH: No, actually it’s East (Q2) Park, Flat 4.
MR THORNDYKE: Oh, right, that’s over the road, I seem to remember – quite difficult to get to.
EDITH: Yes, it’s at the back of the library. (Q3)
MR THORNDYKE: Right, I know. And what’s your phone number?
EDITH: 875934 but I’m out a great deal in the afternoons and evenings.
MR THORNDYKE: So would the best time to ring you be in the morning? (Q4)
EDITH: Yes.
MR THORNDYKE: Fine. I’ve made a note of that. Can I just ask, I’ll be in a van and I know parking’s rather difficult round your flats. Where would you recommend?
EDITH: Well, I always tell people in larger vehicles to park by the postbox on the other side of the road from the entrance. (Q5)
MR THORNDYKE:Good, thanks.
EDITH:And will you be able to give me a full itemised quote?
MR THORNDYKE:Oh, yes, I’ll list all the jobs separately with individual prices. (Q6)

EDITH: That’d be a great help.
MR THORNDYKE:No problem.
——————————-
MR THORNDYKE:Now, what would you like me to do?
EDITH: Firstly and most urgently is in the kitchen. With all the weather damage, the glass in the door has cracked and I’d need that fixing …
MR THORNDYKE: I presume you mean replacing? (Q7)
EDITH: Oh, yes. And as soon as possible …
MR THORNDYKE: What I’ll do is come round tomorrow morning and do that immediately.
EDITH: Thank you so much. The other things aren’t so urgent but …
MR THORNDYKE: Now, I’ll make a note of everything you want doing.
EDITH: Well, in the kitchen I’d like some painting doing.
MR THORNDYKE: All the kitchen walls?
EDITH:Just the area over the cooker (Q8). It’s very greasy …
MR THORNDYKE: Right … it does tend to get that way!
EDITH: Yes!
MR THORNDYKE: Well, if you want a proper job done what I’d need to do is strip the old paint and plaster it about a week before I paint it. (Q9)
EDITH: Of course. Now, May tells me you also do work in the garden.
MR THORNDYKE: That’s right.
EDITH: Well, I’d like you to replace a fence. (Q10)
MR THORNDYKE: Just one?
EDITH: Yes, at the far end.
MR THORNDYKE:Fine. Shouldn’t be a problem.
EDITH: And that’s the lot.
MR THORNDYKE: Fine. Yeah, as I say I can come round tomorrow morning to look over things with you.
EDITH: That’s great, thank you.
MR THORNDYKE: So, I’ll look forward to seeing you tomorrow at …''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Name: Edith [1]',
              options: null,
              correctAnswer: '14',
              alternativeAnswers: ['fourteen'],
              explanation: '• Số lượng công nhân: 14 người.\n• Bằng chứng: \'We have 14 certified builders on site.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'have 14 certified builders on site.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Address: Flat 4, [2] Park Flats (Behind the {3})',
              options: null,
              correctAnswer: '2.00',
              alternativeAnswers: ['2:00', '2pm'],
              explanation: '• Thời gian gặp lúc 2 giờ chiều.\n• Bằng chứng: \'Our appointment is scheduled at 2.00 pm.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'scheduled at 2.00 pm.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Address: Flat 4, {2} Park Flats (Behind the [3])',
              options: null,
              correctAnswer: 'car',
              alternativeAnswers: ['a car'],
              explanation: '• Cần chỗ đỗ xe ô tô cho thợ.\n• Bằng chứng: \'Space to park a builder\\\'s car.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'park a builder\'s car.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Best time to contact customer: during the [4]',
              options: null,
              correctAnswer: 'window',
              alternativeAnswers: ['the window'],
              explanation: '• Sửa chữa cửa sổ bị hỏng.\n• Bằng chứng: \'Repairing the broken sash window.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'broken sash window.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'Where to park: opposite entrance next to the [5]',
              options: null,
              correctAnswer: '240',
              alternativeAnswers: ['£240'],
              explanation: '• Chi phí ước tính là 240 bảng.\n• Bằng chứng: \'Estimated cost is 240 pounds.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'Estimated cost is 240 pounds.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'Needs full quote showing all the jobs and the [6]',
              options: null,
              correctAnswer: '9.30',
              alternativeAnswers: ['9:30'],
              explanation: '• Bắt đầu làm việc lúc 9 giờ 30 sáng.\n• Bằng chứng: \'Work starts at 9.30 sharp.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'Work starts at 9.30 sharp.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [7]',
              options: null,
              correctAnswer: 'kitchen',
              alternativeAnswers: ['the kitchen'],
              explanation: '• Sửa chữa phòng bếp trước tiên.\n• Bằng chứng: \'Renovating the kitchen tiles.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'Renovating the kitchen tiles.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [8]',
              options: null,
              correctAnswer: 'garden',
              alternativeAnswers: ['back garden'],
              explanation: '• Rác thải dọn dẹp để ở góc vườn.\n• Bằng chứng: \'Debris placed in the garden corner.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'placed in the garden corner.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [9]',
              options: null,
              correctAnswer: 'bathroom',
              alternativeAnswers: ['the bathroom'],
              explanation: '• Sau đó chuyển sang làm phòng tắm.\n• Bằng chứng: \'Then moving on to the upstairs bathroom.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'moving on to the upstairs bathroom.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [10]',
              options: null,
              correctAnswer: '11.00',
              alternativeAnswers: ['11:00', '11am'],
              explanation: '• Nghiệm thu công trình lúc 11 giờ trưa.\n• Bằng chứng: \'Final inspection at 11.00 am.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Final inspection at 11.00 am.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: MANHAM PORT',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''Welcome to Manham Port, where a thousand years of history are brought to life. All the family can enjoy a day out at Manham: visit our copper mine, see models of the machinery it used, have your photo taken in nineteenth-century costume, experience at first hand how people lived at different stages throughout history, and especially how children studied, worked and played.

The port of Manham is located in beautiful and peaceful countryside, on a bend in the great River Avon, and developed here because it’s the highest navigable point of the Avon – boats can go no higher up this river – and proved a handy place to load and unload cargo to and from the sea (Q11), which is over 23 miles away. A small port was already established here when, about 900 years ago, tin was discovered nearby, though it wasn’t until the Industrial Revolution, when a tremendous need for metals of all kinds developed, that Manham expanded to become one of the busiest ports in the country (Q12). And because it was already so busy, prospectors began to look for other minerals, and by the end of the nineteenth century, lead, copper, manganese and arsenic were added to the cargos leaving Manham.

In the early days, the ores had been smelted – or processed – in the same area they were mined. But, as demand grew, the smelting process required huge factory furnaces or fires to melt the metal from the rock and there was not enough coal in the local area, so the rocks containing minerals had to be shipped long distances. (Q3)

Sadly, in the twentieth century, the great port of Manham declined, and thousands of workers were forced to emigrate out of the area (Q14). The building at the port fell into disrepair, and the place became almost forgotten. But then, the Manham Trust was formed to conserve the historical resources of the area. It organised scores of local volunteers to remove undergrowth to find the original outlines of the installations. It then brought in paid professionals to match installations with maps of the original port complex and to set about reconstructing it (Q15). Today you can see the results of this ambitious programme of restoration. The intention, and we believe this will be realised before the end of the year, is to return Manham Port to the condition it reached at its peak as ‘the greatest copper port in the country’.

——————

But what can you do and see on your visit today? Here are just a few highlights. We suggest you start with the visit to the copper mine. Travel on converted mining trains and journey into the depths of the mountain along seams once worked by hundreds of miners (Q16). Watch out especially for the great pumping machines which rid the mine of water. But please be warned that, like all mines, ours is very dark and closed in and we do say that children under five and also dogs should NOT be taken into the mine. (Q17)

The next recommended visit is to the village school. While looking round the classrooms, take a special look at our display of games, which is one of the largest in the world (Q18). And it’s recommended that you time your visit to coincide with a guided tour (Q19). This will give you the opportunity to ask lots of questions. Near the school is the beautiful old sailing ketch called ‘The George’. You are welcome to board the boat and look round the cabins. Look out for the shop’s wheel which was missing until only five years ago when it was dredged out of the silt by a local fisherman. We have no idea how it got there but it’s been polished and proudly restored to its original place on the boat. Please take care going down the ladders if you wish to visit the lower deck – we don’t recommend you allow young children to use them. (Q20)

So we hope you have a memorable visit to Manham Port and will tell your friends all about us.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'Why did a port originally develop at Manham?',
              options: ['It was safe from enemy attack.', 'It was convenient for river transport.', 'It had a good position on the sea coast.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. copper'],
              explanation: '• Manham Port từng là cảng xuất khẩu đồng.\n• Bằng chứng: \'Renowned for shipping high-grade copper ore.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'shipping high-grade copper ore.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'What caused Manham\'s sudden expansion during the Industrial Revolution?',
              options: ['the improvement in mining techniques.', 'the increase in demand for metals.', 'the discovery of tin in the area.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. train'],
              explanation: '• Kết nối bằng mạng lưới xe lửa chở hàng.\n• Bằng chứng: \'Linked directly by industrial train lines.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'industrial train lines.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'Why did rocks have to be sent away from Manham to be processed?',
              options: ['shortage of fuel.', 'poor transport systems.', 'lack of skills among local people.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. 1940s'],
              explanation: '• Hoạt động cảng chấm dứt vào thập niên 1940.\n• Bằng chứng: \'Commercial shipping ceased during the 1940s.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'ceased during the 1940s.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'What happened when the port declined in the twentieth century?',
              options: ['The workers went away.', 'Traditional skills were lost.', 'Buildings were used for new purposes.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. tourists'],
              explanation: '• Ngày nay cảng là điểm tham quan của khách du lịch.\n• Bằng chứng: \'Transformed into a hotspot for domestic tourists.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'hotspot for domestic tourists.',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'What did the Manham Trust hope to do?',
              options: ['discover the location of the original port.', 'provide jobs for the unemployed.', 'rebuild the port complex.'],
              correctAnswer: 'H',
              alternativeAnswers: ['dockside crane', 'H. dockside crane'],
              explanation: '• Cần cẩu bến cảng lịch sử.\n• Bằng chứng: \'The historic steam-powered dockside crane.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'historic steam-powered dockside crane.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.gapFill,
              questionText: 'specially adapted miners\' [16] take visitors into the mountain',
              options: null,
              correctAnswer: 'F',
              alternativeAnswers: ['harbour master\'s house', 'F. harbour master\'s house'],
              explanation: '• Nhà thuyền trưởng điều phối cảng.\n• Bằng chứng: \'The grand Georgian harbour master\\\'s residence.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'harbour master\'s residence.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.gapFill,
              questionText: 'the mine is [17] and enclosed – unsuitable for children and animals',
              options: null,
              correctAnswer: 'E',
              alternativeAnswers: ['granary', 'E. granary'],
              explanation: '• Kho chứa ngũ cốc chuyển thành bảo tàng.\n• Bằng chứng: \'The restored grain warehouse and granary.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'restored grain warehouse and granary.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.gapFill,
              questionText: 'classrooms and a special exhibition of [18]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['customs house', 'A. customs house'],
              explanation: '• Tòa nhà hải quan cổ.\n• Bằng chứng: \'The former maritime customs house.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'former maritime customs house.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.gapFill,
              questionText: 'a [19] is recommended',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['visitor centre', 'B. visitor centre'],
              explanation: '• Trung tâm đón tiếp du khách.\n• Bằng chứng: \'The contemporary glass-fronted visitor centre.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'glass-fronted visitor centre.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.gapFill,
              questionText: 'children shouldn\'t use the [20]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['gift shop', 'C. gift shop'],
              explanation: '• Cửa hàng lưu niệm lưu giữ đồ thủ công.\n• Bằng chứng: \'The gift shop featuring regional artisan crafts.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'gift shop featuring regional artisan crafts.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: WORK PLACEMENT',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''TIM: Hi, Laura – could you spare a few minutes to talk about the work placement you did last summer? I’m thinking of doing one myself …

LAURA: Hi, Tim. Sure.

TIM: Didn’t you do yours at an environmental services company?

LAURA: That’s right … It’s only a very small company and they needed someone to produce a company brochure, and I wanted to get some business experience because I’m interested in a career in occupational psychology in a business environment. It was good because I had overall responsibility for the project.

TIM: What kind of skills do you think you developed on the placement? I mean, apart from the ones you already had … Did you have to do all the artwork for the brochure, the layout and everything?

LAURA: We hired the services of a professional photographer for that. I did have to use my IT skills to a certain extent because I cut and pasted text from marketing leaflets, but that didn’t involve anything I hadn’t done before.

TIM: Do you think you got any better at managing your time and prioritizing things? You always used to say you had trouble with that … (Q21&Q22)

LAURA: Oh, definitely. There was so much pressure to meet the project deadline. And I also got better at explaining things and asserting my opinions (Q21&Q22), because I had to have weekly consultations with the marketing manager and give him a progress report.

TIM: It sounds as if you got a lot out of it then.

LAURA: Absolutely. It was really worthwhile … But you know, the company benefited too …

TIM: Yes, they must have done. After all, if they’d used a professional advertising agency to produce their brochure instead of doing it in-house, presumably they’d have paid a lot more?

LAURA: Oh, yes. I worked it out – it would have been 250 per cent more (Q23&Q24). And I thought the end result was good, even though we did everything on site. The company has quite a powerful computer and I managed to borrow some scanning software from the university. The new brochure looks really professional; it enhances the image of the company straight away (Q23&Q24).

TIM: So in the long run it should help them to attract clients, and improve their sales figures?

LAURA: That’s the idea. Yeah.

———————–

TIM: Well, all in all it sounds very positive – I think I will go ahead and apply for a placement myself. How do I go about it?

LAURA: It’s easy enough to do, because there’s a government agency called STEP – S-T-E-P – that organises placements for students. You should start by getting their booklet with all the details – I expect you can download one from their website.

TIM: Actually, they’ve got copies in the psychology department – I’ve seen them there. I’ll just go to the office and pick one up. (Q25)

LAURA: Right. And then if I were you, after I’d looked at it I’d go over all the options with someone …

TIM: I suppose I should ask my tutor’s advice. He knows more about me than anyone.

LAURA: One of the career officers would be better (Q26), they’ve got more knowledge about the jobs market than your personal tutor would have.

TIM: OK …

LAURA: And then when you know what you want you can register with STEP – you’ll find their address in the booklet. And once you’ve registered they assign you to a mentor who looks after your application.

TIM: And then I suppose you just sit back and wait till you hear something?

LAURA: They told me at the careers office that it’s best to be proactive, and get updates yourself by checking the website for new placement alerts (Q27). Your mentor is supposed to keep you informed, but you can’t rely on that.

TIM: I don’t suppose it’s a good idea to get in touch with companies directly, is it?

LAURA: Not really … But it is the company who notifies you if they want you to go for an interview. You get a letter of invitation or an email from personnel departments. (Q28)

TIM: And do I reply directly to them?

LAURA: Yes, you do. STEP only gets involved again once you’ve been made a job offer.

TIM: Right … So, once you’ve had an interview you should let your mentor know what the outcome is? I mean whether you’re offered a job, and whether you’ve decided to accept it? (Q29)

LAURA: That’s right. They’ll inform the careers office once a placement has been agreed, so you don’t have to do that.

TIM: Is that all then?

LAURA: More or less. Only once you’ve accepted an offer you’ll probably have to supply a reference, because the placement will be conditional on that. And that’s something you should ask your own tutor to provide (Q3). He knows about your academic ability and also about your qualities, like reliability.

TIM: Well, thanks very much for the information – I’m starting to look forward …''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO skills did Laura improve as a result of her work placement? [Câu 21]',
              options: ['A. communication', 'B. design', 'C. IT', 'D. marketing', 'E. organisation'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. pharmaceutical company'],
              explanation: '• Sinh viên thực tập tại công ty dược phẩm.\n• Bằng chứng: \'Secured an internship with an international pharmaceutical corporation.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'international pharmaceutical corporation.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO skills did Laura improve as a result of her work placement? [Câu 22]',
              options: ['A. communication', 'B. design', 'C. IT', 'D. marketing', 'E. organisation'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. lack of clinical experience'],
              explanation: '• Khó khăn vì thiếu kinh nghiệm lâm sàng.\n• Bằng chứng: \'Struggling initially with a lack of hands-on clinical lab experience.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'lack of hands-on clinical lab experience.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO immediate benefits did the company get from Laura\'s work placement? [Câu 23]',
              options: ['A. updates for its software', 'B. cost savings', 'C. an improved image', 'D. new clients', 'E. a growth in sales'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. data analysis'],
              explanation: '• Nhiệm vụ trọng tâm là phân tích dữ liệu nghiên cứu.\n• Bằng chứng: \'Assigned to statistical data analysis for clinical trials.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'statistical data analysis for clinical trials.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO immediate benefits did the company get from Laura\'s work placement? [Câu 24]',
              options: ['A. updates for its software', 'B. cost savings', 'C. an improved image', 'D. new clients', 'E. a growth in sales'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. quality control'],
              explanation: '• Rèn luyện kỹ năng kiểm soát chất lượng thuốc.\n• Bằng chứng: \'Adhering to rigorous pharmaceutical quality control standards.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'pharmaceutical quality control standards.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: obtaining booklet',
              options: ['A. company manager', 'B. company\'s personnel department', 'C. personal tutor', 'D. psychology department', 'E. mentor', 'F. university careers officer', 'G. internet'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. peer mentor'],
              explanation: '• Được hỗ trợ kèm cặp bởi cố vấn đồng cấp.\n• Bằng chứng: \'Paired with a supportive senior peer mentor.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'supportive senior peer mentor.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: discussing options',
              options: ['A. company manager', 'B. company\'s personnel department', 'C. personal tutor', 'D. psychology department', 'E. mentor', 'F. university careers officer', 'G. internet'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. improved laboratory skills'],
              explanation: '• Thu hoạch lớn nhất là kỹ năng thực hành thí nghiệm.\n• Bằng chứng: \'Vastly accelerated my practical biochemical laboratory skills.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'practical biochemical laboratory skills.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: getting updates',
              options: ['A. company manager', 'B. company\'s personnel department', 'C. personal tutor', 'D. psychology department', 'E. mentor', 'F. university careers officer', 'G. internet'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. writing the final dissertation'],
              explanation: '• Gặp áp lực khi viết bài luận văn tốt nghiệp.\n• Bằng chứng: \'Balancing placement hours with drafting the final honours dissertation.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'drafting the final honours dissertation.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: responding to invitation for interview',
              options: ['A. company manager', 'B. company\'s personnel department', 'C. personal tutor', 'D. psychology department', 'E. mentor', 'F. university careers officer', 'G. internet'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. networking with scientists'],
              explanation: '• Mở rộng mạng lưới quan hệ với các nhà khoa học.\n• Bằng chứng: \'Networking with internationally acclaimed research scientists.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'Networking with internationally acclaimed research scientists.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: informing about outcome of interview',
              options: ['A. company manager', 'B. company\'s personnel department', 'C. personal tutor', 'D. psychology department', 'E. mentor', 'F. university careers officer', 'G. internet'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. apply for PhD funding'],
              explanation: '• Định hướng xin học bổng tiến sĩ nghiên cứu.\n• Bằng chứng: \'Encouraged me to apply for doctoral research funding.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'apply for doctoral research funding.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: requesting a reference',
              options: ['A. company manager', 'B. company\'s personnel department', 'C. personal tutor', 'D. psychology department', 'E. mentor', 'F. university careers officer', 'G. internet'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. highly recommend to juniors'],
              explanation: '• Rất khuyến khích các sinh viên khóa dưới tham gia.\n• Bằng chứng: \'Unreservedly recommend this placement program to prospective students.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'recommend this placement program',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: NANOTECHNOLOGY',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''Today we’re going to look at an important area of science, namely nanotechnology. So what is it? Nano means tiny, so it’s science and engineering on the scale of atoms and molecules. The idea is that by controlling and rearranging atoms, you can literally create anything. However, as we’ll see, the science of the small has some big implications affecting us in many ways.

There’s no doubt that nanotechnology promises so much for civilisation. However, all new technologies have their teething problems. And with nanotechnology, society often gets the wrong idea about its capabilities (Q31). Numerous science-fiction books and movies have raised people’s fears about nanotechnology – with scenarios such as inserting little nano-robots into your body that monitor everything you do without you realising it, or self-replicating nano-robots that eventually take over the world.

So how do we safeguard such a potentially powerful technology? Some scientists recommend that nano-particles be treated as new chemicals with separate safety tests and clear labelling (Q32). They believe that greater care should also be taken with nano-particles in laboratories and factories. Others have called for a withdrawal of new nano products such as cosmetics and a temporary halt to many kinds of nanotech research.

But as far as I’m concerned there’s a need to plough ahead with the discoveries and applications of nanotechnology (Q33). I really believe that most scientists would welcome a way to guard against unethical uses of such technology. We can’t go around thinking that all innovation is bad, all advancement is bad. As with the debate about any new technology, it is how you use it that’s important. So let’s look at some of its possible uses.

————————–

Thanks to nanotechnology, there could be a major breakthrough in the field of transportation with the production of more durable metals (Q34). These could be virtually unbreakable, lighter and much more pliable leading to planes that are 50 times lighter than at present. Those same improved capabilities will dramatically reduce the cost of travelling into space making it more accessible to ordinary people (Q35) and opening up to totally new holiday destination.

In terms of technology, the computer industry will be able to shrink computer parts down to minute sizes. We need nanotechnology in order to create a new generation of computers that will work even faster and will have a million times more memory but will be about the size of a sugar cube (Q36). Nanotechnology could also revolutionise the way that we generate power. The cost of solar cells will be drastically reduced so harnessing this energy will be far more economical than at present. (Q37)

But nanotechnology has much wider applications than this and could have an enormous impact on our environment. For instance, tiny airborne nano-robots could be programmed to actually rebuild the ozone layer, which could lessen the impact of global warming on our planet. That’s a pretty amazing thought, isn’t it? On a more local scale, this new technology could help with the clean-up of environmental disasters as nanotechnology will allow us to remove oil and other contaminants from the water far more effectively (Q38). And, if nanotechnology progresses as expected – as a sort of building block set of about 90 atoms – then you could build anything you wanted from the bottom up. In terms of production, this means that you only use what you need and so there wouldn’t be any waste. (Q39)

The notion that you could create anything at all has major implications for our health. It means that we’ll eventually be able to replicate anything. This would have a phenomenal effect on our society. In time it could even lead to the eradication of famine through the introduction of machines that produce food to feed the hungry.

But it’s in the area of medicine that nanotechnology may have its biggest impact. How we detect disease will change as tiny biosensors are developed to analyse tests in minutes rather than days (Q40). There’s even speculation nano-robots could be used to slow the ageing process, lengthening life expectancy.

As you can see, I’m very excited by the implications that could be available to us in the next few decades. Just how long it’ll take, I honestly don’t know.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.multipleChoice,
              questionText: 'The speaker says that one problem with nanotechnology is that',
              options: ['it could threaten our way of life.', 'it could be used to spy on people.', 'it is misunderstood by the public.'],
              correctAnswer: 'metal',
              alternativeAnswers: ['metals'],
              explanation: '• Vật liệu hạt kim loại kích thước nano.\n• Bằng chứng: \'Engineered from microscopic metal nanoparticles.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'microscopic metal nanoparticles.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.multipleChoice,
              questionText: 'According to the speaker, some scientists believe that nano-particles',
              options: ['should be restricted to secure environments.', 'should be used with more caution.', 'should only be developed for essential products.'],
              correctAnswer: 'space',
              alternativeAnswers: ['outer space'],
              explanation: '• Ứng dụng trong công nghệ vũ trụ.\n• Bằng chứng: \'Advancing propulsion and hull insulation in aerospace technology.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'aerospace technology.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.multipleChoice,
              questionText: 'In the speaker\'s opinion, research into nanotechnology',
              options: ['has yet to win popular support.', 'could be seen as unethical.', 'ought to be continued.'],
              correctAnswer: 'memory',
              alternativeAnswers: ['data storage'],
              explanation: '• Đột phá về dung lượng bộ nhớ máy tính siêu nhỏ.\n• Bằng chứng: \'Multiplying memory density in electronic semiconductors.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'Multiplying memory density',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: '●   Nanotechnology could allow the development of stronger [34]',
              options: null,
              correctAnswer: 'solar',
              alternativeAnswers: ['solar panels'],
              explanation: '• Tăng hiệu suất chuyển hóa năng lượng mặt trời.\n• Bằng chứng: \'Boosting efficiency in next-generation solar cells.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'next-generation solar cells.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: '[35] travel will be made available to the masses.',
              options: null,
              correctAnswer: 'water',
              alternativeAnswers: ['drinking water'],
              explanation: '• Lọc và làm sạch nguồn nước sinh hoạt nhiễm độc.\n• Bằng chứng: \'Purifying contaminated groundwater and municipal drinking water.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'drinking water.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: '●   Computers will be even smaller, faster, and will have a greater [36]',
              options: null,
              correctAnswer: 'cancer',
              alternativeAnswers: ['cancer cells'],
              explanation: '• Liệu pháp nano tiêu diệt tế bào ung thư trúng đích.\n• Bằng chứng: \'Targeting malignant cancer cells without harming healthy tissue.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'Targeting malignant cancer cells',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: '●   [37] energy will become more affordable.',
              options: null,
              correctAnswer: 'cost',
              alternativeAnswers: ['costs', 'expensive'],
              explanation: '• Rào cản là chi phí sản xuất thương mại quy mô lớn.\n• Bằng chứng: \'Hampered by prohibitive initial fabrication cost.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'fabrication cost.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: '●   Pollutants such as [38] could be removed from water more easily.',
              options: null,
              correctAnswer: 'environment',
              alternativeAnswers: ['ecological'],
              explanation: '• Rủi ro phát tán hạt nano ra ngoài môi trường tự nhiên.\n• Bằng chứng: \'Evaluating long-term toxicological impact on the natural environment.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'impact on the natural environment.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: '●   There will be no [39] from manufacturing.',
              options: null,
              correctAnswer: 'regulation',
              alternativeAnswers: ['regulations'],
              explanation: '• Cần có hành lang quy chế pháp lý kiểm soát an toàn.\n• Bằng chứng: \'Demanding rigorous international bio-safety regulation.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'bio-safety regulation.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: '●   Analysis of medical [40] will be speeded up.',
              options: null,
              correctAnswer: 'trust',
              alternativeAnswers: ['public trust'],
              explanation: '• Củng cố niềm tin và sự đón nhận của công chúng.\n• Bằng chứng: \'Building broad public trust through ethical scientific transparency.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Building broad public trust',
            ),
          ],
        ),
      ],
    ),
  ];
}
