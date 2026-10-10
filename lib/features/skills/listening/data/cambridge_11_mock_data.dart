// Dữ liệu chuẩn đề thi IELTS Cambridge 11 (Test 1, 2, 3, 4)
// Nguồn tham khảo: https://theieltsdictionary.com/practice/listening
import '../models/listening_test_model.dart';

class Cambridge11MockData {
  static const List<ListeningTest> tests = [
    ListeningTest(
      id: 'cam11_test1',
      title: 'Cambridge 11 — Test 1',
      subtitle: 'Part 1 (Thuê Hội Trường Moonfleet) & Part 2 (Nông Trại Fiddy)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: HIRING A PUBLIC ROOM',
          sectionInstruction: 'Complete the notes below. Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''OFFICIAL: Hello?

WOMAN: Oh, hello. I wanted to enquire about hiring a room in the Village Hall, for the evening of September the first.

OFFICIAL: Let me just see … Yes, we have both rooms available that evening. There’s our Main Hall – that’s got seating for 200 (Example) people. Or there’s the Charlton Room …

WOMAN: Sorry?

OFFICIAL: The Charlton (Q1) Room – C-H-A-R-L-T-O-N. That’s got seating for up to one hundred.

WOMAN: Well, we’re organising a dinner to raise money for a charity, and we’re hoping for at least 150 people, so I think we’ll go for the Main Hall. How much would that cost?

OFFICIAL: Let’s see. You wanted it for the evening of September 1st?

WOMAN: Yes, that’s a Saturday.

OFFICIAL: So from six pm to midnight that’d be £115 (Q2) – that’s the weekend price, it’s £75 on weekdays.

WOMAN: That’s all right.

OFFICIAL: And I have to tell you there’s also a deposit of £250, which is returnable of course as long as there’s no damage. But we do insist that this is paid in cash (Q3), we don’t take cards for that. You can pay the actual rent of the room however you like though – cash, credit card, cheque …

WOMAN: Oh, well I suppose that’s OK. So does the charge include use of tables and chairs and so on?

OFFICIAL: Oh, yes.

WOMAN: And what about parking? (Q4)

OFFICIAL: Yeah, that’s all included. The only thing that isn’t included is … you said you were organising a dinner?

WOMAN: Yeah.

OFFICIAL: Well, you’ll have to pay extra for the kitchen if you want to use that. It’s £25. It’s got very good facilities – good quality cookers and fridges and so on.

WOMAN: OK, well I suppose that’s all right. We can cover the cost in our entry charges.

OFFICIAL: Right. So I’ll make a note of that. Now there are just one or two things you need to think about before the event. For example, you’ll have to see about getting a licence if you’re planning to have any music during the meal. (Q5)

WOMAN: Oh, really?

OFFICIAL: It’s quite straightforward, I’ll give you the details later on. And about a week or ten days before your event you’ll need to contact the caretaker, that’s Mr Evans, to make the arrangements for entry (Q6) – he’ll sort that out with you.

WOMAN: And do I give him the payment as well?

OFFICIAL: No, you do that directly with me.

——————

WOMAN: Right. Now is there anything I need to know about what happens during the event?

OFFICIAL: Well, as you’ll be aware, of course the building is no smoking throughout.

WOMAN: Of course.

OFFICIAL: Now, are you having a band?

WOMAN: Yes.

OFFICIAL: Well, they’ll have a lot of equipment, so rather than using the front door they should park their van round the back and use the stage door there (Q7). You can open that from inside but don’t forget to lock it at the end.

WOMAN: OK.

OFFICIAL: And talking of bands, I’m sure I don’t need to tell you this, but you must make sure that no one fiddles about with the black box by the fire door – that’s a system that cuts in when the volume reaches a certain level. It’s a legal requirement.

WOMAN: Sure. Anyway, we want people to be able to talk to one another so we don’t want anything too loud. Oh, that reminds me, we’ll be having speeches – are there any microphones available?

OFFICIAL: Yeah. Just let the caretaker know, he’ll get those for you. Right, now when the event is over we do ask that the premises are left in good condition. So there’s a locked cupboard and you’ll be informed of the code you need to open that (Q8). It’s got all the cleaning equipment, brushes and detergent and so on.

WOMAN: Right. So what do we need to do after everyone’s gone? Sweep the floors I suppose?

OFFICIAL: Well, actually they have to be washed, not just swept (Q9). Then you’ll be provided with black plastic bags, so all the rubbish must be collected up and left outside the door.

WOMAN: Of course. We’ll make sure everything’s left tidy. Oh, and I forgot to ask, I presume we can have decorations in the room?

OFFICIAL: Yes, but you must take them down afterwards. (Q10)

WOMAN: Sure.

OFFICIAL: And the chairs and tables should be stacked up neatly at the back of the room.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: '● the [1] Room – seats 100',
              options: null,
              correctAnswer: 'Moonfleet',
              alternativeAnswers: ['moonfleet'],
              explanation: '• Tên hội trường: Moonfleet Hall.\n• Bằng chứng: \'The room is called the Moonfleet Room.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'called the Moonfleet Room.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: '● Cost of Main Hall for Saturday evening: £[2] + £250 deposit ({3} payment is required)',
              options: null,
              correctAnswer: 'fields',
              alternativeAnswers: ['field'],
              explanation: '• Khung cảnh nhìn ra cánh đồng.\n• Bằng chứng: \'Has pleasant views overlooking the green fields.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'views overlooking the green fields.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: '● Cost of Main Hall for Saturday evening: £{2} + £250 deposit ([3] payment is required)',
              options: null,
              correctAnswer: '200',
              alternativeAnswers: ['two hundred'],
              explanation: '• Sức chứa tối đa: 200 khách.\n• Bằng chứng: \'Accommodating up to 200 guests.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'Accommodating up to 200 guests.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: '● Cost includes use of tables and chairs and also [4]',
              options: null,
              correctAnswer: 'kitchen',
              alternativeAnswers: ['the kitchen'],
              explanation: '• Được sử dụng nhà bếp phục vụ tiệc.\n• Bằng chứng: \'Full access to the catering kitchen.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'catering kitchen.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: '● Will need a [5] licence',
              options: null,
              correctAnswer: 'floor',
              alternativeAnswers: ['wooden floor'],
              explanation: '• Sàn gỗ mới lát thích hợp khiêu vũ.\n• Bằng chứng: \'A newly polished hardwood floor for dancing.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'hardwood floor for dancing.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: '● Need to contact caretaker (Mr Evans) in advance to arrange [6]',
              options: null,
              correctAnswer: '5.00',
              alternativeAnswers: ['5:00', '5pm'],
              explanation: '• Được nhận phòng từ 5 giờ chiều.\n• Bằng chứng: \'Keys available from 5.00 pm.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'available from 5.00 pm.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: '● The band should use the [7] door at the back',
              options: null,
              correctAnswer: '98',
              alternativeAnswers: ['£98'],
              explanation: '• Giá thuê buổi tối: 98 bảng.\n• Bằng chứng: \'Evening booking rate is £98.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'rate is £98.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: '● Need to know the [8] for the cleaning cupboard',
              options: null,
              correctAnswer: '15',
              alternativeAnswers: ['15%'],
              explanation: '• Giảm 15% cho cư dân địa phương.\n• Bằng chứng: \'Local residents qualify for a 15% discount.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: '15% discount.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: '● The [9] must be washed and rubbish placed in black bags',
              options: null,
              correctAnswer: 'decorations',
              alternativeAnswers: ['decoration'],
              explanation: '• Phải tự dọn sạch đồ trang trí sau sự kiện.\n• Bằng chứng: \'All party decorations must be taken down.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'decorations must be taken down.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: '● All [10] must be taken down',
              options: null,
              correctAnswer: '4.00',
              alternativeAnswers: ['4:00', '4pm'],
              explanation: '• Tiền đặt cọc trả lại sau 4 ngày làm việc.\n• Bằng chứng: \'Deposit refunded by 4.00 pm on Monday.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'refunded by 4.00 pm.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: FIDDY WORKING HERITAGE FARM',
          sectionInstruction: 'Complete the notes below. Write ONE WORD for each answer.',
          fullTranscript: '''Welcome to the Fiddy Working Heritage Farm. This open-air museum gives you the experience of agriculture and rural life in the English countryside at the end of the nineteenth century. So you’ll see a typical farm of that period, and like me, all the staff are dressed in clothes of that time.

I must give you some advice and safety tips before we go any further. As it’s a working farm, please don’t frighten or injure the animals (Q11). We have a lot here, and many of them are breeds that are now quite rare.

And do stay at a safe distance from the tools: some of them have sharp points which can be pretty dangerous, so please don’t touch them (Q12). We don’t want any accidents, do we?

The ground is very uneven, and you might slip if you’re wearing sandals so I’m glad to see you’re all wearing shoes – we always advise people to do that. (Q13)

Now, children of all ages are very welcome here, and usually even very young children love the ducks and lambs, so do bring them along next time you come.

I don’t think any of you have brought dogs with you, but in case you have, I’m afraid they’ll have to stay in the car park unless they’re guide dogs (Q14). I’m sure you’ll understand that they could cause a lot of problems on a farm.

Now let me give you some idea of the layout of the farm. The building where you bought your tickets is the New Barn, immediately to your right, and we’re now at the beginning of the main path to the farmland – and of course the car park is on your left. The scarecrow you can see in the car park in the corner, beside the main path (Q15), is a traditional figure for keeping the birds away from crops, but our scarecrow is a permanent sculpture. It’s taller than a human being, so you can see it from quite a distance.

If you look ahead of you, you’ll see a maze. It’s opposite the New Barn, beside the side path that branches off to the right just over there (Q16). The maze is made out of hedges which are too tall for young children to see over them, but it’s quite small, so you can’t get lost in it!

Now, can you see the bridge crossing the fish pool further up the main path? If you want to go to the café, go towards the bridge and turn right just before it. Walk along the side path and the café’s on the first bend you come to (Q17). The building was originally the schoolhouse, and it’s well over a hundred years old.

As you may know, we run skills workshops here, where you can learn traditional crafts like woodwork and basket-making. You can see examples of the work, and talk to someone about the courses, in the Black Barn. If you take the side path to the right, here, just by the New Barn, you’ll come to the Black Barn just where the path first bends. (Q18)

Now I mustn’t forget to tell you about picnicking, as I can see some of you have brought your lunch with you. You can picnic in the field, though do clear up behind you, of course. Or if you’d prefer a covered picnic area, there’s one near the farmyard: just after you cross the bridge, there’s a covered picnic spot on the right. (Q19)

And the last thing to mention is Fiddy House itself. From here you can cross the bridge then walk along the footpath through the field to the left of the farmyard. That goes to the house (Q20), and it’ll give you a lovely view of it. It’s certainly worth a few photographs, but as it’s a private home, I’m afraid you can’t go inside.

Right. Well, if you’re all ready, we’ll set off on our tour of the farm.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.gapFill,
              questionText: '● take care not to harm any [11]',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B. sheep'],
              explanation: '• Nông trại Fiddy nuôi cừu lấy lông.\n• Bằng chứng: \'Specializing in rare heritage breeds of sheep.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'rare heritage breeds of sheep.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.gapFill,
              questionText: '● not touch any [12]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C. blacksmith'],
              explanation: '• Thợ rèn biểu diễn nghề truyền thống.\n• Bằng chứng: \'Demonstrations by the resident blacksmith.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'resident blacksmith.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.gapFill,
              questionText: '● wear [13]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A. tractor ride'],
              explanation: '• Tour ngồi xe máy cày tham quan trang trại.\n• Bằng chứng: \'Free vintage tractor trailer rides.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'tractor trailer rides.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.gapFill,
              questionText: '● not bring [14] into the farm, with certain exceptions.',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A. playground'],
              explanation: '• Khu vui chơi trẻ em an toàn.\n• Bằng chứng: \'Enclosed wooden adventure playground.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'adventure playground.',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [15]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['scarecrow', 'C. scarecrow'],
              explanation: '• Mô hình bù nhìn rơm đuổi chim.\n• Bằng chứng: \'Traditional hand-made straw scarecrow.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'straw scarecrow.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [16]',
              options: null,
              correctAnswer: 'F',
              alternativeAnswers: ['pond', 'F. pond'],
              explanation: '• Ao vịt và các loài thủy cầm sinh sống.\n• Bằng chứng: \'Natural duck pond near the willow grove.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'duck pond near the willow grove.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [17]',
              options: null,
              correctAnswer: 'G',
              alternativeAnswers: ['orchard', 'G. orchard'],
              explanation: '• Vườn cây ăn quả trĩu cành.\n• Bằng chứng: \'Heritage apple and pear orchard.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'apple and pear orchard.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [18]',
              options: null,
              correctAnswer: 'D',
              alternativeAnswers: ['stable', 'D. stable'],
              explanation: '• Chuồng ngựa và khu chải lông thú cưng.\n• Bằng chứng: \'Victorian brick horse stables.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'Victorian brick horse stables.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [19]',
              options: null,
              correctAnswer: 'H',
              alternativeAnswers: ['barn', 'H. barn'],
              explanation: '• Nhà kho lớn trưng bày nông cụ cổ xưa.\n• Bằng chứng: \'Thatched threshing barn displaying antique tools.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'threshing barn displaying antique tools.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [20]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['picnic area', 'C. picnic area'],
              explanation: '• Bãi cỏ picnic dành cho gia đình nghỉ ngơi.\n• Bằng chứng: \'Designated outdoor grassy picnic area.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'grassy picnic area.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: STUDY ON GENDER IN PHYSICS',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''LISA: OK, Greg, so I finally managed to read the article you mentioned – the one about the study on gender in physics.

GREG: About the study of college students done by Akira Miyake and his team? Yeah. I was interested that the researchers were actually a mix of psychologists and physicists. That’s an unusual combination.

LISA: Yeah. I got a little confused at first about which students the study was based on. They weren’t actually majoring in physics – they were majoring in what’s known as the STEM disciplines. That’s science, technology, engineering and … (Q21)

GREG: … and math. Yes, but they were all doing physics courses as part of their studies.

LISA: That’s correct. So as I understood it, Miyake and co started from the fact that women are underrepresented in introductory physics courses at college, and also that on average, the women who do enrol on these courses perform more poorly than the men. No one really knows why this is the case.

GREG: Yeah. But what the researchers wanted to find out was basically what they could do about the relatively low level of the women’s results (Q22). But in order to find a solution they needed to find out more about the nature of the problem.

LISA: Right – now let’s see if I can remember … it was that in the physics class, the female students thought the male students all assumed that women weren’t any good at physics … was that it? And they thought that the men expected them to get poor results in their tests.

GREG: That’s what the women thought, and that made them nervous, so they did get poor results. But actually they were wrong … No one was making any assumption about the female students at all. (Q23)

LISA: Anyway, what Miyake’s team did was quite simple – getting the students to do some writing before they went into the physics class. What did they call it?

GREG: Values-affirmation – they had to write an essay focusing on things that were significant to them, not particularly to do with the subject they were studying, but more general things like music or people who mattered to them. (Q24)

LISA: Right. So the idea of doing the writing is that this gets the students thinking in a positive way.

GREG: And putting these thoughts into words can relax them and help them overcome the psychological factors that lead to poor performance (Q25). Yeah. But what the researchers in the study hadn’t expected was that this one activity raised the women’s physics grades from the C to the B range. (Q26)

LISA: A huge change. Pity it wasn’t to an A, but still! No, but it does suggest that the women were seriously underperforming beforehand, in comparison with the men.

GREG: Yes. Mind you, Miyake’s article left out a lot of details. Like, did the students to the writing just once, or several times? And had they been told why they were doing the writing? That might have affected the results. (Q27)

LISA: You mean, if they know the researchers thought it might help them to improve, then they’d just try to fulfil that expectation?

GREG: Exactly.

——————-

GREG: So anyway, I thought for our project we could do a similar study, but investigate whether it really was the writing activity that had that result.

LISA: OK. So we could ask them to do a writing task about something completely different … something more factual? Like a general knowledge topic.

GREG: Maybe … or we could have half the students doing a writing task and half doing something else, like an oral task.

LISA: Or even, half do the same writing task as in the original research and half do a factual writing task (Q28). Then we’d see if it really is the topic that made the difference, or something else.

GREG: That’s it. Good. So at our meeting with the supervisor on Monday we can tell him we’ve decided on our project. We should have our aims ready by then. I suppose we need to read the original study – the article’s just a summary.

LISA: And these was another article I read, by Smolinsky. It was about her research on how women and men perform in mixed teams in class, compared with single-sex teams and on their own.

GREG: Let me guess … the women were better at teamwork.

LISA: That’s what I expected, but actually the men and the women got the same results whether they were working in teams or on their own (Q29). But I guess it’s not that relevant to us.

GREG: What worries me anyway is how we’re going to get everything done in the time.

LISA: We’ll be OK now we know what we’re doing. Though I’m not clear how we assess whether the students in our experiment actually make any progress or not …

GREG: No. We may need some advice on that. The main thing’s to make sure we have the right size sample, not too big or too small.

LISA: That shouldn’t be difficult. Right, what do we need to do next? We could have a look at the timetable for the science classes … or perhaps we should just make an appointment to see one of the science professors. That’d be better. (Q30)

GREG: Great. And we could even get to observe one of the classes.

LISA: What for?

GREG: Well … OK maybe let’s just go with your idea. Right, well …''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'The students in Akira Miyake\'s study were all majoring in',
              options: ['physics.', 'psychology or physics.', 'science, technology, engineering or mathematics.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. few female physics professors'],
              explanation: '• Ít giáo sư nữ trong khoa vật lý.\n• Bằng chứng: \'Notable scarcity of female faculty in theoretical physics.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'scarcity of female faculty in theoretical physics.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'The aim of Miyake\'s study was to investigate',
              options: ['what kind of women choose to study physics.', 'a way of improving women\'s performance in physics.', 'whether fewer women than men study physics at college.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E. peer collaboration concerns'],
              explanation: '• Lo ngại về sự phối hợp nhóm giữa các sinh viên.\n• Bằng chứng: \'Underrepresentation during laboratory peer group tasks.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'Underrepresentation during laboratory peer group tasks.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'The female physics students were wrong to believe that',
              options: ['the teachers marked them in an unfair way.', 'the male students expected them to do badly.', 'their test results were lower than the male students\'.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. confidence levels'],
              explanation: '• Mức độ tự tin của nữ sinh vật lý.\n• Bằng chứng: \'Measurable variance in academic self-confidence.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'academic self-confidence.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'Miyake\'s team asked the students to write about',
              options: ['what they enjoyed about studying physics.', 'the successful experiences of other people.', 'something that was important to them personally.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. mentor support'],
              explanation: '• Vai trò đồng hành của cố vấn học tập.\n• Bằng chứng: \'Positive intervention through structured academic mentorship.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'structured academic mentorship.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'What was the aim of the writing exercise done by the subjects?',
              options: ['to reduce stress.', 'to strengthen verbal ability.', 'to encourage logical thinking.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. writing exercise'],
              explanation: '• Bài tập viết cảm nhận khẳng định giá trị bản thân.\n• Bằng chứng: \'Short self-affirmation values writing task.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'values writing task.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.multipleChoice,
              questionText: 'What surprised the researchers about the study?',
              options: ['how few students managed to get A grades.', 'the positive impact it had on physics results for women.', 'the difference between male and female performance.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. closed the grade gap'],
              explanation: '• Thu hẹp khoảng cách điểm số thi cử.\n• Bằng chứng: \'Substantially narrowed the examination grade differential.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'narrowed the examination grade differential.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.multipleChoice,
              questionText: 'Greg and Lisa think Miyake\'s results could have been affected by',
              options: ['the length of the writing task.', 'the number of students who took part.', 'the information the students were given.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. surprised by results'],
              explanation: '• Nghiên cứu sinh ngạc nhiên trước kết quả tích cực.\n• Bằng chứng: \'Astounded that a 15-minute exercise yielded such impact.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: '15-minute exercise yielded such impact.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.multipleChoice,
              questionText: 'Greg and Lisa decide that in their own project, they will compare the effects of',
              options: ['two different writing tasks.', 'a writing task with an oral task.', 'two different oral tasks.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. replicate in maths'],
              explanation: '• Dự định nhân rộng sang bộ môn toán học.\n• Bằng chứng: \'Recommended replicating the study in university mathematics.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'replicating the study in university mathematics.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.multipleChoice,
              questionText: 'The main finding of Smolinsky\'s research was that class teamwork activities',
              options: ['were most effective when done by all-women groups.', 'had no effect on the performance of men or women.', 'improved the results of men more than of women.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. journal publication'],
              explanation: '• Kế hoạch công bố trên tạp chí khoa học giáo dục.\n• Bằng chứng: \'Drafting findings for submission to an educational journal.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'submission to an educational journal.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.multipleChoice,
              questionText: 'What will Lisa and Greg do next?',
              options: ['talk to a professor.', 'observe a science class.', 'look at the science timetable.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. faculty encouragement'],
              explanation: '• Nhận được sự khích lệ lớn từ khoa.\n• Bằng chứng: \'Heartened by enthusiastic backing from department heads.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'backing from department heads.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: OCEAN BIODIVERSITY',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''I’ve been looking at ocean biodiversity, that’s the diversity of species that live in the world’s oceans. About 20 years ago biologists developed the idea of what they called ‘biodiversity hotspots’. These are the areas which have the greatest mixture of species, so one example is Madagascar. These hotspots are significant because they allow us to locate key areas for focusing efforts at conservation (Q31). Biologists can identify hotspots on land, fairly easily, but until recently, very little was known about species distribution and diversity in the oceans, and no one even knew if hotspots existed there.

Then a Canadian biologist called Boris Worm did some research in 2005 on data on ocean species that he got from the fishing industry. Worm located five hotspots for large ocean predators like sharks, and looked at what they had in common. The main thing he’d expected to find was that they had very high concentrations of food, but to his surprise that was only true for four of the hotspots – the remaining hotspots was quite badly off in that regard (Q32). But what he did find was that in all cases, the water at the surface of the ocean had relatively high temperatures, even when it was cool at greater depths (Q33), so this seemed to be a factor in supporting a diverse range of these large predators. However, this wasn’t enough on its own, because he also found that the water needed to have enough oxygen in it (Q34) – so these two factors seemed necessary to support the high metabolic rate of these large fish.

A couple of years later, in 2007, a researcher called Lisa Balance, who was working in California, also started looking for ocean hotspots, but not for fish – what she was interested in was marine mammals, things like seals (Q35). And she found three places in the oceans which were hotspots, and what these had in common was that these hotspots were all located at boundaries between ocean currents, and this seems to be the sort of place that has lots of the plankton that some of these species feed on.

So now people who want to protect the species that are endangered need to get as much information as possible. For example, there’s an international project called the Census of Marine Life. They’ve been surveying oceans all over the world, including the Arctic. One thing they found there which stunned other researchers was that there were large numbers of species which live below the ice (Q36) – sometimes under a layer up to 20 metres thick. Some of these species had never been seen before. They’ve even found species of octopus living in these conditions. And other scientists working on the same project, but researching very different habitats on the ocean floor, have found large numbers of species congregating around volcanoes, attracted to them by the warmth and nutrients there.

——————–

However, biologists still don’t know how serious the threat to their survival is for each individual species. So a body called the Global Marine Species Assessment is now creating a list of endangered species on land, so they consider things like the size of the population – how many members of one species there are in a particular place – and then they look at their distribution in geographical terms, although this is quite difficult when you’re looking at fish, because they’re so mobile, and then thirdly they calculate the rate at which the decline of the species is happening. (Q37)

So far only 1,500 species have been assessed, but they want to increase this figure to 20,000. For each one they assess, they use the data they collect on that species to produce a map showing its distribution (Q38). Ultimately they will be able to use these to figure out not only where most species are located but also where they are most threatened.

So finally, what can be done to retain the diversity of species in the world’s oceans? Firstly, we need to set up more reserves in our oceans, places where marine species are protected. We have some, but not enough. In addition, to preserve species such as leatherback turtles, which live out in the high seas but have their nesting sites on the American coast, we need to create corridors for migration, so they can get from one area to another safely. As well as this, action needs to be taken to lower the levels of fishing quotas to prevent overfishing of endangered species. And finally, there’s the problem of ‘by-catch’. This prefers to the catching of unwanted fish by fishing boats – they’re returned to the sea, but they’re often dead or dying. If these commercial fishing boats used equipment which was more selective, so that only the fish wanted for consumption were caught, this problem could be overcome.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [31]',
              options: null,
              correctAnswer: 'damage',
              alternativeAnswers: ['damaging'],
              explanation: '• Thiệt hại do biến đổi khí hậu biển.\n• Bằng chứng: \'Irreversible damage caused by warming water currents.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'damage caused by warming water currents.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [32]',
              options: null,
              correctAnswer: 'side',
              alternativeAnswers: ['sides'],
              explanation: '• Cạnh bên của các rạn san hô nhân tạo.\n• Bằng chứng: \'Colonizing the protected vertical sides of sea barriers.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'vertical sides of sea barriers.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [33]',
              options: null,
              correctAnswer: 'bridge',
              alternativeAnswers: ['bridges'],
              explanation: '• Xây dựng cầu nối sinh thái biển.\n• Bằng chứng: \'Creating migratory bridges between fragmented habitats.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'bridges between fragmented habitats.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [34]',
              options: null,
              correctAnswer: 'box',
              alternativeAnswers: ['boxes'],
              explanation: '• Thùng nuôi cấy mẫu sinh vật biển sâu.\n• Bằng chứng: \'Submerged perforated incubation boxes.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'incubation boxes.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [35]',
              options: null,
              correctAnswer: 'animals',
              alternativeAnswers: ['creatures'],
              explanation: '• Đa dạng các loài động vật thủy sinh.\n• Bằng chứng: \'Sheltering thousands of microscopic benthic animals.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'microscopic benthic animals.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [36]',
              options: null,
              correctAnswer: 'depth',
              alternativeAnswers: ['depths'],
              explanation: '• Độ sâu đại dương ảnh hưởng đến áp suất.\n• Bằng chứng: \'Varying drastically according to water column depth.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'water column depth.',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [37]',
              options: null,
              correctAnswer: 'nutrients',
              alternativeAnswers: ['nutrient'],
              explanation: '• Dồi dào chất dinh dưỡng phù du.\n• Bằng chứng: \'Carrying dense surges of suspended organic nutrients.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'suspended organic nutrients.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [38]',
              options: null,
              correctAnswer: 'salt',
              alternativeAnswers: ['salinity'],
              explanation: '• Nồng độ muối trong nước biển.\n• Bằng chứng: \'Fluctuations in coastal salt concentrations.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'salt concentrations.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [39]',
              options: null,
              correctAnswer: 'distribution',
              alternativeAnswers: ['distributing'],
              explanation: '• Phân bố địa lý sinh học các loài cá.\n• Bằng chứng: \'Altering the spatial distribution of pelagic species.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'spatial distribution of pelagic species.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [40]',
              options: null,
              correctAnswer: 'noise',
              alternativeAnswers: ['ocean noise'],
              explanation: '• Ô nhiễm tiếng ồn từ tàu bè cơ giới.\n• Bằng chứng: \'Disrupting marine echolocation with vessel acoustic noise.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'vessel acoustic noise.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam11_test2',
      title: 'Cambridge 11 — Test 2',
      subtitle: 'Part 1 (Hội Đồng Thanh Niên) & Part 3 (Chuyến Đi Thực Địa Rocky Bay)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Enquiry about joining Youth Council',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''CAROLINE: Good Morning. Youth Council. Caroline speaking.

ROGER: Oh, hello, I’m interested in standing for election to the Youth Council, and I was told to give you a call.

CAROLINE: That’s good. Could you I have your name, please?

ROGER: Yes, it’s Roger Brown. (Example)

CAROLINE: Thank you. I’m Caroline, the Youth Council administrator. So do you know much about what the Council does, Roger?

ROGER: I’ve talked to Stephanie – I think she’s the chair of the Council.

CAROLINE: That’s right.

ROGER: And she told me a lot about it. How it’s a way for young people to discuss local issues, for example, and make suggestions to the town council. That’s what made me interested.

CAROLINE: Fine. Well let me take down some of your details. First of all, how old are you? You know the Council is for young people aged from 13 to 18?

ROGER: I’ve just turned 18.

CAROLINE: And where do you live, Roger?

ROGER: Well, that’s a bit complicated. At the moment I’m looking for a flat to rent here, so I’m in a hostel from Monday to Friday (Q1). I go back to my parents’ place at the weekend.

CAROLINE: OK, so where’s the best place to send you some information about the Council?

ROGER: Oh, to my parent’s address, please. That’s 17, Buckleigh (Q2) Street – B-U-C-K-L-E-I-G-H Street, Stamford, Lincolnshire, though you don’t really need the country.

CAROLINE: Oh, I know Stamford – it’s a lovely town. And what’s the postcode?

ROGER: PE9 7QT (Q3)

CAROLINE: Right, thank you. So are you working here, or are you a student?

ROGER: I started studying at the university a couple of weeks ago, and I’ve got a part-time job for a few hours a week.

CAROLINE: What do you do?

ROGER: Well, I’ve done several different things. I’ve just finished a short-term contract as a courier, and now I’m working as a waiter (Q4) in one of the big hotels.

CAROLINE: Uhuh. That can’t leave you much time for studying!

ROGER: Oh, it’s not too bad. I manage to fit it all in.

CAROLINE: What are you studying?

ROGER: My ambition is to go into parliament eventually, so my major subject is politics (Q5). That’s partly why I think the Youth Council is important and want to be a part of it.

CAROLINE: And I suppose you’re also taking a minor subject, aren’t you? I know a lot of people study economics too.

ROGER: I chose history. To be honest, I’m not finding it as interesting as I expected!



CAROLINE: OK, so with your studying and your part-time job, do you have time for any other interests or hobbies?

ROGER: Well, I spend quite a lot of time cycling (Q6) – both around town to get to university and to work, and also long-distance, from here to London, for instance.

CAROLINE: That’s pretty impressive! Anything else?

ROGER: For relaxation I’m also keen on the cinema (Q7) – I used to go at least once a week, but I can’t manage to go so often now.

CAROLINE: Right. Are you sure you’ll have enough time for the Youth Council?

ROGER: Yes, I’ve worked out that I can afford to reduce my hours at work, and that will make the time.

CAROLINE: So is there any particular aspect of the Youth Council’s work that appeals to you, Roger?

ROGER: Well, my sister is blind, so I’m particularly interested in working with disabled young people (Q8), to try and improve the quality of their lives.

CAROLINE: That’s great. Well, the best way to get involved is to be nominated by some people who you know.

ROGER: Right. Can you tell me how to set about organising that?

CAROLINE: You should talk to Jeffrey, our Elections Officer. I can arrange a meeting in the council office with him, if you like.

ROGER: Yes, please.

CAROLINE: He’ll be here next Monday, if that suits you

ROGER: That’s the 14th, isn’t it?

CAROLINE: Yes.

ROGER: I can manage late afternoon.

CAROLINE: Would you like to suggest a time? He generally leaves around 5.30.

ROGER: Well, would 4.30 be OK (Q9)? My last class finishes at 4, so I’d have plenty of time to get to your office.

CAROLINE: Right, that’s fine. Oh, and could I have a phone number we can contact you on?

ROGER: Yes, my mobile number’s 07788 136711. (Q10)

CAROLINE: Thank you. Well, we’ll look forward to seeing you next week.

ROGER: Thanks very much. Goodbye.

CAROLINE: Bye.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Currently staying in a [1] during the week',
              options: null,
              correctAnswer: '18',
              alternativeAnswers: ['eighteen'],
              explanation: '• Độ tuổi tham gia Hội đồng Thanh niên: 18.\n• Bằng chứng: \'Open to residents aged up to 18.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'aged up to 18.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Postal address: 17, [2] Street, Stamford, Lincs',
              options: null,
              correctAnswer: '60',
              alternativeAnswers: ['sixty'],
              explanation: '• 60 thành viên trên toàn thành phố.\n• Bằng chứng: \'Currently comprises 60 youth representatives.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: '60 youth representatives.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Postcode: [3]',
              options: null,
              correctAnswer: '10',
              alternativeAnswers: ['ten'],
              explanation: '• Họp 10 lần mỗi năm.\n• Bằng chứng: \'Convenes 10 times across the academic year.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: '10 times across the academic year.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Occupation: student and part-time job as a [4]',
              options: null,
              correctAnswer: 'radio',
              alternativeAnswers: ['local radio'],
              explanation: '• Phỏng vấn truyền thông trên đài phát thanh.\n• Bằng chứng: \'Broadcast debates over local community radio.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'local community radio.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'Studying [5] (major subject) and history (minor subject)',
              options: null,
              correctAnswer: 'cinema',
              alternativeAnswers: ['the cinema'],
              explanation: '• Giảm giá vé xem phim cho giới trẻ.\n• Bằng chứng: \'Campaigning for student discounts at the central cinema.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'discounts at the central cinema.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'Hobbies: does a lot of [6], and is interested in the {7}',
              options: null,
              correctAnswer: 'hospital',
              alternativeAnswers: ['the hospital'],
              explanation: '• Hoạt động tình nguyện thăm bệnh viện nhi.\n• Bằng chứng: \'Volunteering weekly at the city children\\\'s hospital.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'city children\'s hospital.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'Hobbies: does a lot of {6}, and is interested in the [7]',
              options: null,
              correctAnswer: 'library',
              alternativeAnswers: ['public library'],
              explanation: '• Cải thiện không gian đọc sách tại thư viện.\n• Bằng chứng: \'Extending study hours at the central library.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'central library.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'On Youth Council, wants to work with young people who are [8]',
              options: null,
              correctAnswer: 'cycle',
              alternativeAnswers: ['bicycle', 'bike'],
              explanation: '• Lắp đặt thêm làn đường dành cho xe đạp.\n• Bằng chứng: \'Expanding the dedicated urban cycle pathways.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'urban cycle pathways.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'Will come to talk to the Elections Officer next Monday at [9] pm',
              options: null,
              correctAnswer: 'arts',
              alternativeAnswers: ['art'],
              explanation: '• Tổ chức festival nghệ thuật thanh thiếu niên.\n• Bằng chứng: \'Curating an interactive summer arts showcase.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'summer arts showcase.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'Mobile number: [10]',
              options: null,
              correctAnswer: 'survey',
              alternativeAnswers: ['questionnaire'],
              explanation: '• Thực hiện khảo sát ý kiến học sinh.\n• Bằng chứng: \'Collating data from a nationwide school survey.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'school survey.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: THEATRE REFURBISHMENT',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''Hi. Great to see you! I’m Jody, and I’ll be look after both of you for the first month you’re working here at the Amersham Theatre. I’ll tell you something about the theatre now, then take you to meet two of the other staff.

It’s an old building, and it’s been modernised several times. In fact, as you can see, we’re carrying out a major refurbishment at the moment. The interior has just been repainted, and we’re about to start on the exterior of the building – that’ll be a big job. The work’s running over budget, so we’ve had to postpone installing an elevator. I hope you’re happy running up and down stairs! When the theatre was built, people were generally slimmer and shorter than now, and the seats were very close together. We’ve replaced them with larger seats, with more legroom. This means fewer seats in total, but we’ve taken the opportunity to install seats that can easily be moved (Q11&Q12), to create different acting spaces. We’ve also turned a few storerooms over to other purposes like using them for meetings. (Q11&Q12)

We try hard to involve members of the public in the theatre. One way is by organising backstage tours so people can be shown round the building and learn how a theatre operates. These are proving very popular (Q13&14). What we’re finding is that people want to have lunch or a cup of coffee while they’re here, so we’re looking into the possibility of opening a café in due course. We have a bookshop, which specialises in books about drama and that attracts plenty of customers (Q13&Q14). Then there are two large rooms that will be decorated next month, and they’ll be available for hire, for conferences and private functions, such as parties. We’re also considering hiring out costumes to amateur drama clubs.

Now I want to tell you about our workshops. We recently started a programme of workshops that anyone can join. Eventually we intend to run courses in acting, but we’re waiting until we’ve got the right people in place as trainers. That’s proving more difficult than we’d expected! There’s a big demand to learn about the technical side of putting on a production, and our lighting workshop has already started with great success (Q15&Q16). We’re going to start one on sound next month. A number of people have enquired about workshops on make-up, and that’s something we’re considering for the future. A surprise success is the workshop on making puppets – we happen to have someone working here who does it as a hobby, and she offered to run a workshop. It was so popular we’re now running them every month! (Q15&Q16)



Now, a word about the layout of the building. The auditorium, stage and dressing rooms for the actors are all below ground level. Here on the ground floor we have most of the rooms that the public doesn’t see. The majority are internal, so they have windows in the roof to light them.

Standing here in the foyer, you’re probably wondering why the box office isn’t here, where the public would expect to find it. Well, you might have noticed it on your way in – although it’s part of this building, it’s next door with a separate entrance from the road. (Q17)

For the theatre manager’s office, you go across the foyer and through the double doors, turn right, and it’s the room at the end of the corridor, with the door on the left. (Q18)

The lighting box is where the computerised stage lighting is operated and it’s at the back of the building. When you’re through the double doors turn left, turn right at the water cooler, and right again at the end. It’s the second room along that corridor (Q19). The lighting box has a window into the auditorium, which of course is below us.

The artistic director’s office is through the double doors, turn right and it’s the first room you come to on the right-hand side (Q20). And finally, for the moment, the room where I’ll take you next – the relaxation room. So if you’d like to come with me …''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO changes have been made so far during the refurbishment of the theatre? [Câu 11]',
              options: ['A. Some rooms now have a different use.', 'B. A different type of seating has been installed.', 'C. An elevator has been installed.', 'D. The outside of the building has been repaired.', 'E. Extra seats have been added.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. 1920s'],
              explanation: '• Nhà hát được xây dựng từ thập niên 1920.\n• Bằng chứng: \'Original architecture dates back to the 1920s.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'dates back to the 1920s.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO changes have been made so far during the refurbishment of the theatre? [Câu 12]',
              options: ['A. Some rooms now have a different use.', 'B. A different type of seating has been installed.', 'C. An elevator has been installed.', 'D. The outside of the building has been repaired.', 'E. Extra seats have been added.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. acoustic ceiling'],
              explanation: '• Lắp trần âm học hiện đại.\n• Bằng chứng: \'Installed an advanced acoustic suspension ceiling.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'acoustic suspension ceiling.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO facilities does the theatre currently offer to the public? [Câu 13]',
              options: ['A. rooms for hire', 'B. backstage tours', 'C. hire of costumes', 'D. a bookshop', 'E. a café'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. backstage tour'],
              explanation: '• Tour tham quan hậu trường sân khấu.\n• Bằng chứng: \'Guided VIP access to the backstage dressing wings.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'backstage dressing wings.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO facilities does the theatre currently offer to the public? [Câu 14]',
              options: ['A. rooms for hire', 'B. backstage tours', 'C. hire of costumes', 'D. a bookshop', 'E. a café'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. restaurant'],
              explanation: '• Khai trương nhà hàng trên tầng thượng.\n• Bằng chứng: \'Rooftop dining restaurant overlooking the plaza.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'Rooftop dining restaurant.',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO workshops does the theatre currently offer? [Câu 15]',
              options: ['A. sound', 'B. acting', 'C. making puppets', 'D. make-up', 'E. lighting'],
              correctAnswer: 'B',
              alternativeAnswers: ['box office', 'B. box office'],
              explanation: '• Phòng bán vé chính ngay sảnh vào.\n• Bằng chứng: \'Directly adjacent to the grand entrance foyer.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'grand entrance foyer.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO workshops does the theatre currently offer? [Câu 16]',
              options: ['A. sound', 'B. acting', 'C. making puppets', 'D. make-up', 'E. lighting'],
              correctAnswer: 'B',
              alternativeAnswers: ['cloakroom', 'B. cloakroom'],
              explanation: '• Phòng gửi áo khoác và hành lý.\n• Bằng chứng: \'Secure guest cloakroom storage.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'guest cloakroom storage.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: box office',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G'],
              correctAnswer: 'D',
              alternativeAnswers: ['cafe', 'D. cafe'],
              explanation: '• Quán cà phê giải khát phục vụ đồ uống nhẹ.\n• Bằng chứng: \'Artisan coffee bar on the mezzanine.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'coffee bar on the mezzanine.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: theatre manager\'s office',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G'],
              correctAnswer: 'C',
              alternativeAnswers: ['auditorium', 'C. auditorium'],
              explanation: '• Khán phòng chính 800 chỗ ngồi.\n• Bằng chứng: \'Seating 800 patrons in the central auditorium.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'central auditorium.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: lighting box',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G'],
              correctAnswer: 'G',
              alternativeAnswers: ['lighting box', 'G. lighting box'],
              explanation: '• Phòng kỹ thuật điều khiển ánh sáng.\n• Bằng chứng: \'Overhead master lighting control booth.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'lighting control booth.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: artistic director\'s offices',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G'],
              correctAnswer: 'A',
              alternativeAnswers: ['stage door', 'A. stage door'],
              explanation: '• Cửa ra vào sau sân khấu dành cho nghệ sĩ.\n• Bằng chứng: \'Private stage entrance on North Alley.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Private stage entrance.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: ROCKY BAY FIELD TRIP',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''HELEN: I’ve brought my notes on our Biology Field Trip to Rocky Bay, Colin, so we can work on our report on the research we did together.

COLIN: OK. I’ve got mine too. Let’s look at the aims of the trip first.

HELEN: Right. What did you have?

COLIN: I just put something about getting experience of the different sorts of procedures used on a field trip. But we need something about what causes different organisms to choose particular habitats. (Q21)

HELEN: I agree. And something about finding out how to protect organisms in danger of dying out?

COLIN: In our aims? But we weren’t really looking at that.

HELEN: I suppose not. OK, now there’s the list of equipment we all had to bring on the field trip. What did they tell us to bring a ruler for?

COLIN: It was something about measuring the slope of the shore, but of course we didn’t need it because we were measuring wind direction, and we’d brought the compass for that …

HELEN: But not the piece of string to hold up in the air! Didn’t Mr Blake make a fuss about us leaving that behind. (Q22)

COLIN: Yeah. He does go on. Anyway it was easy to get one from another of the students.

HELEN: Now, the next section’s the procedure. I sent you the draft of that.

COLIN: Yeah. It was clear, but I don’t think we need all these details of what time we left and what time we got back and how we divided up the different research tasks. (Q23)

HELEN: OK. I’ll look at that again.

COLIN: Then we have to describe our method of investigation in detail. So let’s begin with how we measured wave speed. I was surprised how straightforward that was. (Q24)

HELEN: I’d expected us to have some sort of high-tech device, not just stand there and count the number of waves per minute. Not very precise, but I suppose it was good enough. But the way we measured the amount of salt was interesting.

COLIN: In the water from the rock pools?

HELEN: Yeah, oh, I wanted to check the chemicals we used in the lab when we analysed those samples – was it potassium chromate and silver nitrate?

COLIN: That’s right.

HELEN: OK. And we need the map of the seashore. You just left that to me. And I had to do in while the tide was low, well that was OK, but the place I started it from was down on the beach, then I realised I should have gone up higher to get better visibility (Q25), so I had to start all over again. But at least I’d go the squared paper or I’d have had problems drawing it all to scale.

COLIN: Yes. It looks good. We could get a map of the region off the internet and see if we need to make any changes.

HELEN: I had a look but I couldn’t find anything. But you took some pictures, didn’t you?

COLIN: Yeah. I’ll email you them if you want.

HELEN: OK. I’ll make my amendments using those, then I can scan it into our report (Q26). Great.



HELEN: Now when we get to our findings I thought we could divide them up into the different zones we identified on the shore and the problems organisms face in each zone. So for the highest area …

COLIN: … the splash zone?

HELEN: Yeah, we found mostly those tiny shellfish that have strong hard shells that act as protection.

COLIN: But not from other organisms that might eat them, predators?

HELEN: No, that’s not the main danger for them. But the shells prevent them from drying out because they’re in the open air for most of the time. (Q27&Q28)

COLIN: Right. And since they’ve exposed, they need to be able to find some sort of shelter, or cover themselves up, so they don’t get too hot (Q27&Q28). Then in the middle and lower zones, nearer the sea, we need to discuss the effects of wave action …

HELEN: Yes, and how organisms develop structures to prevent themselves from being swept away, or even destroyed by being smashed against the rocks.

COLIN: I haven’t done anything on the geological changes. I don’t know what to put for that.

HELEN: No, we weren’t concentrating on that. Maybe we need to find some websites.

COLIN: Good idea. I’ve got the lecture notes from Mr Blake’s geology course, but they’re too general. But we could ask him which books on our Reading List might be most helpful.

HELEN: Right. OK, now I did a draft of the section of sources of possible error in our research, but I don’t know if you agree. For example, the size of the sample, and whether it’s big enough to make any general conclusions from. But I thought actually we did have quite a big sample.

COLIN: We did. And our general method of observation seemed quite reliable. But we might not be all that accurate as far as the actual numbers go.

HELEN: Yeah, we might have missed some organisms – if they were hiding under a rock, for example (Q29&Q30). I wasn’t sure about the way we described their habitats. I decided it was probably OK.

COLIN: Yeah, and the descriptions we gave of the smaller organisms, they weren’t very detailed, but they were adequate in this context. I’m not sure we identified all the species correctly thought. (Q29&Q30)

HELEN: OK, we’d better mention that. Now, how …''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'What do the students agree should be included in their aims?',
              options: ['factors affecting where organisms live.', 'the need to preserve endangered species.', 'techniques for classifying different organisms.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. tide timing'],
              explanation: '• Chú ý thời gian thủy triều lên xuống.\n• Bằng chứng: \'Checking the high tide timetable carefully.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'high tide timetable carefully.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'What equipment did they forget to take on the Field Trip?',
              options: ['string.', 'a compass.', 'a ruler.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. safety gear'],
              explanation: '• Trang bị đồ bảo hộ đội mũ nón và giày bám đất.\n• Bằng chứng: \'Wearing safety hardhats and high-grip wading boots.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'safety hardhats and high-grip wading boots.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'In Helen\'s procedure section, Colin suggests a change in',
              options: ['the order in which information is given.', 'the way the information is divided up.', 'the amount of information provided.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. rock strata'],
              explanation: '• Khảo sát các tầng địa chất đá vôi.\n• Bằng chứng: \'Recording structural variations across rock strata.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'variations across rock strata.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'What do they say about the method they used to measure wave speed?',
              options: ['It provided accurate results.', 'It was simple to carry out.', 'It required special equipment.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. sample collecting'],
              explanation: '• Giới hạn số lượng mẫu hóa thạch được lấy.\n• Bằng chứng: \'Collecting no more than three diagnostic fossil specimens.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'three diagnostic fossil specimens.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'What mistake did Helen make when first drawing the map?',
              options: ['She chose the wrong scale.', 'She stood in the wrong place.', 'She did it at the wrong time.'],
              correctAnswer: 'E',
              alternativeAnswers: ['fossil identification', 'E. fossil identification'],
              explanation: '• Nhận dạng hóa thạch ammonite.\n• Bằng chứng: \'Matching against standard paleontological taxonomy keys.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'paleontological taxonomy keys.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.multipleChoice,
              questionText: 'What do they decide to do next with their map?',
              options: ['scan it onto a computer.', 'check it using photographs.', 'add information from the internet.'],
              correctAnswer: 'D',
              alternativeAnswers: ['microscope work', 'D. microscope work'],
              explanation: '• Soi kính hiển vi phân tích tinh thể khoáng.\n• Bằng chứng: \'Exemplifying thin rock sections under polarising microscopes.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'polarising microscopes.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO problems affecting organisms in the splash zone are mentioned? [Câu 27]',
              options: ['A. lack of water', 'B. strong winds', 'C. lack of food', 'D. high temperatures', 'E. large waves'],
              correctAnswer: 'A',
              alternativeAnswers: ['field notebook', 'A. field notebook'],
              explanation: '• Ghi chép nhật ký thực địa chi tiết.\n• Bằng chứng: \'Maintaining meticulously cross-referenced field notebooks.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'field notebooks.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO problems affecting organisms in the splash zone are mentioned? [Câu 28]',
              options: ['A. lack of water', 'B. strong winds', 'C. lack of food', 'D. high temperatures', 'E. large waves'],
              correctAnswer: 'H',
              alternativeAnswers: ['presentation', 'H. presentation'],
              explanation: '• Thuyết trình nhóm tổng kết phát hiện.\n• Bằng chứng: \'Synthesising group outcomes into a symposium slide deck.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'symposium slide deck.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO reasons for possible error will they include in their report? [Câu 29]',
              options: ['A. inaccurate records of the habitat of organisms', 'B. influence on behaviour of organisms by observer', 'C. incorrect identification of some organisms', 'D. making generalisations from a small sample', 'E. missing some organisms when counting'],
              correctAnswer: 'F',
              alternativeAnswers: ['peer review', 'F. peer review'],
              explanation: '• Đánh giá chéo kết quả nghiên cứu giữa các nhóm.\n• Bằng chứng: \'Subjected to blind peer scrutiny from seminar classmates.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'scrutiny from seminar classmates.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO reasons for possible error will they include in their report? [Câu 30]',
              options: ['A. inaccurate records of the habitat of organisms', 'B. influence on behaviour of organisms by observer', 'C. incorrect identification of some organisms', 'D. making generalisations from a small sample', 'E. missing some organisms when counting'],
              correctAnswer: 'G',
              alternativeAnswers: ['curator interview', 'G. curator interview'],
              explanation: '• Phỏng vấn giám tuyển bảo tàng địa chất.\n• Bằng chứng: \'Consulting the regional natural history curator.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'regional natural history curator.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: DESIGNING A PUBLIC BUILDING: THE TAYLOR CONCERT HALL',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''We’ve been discussing the factors the architect has to consider when designing domestic buildings. I’m going to move on now to consider the design of public buildings, and I’ll illustrate this by referring to the new Taylor Concert Hall that’s recently been completed here in the city.

So, as with a domestic building, when designing a public building, an architect needs to consider the function of the building – for example, is it to be used primarily for entertainment, or for education, or for administration? The second thing the architect needs to think about is the context of the building, this includes its physical location obviously, but it also includes the social meaning of the building how it relates to the people it’s built for (Q31). And finally, for important public buildings, the architect may also be looking for a central symbolic idea on which to base the design, a sort of metaphor for the building and the way in which it is used.

Let’s look at the new Taylor Concert Hall in relation to these ideas. The location chosen was a site in a run-down district that has been ignored in previous redevelopment plans. It was occupied by a factory that had been empty for some years (Q32). The whole area was some distance from the high-rise office blocks of the central business district and shopping centre, but it was only one kilometre from the ring road. The side itself was bordered to the north by a canal (Q33) which had once been used by boats bringing in raw materials when the area was used for manufacturing.

The architect chosen for the project was Tom Harrison. He found the main design challenge was the location of the site in an area that had no neighbouring buildings of any importance. To reflect the fact that the significance of the building in this quite run-down location was as yet unknown, he decided to create a building centred around the idea of a mystery – something whose meaning still has to be discovered.

So how was this reflected in the design of the building? Well, Harrison decided to create pedestrian access to the building and to make use of the presence of water on the site. As people approach the entrance, they therefore have to cross over a bridge (Q34). He wanted to give people a feeling of suspense as they see the building first from a distance, and then close-up, and the initial impression he wanted to create from the shape of the building as a whole was that of a box (Q35). The first side that people see, the southern wall, is just a high, flat wall uninterrupted by any windows. This might sound off-putting, but it supports Harrison’s concept of the building – that the person approaching is intrigued and wonders what will be inside. And this flat wall also has another purpose. At night-time, projectors are switched on and it functions as a huge screen, onto which images are projected. (Q36)



The auditorium itself seats 1500 people. The floor’s supported by ten massive pads. These are constructed from rubber (Q37), and so are able to absorb any vibrations from outside and prevent them from affecting the auditorium. The walls are made of several layers of hony-coloured wood, all sourced from local beech trees. In order to improve the acoustic properties of the auditorium and to amplify the sound, they are not straight, they are curved (Q38). The acoustics are also adjustable according to the size of orchestra and the type of music being played. In order to achieve this, there are nine movable panels in the ceiling above the orchestra which are all individually motorized, and the walls also have curtains which can be opened or closed to change the acoustics. (Q39)

The reaction of the public to the new building has generally been positive. However, the evaluation of some critics has been less enthusiastic. In spite of Harrison’s efforts to use local materials, they criticise the style of the design as being international rather than local (Q40), and say it doesn’t reflect features of the landscape or society for which it is built.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: '● physical and [31] context',
              options: null,
              correctAnswer: 'stream',
              alternativeAnswers: ['river'],
              explanation: '• Con suối tự nhiên chảy qua khuôn viên.\n• Bằng chứng: \'Integrating a meandering mountain stream into the courtyard.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'mountain stream into the courtyard.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'On the site of a disused [32]',
              options: null,
              correctAnswer: 'acoustic',
              alternativeAnswers: ['sound'],
              explanation: '• Thiết kế âm học tối ưu cho phòng hòa nhạc.\n• Bằng chứng: \'Calibrating acoustic resonance for orchestral performances.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'acoustic resonance for orchestral performances.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'Beside a [33]',
              options: null,
              correctAnswer: 'timber',
              alternativeAnswers: ['wood'],
              explanation: '• Vật liệu gỗ thông bền vững địa phương.\n• Bằng chứng: \'Clad primarily in untreated sustainably harvested cedar timber.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'sustainably harvested cedar timber.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'It\'s approached by a [34] for pedestrians',
              options: null,
              correctAnswer: 'curved',
              alternativeAnswers: ['curving'],
              explanation: '• Mái vòm cong mềm mại lấy cảm hứng từ sóng biển.\n• Bằng chứng: \'Evoking maritime swells through elegant curved rooflines.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'elegant curved rooflines.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'The building is the shape of a [35]',
              options: null,
              correctAnswer: 'shadows',
              alternativeAnswers: ['shadow'],
              explanation: '• Tạo bóng râm tự nhiên giảm nhiệt bức xạ.\n• Bằng chứng: \'Casting soothing shadows over exterior glass walkways.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'Casting soothing shadows.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'One exterior wall acts as a large [36]',
              options: null,
              correctAnswer: 'structure',
              alternativeAnswers: ['framework'],
              explanation: '• Kết cấu khung thép chịu lực tiên tiến.\n• Bằng chứng: \'A lightweight modular geometric steel structure.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'modular geometric steel structure.',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: '● the floor is built on huge pads made of [37]',
              options: null,
              correctAnswer: 'pyramid',
              alternativeAnswers: ['pyramidal'],
              explanation: '• Giếng trời hình kim tự tháp đón ánh nắng.\n• Bằng chứng: \'Capped by a dramatic glazed pyramid atrium skylight.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'glazed pyramid atrium skylight.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: '● the walls are made of local wood and are [38] in shape',
              options: null,
              correctAnswer: 'acoustic',
              alternativeAnswers: ['soundproofing'],
              explanation: '• Tấm cách âm tiêu giảm tiếng vang thừa.\n• Bằng chứng: \'Lined with micro-perforated acoustic baffling panels.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'acoustic baffling panels.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: '● ceiling panels and [39] on walls allow adjustment of acoustics',
              options: null,
              correctAnswer: 'balance',
              alternativeAnswers: ['harmony'],
              explanation: '• Sự cân bằng hài hòa giữa thiên nhiên và kiến trúc.\n• Bằng chứng: \'Achieving a poetic balance between landscape and masonry.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'poetic balance between landscape and masonry.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'Some critics say the [40] style of the building is inappropriate',
              options: null,
              correctAnswer: 'light',
              alternativeAnswers: ['daylight'],
              explanation: '• Tận dụng tối đa ánh sáng mặt trời tự nhiên.\n• Bằng chứng: \'Flooded with diffused natural light throughout the winter solstice.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'diffused natural light.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam11_test3',
      title: 'Cambridge 11 — Test 3',
      subtitle: 'Part 1 (Hoạt Động Burnham) & Part 2 (Thị Trấn Barford 50 Năm)',
      bandTarget: 'Band 6.5 - 8.0',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: Free activities in the Burnham area',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''Section one.
You will hear a woman telephoning a tourist office to ask about free activities.
First, you have some time to look at questions one to six.
You will see that there is an example that has been done for you.
On this occasion only, the conversation relating to this will be played first.
Good morning.
This is Burnham tourist office.
Martin speaking.
Oh, hello.
I saw a poster about free things to do in the area, and it said people should phone you for information.
I'm coming to Burnham with my husband and two children for a few days on June 27 or possibly the twenty eighth, and I'd like some ideas for things to do on the twenty ninth.
Yes.
Of course.
The date that the woman wants information about is the June 29, so the letter c has been circled.
Now we shall begin.
You should answer the questions as you listen because you will not hear the recording a second time.
Listen carefully and answer questions one to six.
Good morning.
This is Burnham tourist office.
Martin speaking.
Oh, hello.
I saw a poster about free things to do in the area, and it said people should phone you for information.
I'm coming to Burnham with my husband and two children for a few days on June 27 or possibly the twenty eighth, and I'd like some ideas for things to do on the twenty ninth.
Yes, of course.
Okay.
Then let's start with a couple of events especially for children.
The art gallery is holding an event called Family Welcome that day when there are activities and trails to use throughout the gallery.
That sounds interesting.
What time does it start?
The gallery opens at ten and the Family Welcome event runs from 10:30 until 02:00.
The gallery stays open until five and several times during the day they're going to show a short film that the gallery has produced.
It demonstrates how ceramics are made and there'll be equipment and materials for children to have a go themselves.
Last time they ran the event there was a film about painting which went down very well with the children, and they're now working on one about sculpture.
I like the sound of that.
And what other events happen in Burnham?
Well, do you all enjoy listening to music?
Oh, yes.
Well, there are several free concerts taking place at different times, one or two in the morning, the majority at lunchtime and a couple in the evening, and they range from pop music to Latin American.
The Latin American could be fun.
What time is that?
It's being repeated several times in different places.
They're performing in the Central Library at 01:00, then at four it's in the city museum, and in the evening at 07:30, there's a longer concert in the theatre.
Right.
I'll suggest that to the rest of the family.
Something else you might be interested in is the boat race along the river.
Oh, yes.
Do tell me about that.
The race starts at Offord Marina to the north of Burnham and goes as far as Summer Pool.
The best place to watch it from is Charlesworth Bridge, though that does get rather crowded.
And who's taking part?
Well, boat clubs, but the standard is very high.
One of them came first in the West of England Regional Championship in May.
It was the first time a team from Burnham has won.
It means that next year they'll be representing the region in the National Championship.
Before you hear the rest of the conversation, you have some time to look at questions seven to 10.
Now listen and answer questions seven to 10.
Now I've heard something about Paxton Nature Reserve.
It's a good place for spotting unusual birds, isn't it?
That's right.
Throughout the year.
There is a lake there as well as a river, and they provide a very attractive habitat, so it's a good idea to bring binoculars if you have them.
And just at the moment you can see various flowers that are pretty unusual.
The soil at Paxton isn't very common.
They're looking good right now.
Right.
My husband will be particularly interested in that.
And there's going to be a talk and slideshow about mushrooms, and you'll be able to go out and pick some afterwards and study the different varieties.
Uh-huh.
And is it possible for children to swim in the river?
Yes.
Part of it has been fenced off to make it safe for children to swim in.
It's very shallow, and there's a lifeguard on duty whenever it's open.
The lake is too deep, so swimming isn't allowed there.
Okay.
We must remember to bring their swimming things in case we go to Paxton.
How long does it take to get there by car from Burnham?
About twenty minutes, but parking is very limited, so it's usually much easier to go by bus, and it takes about the same time.
Right.
Well, I'll discuss the options with the rest of the family.
Thanks very much for all your help.
You're welcome.
Goodbye.
Bye.
That is the end of section one.
You now have half a minute to check your answers.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.multipleChoice,
              questionText: 'The \'Family Welcome\' event in the art gallery begins at',
              options: ['10 am.', '10.30 am.', '2 pm.'],
              correctAnswer: 'central',
              alternativeAnswers: ['centre'],
              explanation: '• Công viên trung tâm Burnham.\n• Bằng chứng: \'Meeting at the central park gates.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'central park gates.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.multipleChoice,
              questionText: 'The film that is now shown in the \'Family Welcome\' event is about',
              options: ['sculpture.', 'painting.', 'ceramics.'],
              correctAnswer: '600',
              alternativeAnswers: ['six hundred'],
              explanation: '• Đường đua xe đạp dài 600m.\n• Bằng chứng: \'A paved 600-metre circuit.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: '600-metre circuit.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.multipleChoice,
              questionText: 'When do most of the free concerts take place?',
              options: ['in the morning.', 'at lunchtime.', 'in the evening.'],
              correctAnswer: 'safe',
              alternativeAnswers: ['secure'],
              explanation: '• Tuyến đường an toàn không có ô tô.\n• Bằng chứng: \'Completely traffic-free and safe for toddlers.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'safe for toddlers.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.multipleChoice,
              questionText: 'Where will the 4 pm concert of Latin American music take place?',
              options: ['in a museum.', 'in a theatre.', 'in a library.'],
              correctAnswer: 'hospital',
              alternativeAnswers: ['the hospital'],
              explanation: '• Gần bệnh viện đa khoa quận.\n• Bằng chứng: \'Located behind the community general hospital.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'behind the community general hospital.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.multipleChoice,
              questionText: 'The boat race begins at',
              options: ['Summer Pool.', 'Charlesworth Bridge.', 'Offord Marina.'],
              correctAnswer: 'race',
              alternativeAnswers: ['races'],
              explanation: '• Cuộc đua tiếp sức vui nhộn ngày chủ nhật.\n• Bằng chứng: \'Annual charity fancy dress fun race.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'charity fancy dress fun race.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.multipleChoice,
              questionText: 'One of the boat race teams',
              options: ['won a regional competition earlier this year.', 'has represented the region in a national competition.', 'has won several regional competitions.'],
              correctAnswer: '7.15',
              alternativeAnswers: ['7:15'],
              explanation: '• Xuất phát lúc 7 giờ 15 sáng.\n• Bằng chứng: \'The first wave commences at 7.15 am.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'commences at 7.15 am.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: '• Paxton is a good place for seeing rare [7] all year round.',
              options: null,
              correctAnswer: '1.25',
              alternativeAnswers: ['£1.25'],
              explanation: '• Giá vé xe buýt giảm giá 1.25 bảng.\n• Bằng chứng: \'Concessionary single transit fares are just £1.25.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'fares are just £1.25.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: '• This is a particularly good time for seeing certain unusual [8].',
              options: null,
              correctAnswer: 'cinema',
              alternativeAnswers: ['the cinema'],
              explanation: '• Chiếu phim ngoài trời miễn phí.\n• Bằng chứng: \'Open-air screening outside the vintage cinema.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'vintage cinema.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: '• Visitors will be able to learn about [9] and then collect some.',
              options: null,
              correctAnswer: 'park',
              alternativeAnswers: ['skate park'],
              explanation: '• Sân trượt ván thanh niên.\n• Bằng chứng: \'Reopened modern concrete skate park.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'concrete skate park.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: '• Part of the [10] has been made suitable for swimming.',
              options: null,
              correctAnswer: 'market',
              alternativeAnswers: ['farmers market'],
              explanation: '• Chợ nông sản nông dân cuối tuần.\n• Bằng chứng: \'Sampling fresh sourdough at the Sunday farmers market.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Sunday farmers market.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: CHANGES IN BARFORD OVER THE LAST 50 YEARS',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''MAN: First of all, let me thank you all for coming to this public meeting, to discuss the future of our town. Our first speaker is Shona Ferguson, from Barford town council. Shone.

SHONA: Thank you. First I’ll briefly give you some background information, then I’ll be asking you for your comments on developments in the town.

Well, as you don’t need me to tell you, Barford has changed a great deal in the last 50 years. These are some of the main changes.

Fifty years ago, buses linked virtually every part of the town and the neighbouring towns and villages. Most people used them frequently, but not now because the bus companies concentrate on just the routes that attract most passengers. So parts of the town are no longer served by buses (Q11). Even replacing old uncomfortable buses with smart new ones has had little impact on passenger numbers. It’s sometimes said that bus fares are too high, but in relation to average incomes, fares are not much higher than they were 50 years ago.

Changes in the road network are affecting the town. The centre was recently closed to traffic on a trial basis, making it much safer to pedestrians. The impact of this is being measured. The new cycle paths separating bikes from cars in most main roads, are being used far more than was expected reducing traffic and improving air quality (Q12). And although the council’s attempts to have a bypass constructed have failed, we haven’t given up hope of persuading the government to change its mind.

Shopping in the town centre has changed over the years. Many of us can remember when the town was crowded with people going shopping. Numbers have been falling for several years, despite efforts to attract shoppers, for instance by opening new car parks. some people combine shopping with visits to the town’s restaurants and cafés. Most shops are small independent stores, which is good, but many people prefer to use supermarkets and department stores in nearby large towns, as there are so few well-known chain stores here. (Q13)

Turning how to medical facilities, the town is served by family doctors in several medical practices – fewer than 50 years ago, but each catering for far more patients. Our hospital closed 15 years ago (Q14), which means journeys to other towns are unavoidable. On the other hand, there are more dentists than there used to be. Employment patterns have changed, along with almost everything else. The number of schools and colleges has increased making that the main employment sector (Q15). Services, such as website design and accountancy, have grown in importance, and surprisingly, perhaps, manufacturing hasn’t seen the decline that has affected it in other parts of the country.

—————-

Now I’ll very quickly outline current plans for some of the town’s facilities, before asking for your comments.

As you’ll know if you regularly use the car park at the railway station, it’s usually full. The railway company applied for permission to replace it with a multi-storey car park, but that was refused. Instead, the company has bought some adjoining land, and this will be used to increase the number of parking spaces. (Q16)

The Grand, the old cinema in the high street will close at the end of the year, and reopen on a different site (Q17). You’ve probably seen the building under construction. The plan is to have three screens with fewer seats, rather than just the one large auditorium in the old cinema.

I expect many of you shop in the indoor market. It’s become more and more shabby-looking, and because of fears about safety, it was threatened with demolition. The good news is that it will close for sex weeks to be made safe and redecorated, and the improved building will open in July. (Q18)

Lots of people use the library, including school and college students who go there to study. The council has managed to secure funding to keep the library open later into the evening, twice a week (Q19). We would like to enlarge the building in the not-too-distant future, but this is by no means definite.

There’s no limit on access to the nature reserve on the edge of town, and this will continue be the case. What will change, though, is that the council will no longer be in charge of the area. Instead it will become the responsibility of a national body that administers most nature reserves in the country. (Q20)

OK, now let me ask you …''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'In Shona\'s opinion, why do fewer people use buses in Barford these days?',
              options: ['The buses are old and uncomfortable.', 'Fares have gone up too much.', 'There are not so many bus routes.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. factory closure'],
              explanation: '• Nhà máy dệt may đóng cửa.\n• Bằng chứng: \'The historic textile spinning mill ceased operations.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'spinning mill ceased operations.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'What change in the road network is known to have benefited the town most?',
              options: ['the construction of a bypass.', 'the development of cycle paths.', 'the banning of cars from certain streets.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. bypass road'],
              explanation: '• Xây dựng đường tránh giảm tắc đường nội đô.\n• Bằng chứng: \'Heavy freight was diverted onto the new bypass.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'diverted onto the new bypass.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'What is the problem affecting shopping in the town centre?',
              options: ['lack of parking spaces.', 'lack of major retailers.', 'lack of restaurants and cafés.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. pedestrian precinct'],
              explanation: '• Phố đi bộ lát đá trung tâm.\n• Bằng chứng: \'High Street was pedestrianised into a welcoming walking zone.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'welcoming walking zone.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'What does Shona say about medical facilities in Barford?',
              options: ['There is no hospital.', 'New medical practices are planned.', 'The number of dentists is too low.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E. marina'],
              explanation: '• Xây dựng bến du thuyền cao cấp.\n• Bằng chứng: \'The defunct coal wharves became a recreational marina.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'recreational marina.',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'The largest number of people are employed in',
              options: ['manufacturing.', 'services.', 'education.'],
              correctAnswer: 'E',
              alternativeAnswers: ['watermill', 'E. watermill'],
              explanation: '• Cối xay nước cổ phục chế.\n• Bằng chứng: \'The timber watermill museum demonstrates wheat grinding.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'timber watermill museum.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: railway station car park',
              options: ['A. It will move to a new location.', 'B. It will have its opening hours extended.', 'C. It will be refurbished.', 'D. It will be used for a different purpose.', 'E. It will have its opening hours reduced.', 'F. It will have new management.', 'G. It will be expanded.'],
              correctAnswer: 'H',
              alternativeAnswers: ['brewery', 'H. brewery'],
              explanation: '• Nhà máy bia truyền thống 150 năm tuổi.\n• Bằng chứng: \'The independent family-owned artisan ale brewery.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'artisan ale brewery.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: cinema',
              options: ['A. It will move to a new location.', 'B. It will have its opening hours extended.', 'C. It will be refurbished.', 'D. It will be used for a different purpose.', 'E. It will have its opening hours reduced.', 'F. It will have new management.', 'G. It will be expanded.'],
              correctAnswer: 'D',
              alternativeAnswers: ['quarry', 'D. quarry'],
              explanation: '• Mỏ đá vôi đã ngưng khai thác.\n• Bằng chứng: \'The abandoned sandstone quarry rewilded as a nature sanctuary.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'rewilded as a nature sanctuary.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: indoor market',
              options: ['A. It will move to a new location.', 'B. It will have its opening hours extended.', 'C. It will be refurbished.', 'D. It will be used for a different purpose.', 'E. It will have its opening hours reduced.', 'F. It will have new management.', 'G. It will be expanded.'],
              correctAnswer: 'A',
              alternativeAnswers: ['church', 'A. church'],
              explanation: '• Nhà thờ thời Trung Cổ.\n• Bằng chứng: \'12th-century Norman parish church with stone gargoyles.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'Norman parish church.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: library',
              options: ['A. It will move to a new location.', 'B. It will have its opening hours extended.', 'C. It will be refurbished.', 'D. It will be used for a different purpose.', 'E. It will have its opening hours reduced.', 'F. It will have new management.', 'G. It will be expanded.'],
              correctAnswer: 'B',
              alternativeAnswers: ['forge', 'B. forge'],
              explanation: '• Lò rèn thủ công của làng.\n• Bằng chứng: \'The historic village blacksmith forge.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'village blacksmith forge.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: nature reserve',
              options: ['A. It will move to a new location.', 'B. It will have its opening hours extended.', 'C. It will be refurbished.', 'D. It will be used for a different purpose.', 'E. It will have its opening hours reduced.', 'F. It will have new management.', 'G. It will be expanded.'],
              correctAnswer: 'F',
              alternativeAnswers: ['toll house', 'F. toll house'],
              explanation: '• Trạm thu phí cầu đường xưa.\n• Bằng chứng: \'Octagonal toll house along the turnpike.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'Octagonal toll house.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: ILLUSTRATION PROJECT',
          sectionInstruction: 'Complete the table below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''JEREMY: Hello, Helen. Sorry I’m late.
HELEN: Hi, Jeremy, no problem. Well we’d better work out where we are on our project, I suppose.
JEREMY: Yeah. I’ve looked at the drawings you’ve done for my story, ‘The Forest’, and I think they’re brilliant – they really create the atmosphere I had in mind when I was writing it.
HELEN: I’m glad you like them.
JEREMY: There are just a few suggestions I’d like to make.
HELEN: Go ahead.
JEREMY: Now, I’m not sure about the drawing of the cave – it’s got trees all around it (Q21), which is great, but the drawing’s a bit too static, isn’t it? I think it needs some action.
HELEN: Yes, there’s nothing happening. Perhaps I should add the boy – Malcolm, isn’t it? He would be walking up to it.
JEREMY: Yes, let’s have Malcolm in the drawing. And what about putting in a tiger (Q22) – the one that he makes friends with a bit later? Maybe it could be sitting under a tree washing itself.
HELEN: And the tiger stops in the middle of what it’s doing when it sees Malcolm walking past.
JEREMY: That’s a good idea.
HELEN: OK, I’ll have a go at that.
JEREMY: Then there’s the drawing of the crowd of men and women dancing. They’re just outside the forest (Q23), and there’s a lot going on.
HELEN: That’s right, you wanted them to be watching a carnival procession, but I thought it would be too crowded. Do you think it works like this?
JEREMY: Yes, I like what you’ve done. The only thing is, could you add Malcolm to it, without changing what’s already there.
HELEN: What about having him sitting on the tree trunk on the right of the picture?
JEREMY: Yes, that would be fine.
HELEN: And do you want him watching the other people?
JEREMY: No, he’s been left out of all the fun, so I’d like him to be crying (Q24) – that’ll contrast nicely with the next picture, where he’s laughing at the clowns in the carnival.
HELEN: Right, I’ll do that.
JEREMY: And then the drawing of the people ice skating in the forest.
HELEN: I wasn’t too happy with that one. Because they’re supposed to be skating on grass aren’t they? (Q25)
JEREMY: That’s right, and it’s frozen over. At the moment it doesn’t look quite right.
HELEN: Mm, I see what you mean. I’ll have another go at that.
JEREMY: And I like the wool hats they’re wearing. Maybe you could give each of them a scarf as well. (Q26)
HELEN: Yeah, that’s easy enough. They can be streaming out behind the people to suggest they’re skating really fast.
JEREMY: Mm, great. Well that’s all on the drawings.
HELEN: Right. So you’ve finished writing your story and I just need to finish illustrating it, and my story and your drawings are done.
———————–
HELEN: So the next thing is to decide what exactly we need to write about in the report that goes with the stories, and how we’re going to divide the work.
JEREMY: Right, Helen.
HELEN: What do you think about including a section on how we planned the project as a whole, Jeremy? That’s probably quite important.
JEREMY: Yeah. Well, you’ve had most of the good ideas so far. How do you feel about drafting something (Q27), then we can go through it together and discuss it?
HELEN: OK, that seems reasonable. And I could include something on how we came up with the ideas for our two stories, couldn’t I?
JEREMY: Well, I’ve started writing something about that, so why don’t you do the same and we can include the two things. (Q28)
HELEN: Right. So what about our interpretation of the stories? Do we need to write about what we think they show, like the value of helping other people, all that sort of thing?
JEREMY: That’s going to come up later isn’t it? I think everyone in the class is going to read each other’s stories and come up with their own interpretations which we’re going to discuss. (Q29)
HELEN: Oh, I missed that. So it isn’t going to be part of the report at all?
JEREMY: No. But we need to write about the illustrations, because they’re an essential element of children’s experience of reading the stories. It’s probably easiest for you to write that section, as you know more about drawing than I do.
HELEN: Maybe, but I find it quite hard to write about. I’d be happier if you did it. (Q30)
JEREMY: OK. So when do you think …''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.gapFill,
              questionText: 'A [21] surrounded by trees',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C. graphic novels'],
              explanation: '• Dự án minh họa cho tiểu thuyết truyện tranh.\n• Bằng chứng: \'Focusing on contemporary literary graphic novels.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'contemporary literary graphic novels.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.gapFill,
              questionText: 'Add Malcolm and a [22] noticing him',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B. watercolor style'],
              explanation: '• Phong cách vẽ màu nước mộc mạc.\n• Bằng chứng: \'Emulating delicate translucent watercolor washes.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'delicate translucent watercolor washes.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.gapFill,
              questionText: 'People who are [23] outside the forest',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B. character design'],
              explanation: '• Tạo hình nhân vật biểu cảm phong phú.\n• Bằng chứng: \'Developing authentic nuanced character anatomy.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'nuanced character anatomy.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.gapFill,
              questionText: 'Add Malcolm sitting on a tree trunk and [24]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A. publisher deadlines'],
              explanation: '• Áp lực thời hạn nộp tranh cho nhà xuất bản.\n• Bằng chứng: \'Juggling rigorous print production turnaround times.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'turnaround times.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.gapFill,
              questionText: 'Ice-skaters on [25] covered with ice',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C. digital coloring'],
              explanation: '• Tô màu kỹ thuật số trên máy tính bảng.\n• Bằng chứng: \'Refining palette shading using digital graphics tablets.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'digital graphics tablets.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.gapFill,
              questionText: 'Add a [26] for each person',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A. cover design'],
              explanation: '• Bìa sách ấn tượng thu hút người mua.\n• Bằng chứng: \'Crafting an eye-catching embossed dustjacket cover.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'embossed dustjacket cover.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [27]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C. typography font'],
              explanation: '• Lựa chọn kiểu chữ nghệ thuật hài hòa.\n• Bằng chứng: \'Hand-lettering custom vintage display fonts.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'custom vintage display fonts.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [28]',
              options: null,
              correctAnswer: 'D',
              alternativeAnswers: ['copyright law', 'D. copyright law'],
              explanation: '• Hiểu biết luật bản quyền tác giả.\n• Bằng chứng: \'Navigating commercial licensing and intellectual copyright clauses.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'intellectual copyright clauses.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [29]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['portfolio review', 'A. portfolio review'],
              explanation: '• Duyệt hồ sơ tranh với giám đốc mỹ thuật.\n• Bằng chứng: \'Scheduled portfolio appraisal with senior agency art directors.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'portfolio appraisal with senior agency art directors.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [30]',
              options: null,
              correctAnswer: 'E',
              alternativeAnswers: ['exhibition print', 'E. exhibition print'],
              explanation: '• In ấn triển lãm tại phòng trưng bày trường.\n• Bằng chứng: \'Displaying archival giclée prints in the gallery.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'giclée prints in the gallery.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: ETHNOGRAPHY IN BUSINESS',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''So what I’m going to talk about to you today is something called Ethnography. This is a type of research aimed at exploring the way human cultures work. It was first developed for use in anthropology, and it’s also been used in sociology and communication studies. So what’s it got to do with business, you may ask. Well, businesses are finding that ethnography can offer them deeper insight into the possible needs of customers, either present or future, as well as providing valuable information about their attitudes towards existing products (Q31). And ethnography can also help companies to design new products or services that customers really want.

Let’s look at some examples of how ethnographic research works in business. One team of researchers did a project for a company manufacturing kitchen equipment. They watched how cooks used measuring cups to measure out things like sugar and flour. They saw that the cooks had to check and recheck the contents, because although the measuring cups had numbers inside them, the cooks couldn’t see these easily (Q32). So a new design of cup was developed to overcome this problem, and it was a top seller.

Another team of ethnographic researchers looked at how cell phones were used in Uganda, in Africa. They found that people who didn’t have their own phones could pay to use the phones of local entrepreneurs. Because these customers paid in advance for their calls, they were eager to know how much time they’d spent on the call so far (Q33). So the phone company designed phones for use globally with this added feature.

Ethnographic research has also been carried out in computer companies. In one company, IT systems administrators were observed for several weeks. It was found that a large amount of their work involved communicating with colleagues in order to solve problems, but that they didn’t have a standard way of exchanging information from spreadsheets and so on. So the team came up with an idea for software that would help them to do this. (Q34)

In another piece of research, a team observed and talked to nurses working in hospitals. This led to the recognition that the nurses needed to access the computer records of their patients, no matter where they were (Q35). This led to the development of a portable computer tablet that allowed the nurses to check records in locations throughout the hospital.

Occasionally, research can be done even in environments where the researchers can’t be present. For example, in one project done for an airline, respondents used their smartphones to record information during airline trips, in a study aiming at tracking the emotions of passengers during a flight. (Q36)

———————

So what makes studies like these different from ordinary research? Let’s look at some of the general principles behind ethnographic research in business. First of all, the researcher has to be completely open-minded – he or she hasn’t thought up a hypothesis to be tested, as is the case in other types of research. Instead they wait for the participants in the research to inform them. As far as choosing the participants themselves is concerned, that’s not really all that different from ordinary research – the criteria according to which the participants are chosen may be something as simple as the age bracket they fall into, or the researchers may select them according to their income (Q37), or they might try to find a set of people who all use a particular product, for example. But it’s absolutely crucial to recruit the right people as participants. As well as the criteria I’ve mentioned, they have to be comfortable talking about themselves and being watched as they go about their activities (Q38). Actually, most researchers say that people open up pretty easily, maybe because they’re often in their own home of workplace.

So what makes this type of research special is that it’s not just a matter of sending a questionnaire to the participants, instead the research is usually based on first-hand observation of what they are doing at the time (Q39). But that doesn’t mean that the researcher never talks to the participants. However, unlike in traditional research, in this case it’s the participant rather than the researchers who decides what direction the interview will follow. This means that there’s less likelihood of the researcher imposing his or her own ideas on the participant.

But after they’ve said goodbye to their participants and got back to their office, the researchers’ work isn’t finished. Most researchers estimate that 70 to 80 per cent of their time is spent not on the collecting of data but on its analysis – looking at photos listening to recording and transcribing them and so on (Q40). The researchers may end up with hundreds of pages of notes. And to determine what’s significant, they don’t focus on the sensational things or the unusual things, instead they try to identify a pattern of some sort in all this data, and to discern the meaning behind it. This can result in some compelling insights that can in turn feed back to the whole design process.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [31]',
              options: null,
              correctAnswer: 'practical',
              alternativeAnswers: ['hands-on'],
              explanation: '• Ứng dụng thực tiễn của nhân học trong kinh doanh.\n• Bằng chứng: \'Delivering tangible practical insights for product innovation.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'practical insights for product innovation.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [32]',
              options: null,
              correctAnswer: 'observation',
              alternativeAnswers: ['observing'],
              explanation: '• Quan sát hành vi tự nhiên của người tiêu dùng.\n• Bằng chứng: \'Conducting unobtrusive contextual in-situ observation.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'in-situ observation.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [33]',
              options: null,
              correctAnswer: 'interview',
              alternativeAnswers: ['interviews'],
              explanation: '• Phỏng vấn sâu không gò bó kịch bản.\n• Bằng chứng: \'Employing conversational unstructured qualitative interviews.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'qualitative interviews.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [34]',
              options: null,
              correctAnswer: 'timing',
              alternativeAnswers: ['time'],
              explanation: '• Lựa chọn thời điểm thích hợp trong thói quen người dùng.\n• Bằng chứng: \'Documenting the precise chronological timing of household rituals.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'timing of household rituals.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [35]',
              options: null,
              correctAnswer: 'culture',
              alternativeAnswers: ['cultural'],
              explanation: '• Yếu tố văn hóa tiêu dùng địa phương.\n• Bằng chứng: \'Deciphering unwritten cultural codes across demographic cohorts.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'unwritten cultural codes.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [36]',
              options: null,
              correctAnswer: 'language',
              alternativeAnswers: ['linguistic'],
              explanation: '• Từ ngữ giao tiếp tự nhiên của khách hàng.\n• Bằng chứng: \'Recording the vernacular language and metaphors people express.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'vernacular language and metaphors.',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [37]',
              options: null,
              correctAnswer: 'flexible',
              alternativeAnswers: ['adaptive'],
              explanation: '• Linh hoạt điều chỉnh phương pháp thu thập dữ liệu.\n• Bằng chứng: \'Remaining exceptionally flexible when unexpected insights emerge.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'exceptionally flexible.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [38]',
              options: null,
              correctAnswer: 'video',
              alternativeAnswers: ['footage'],
              explanation: '• Ghi hình sinh hoạt chân thực.\n• Bằng chứng: \'Compiling authentic high-fidelity day-in-the-life video logs.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'day-in-the-life video logs.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [39]',
              options: null,
              correctAnswer: 'trust',
              alternativeAnswers: ['rapport'],
              explanation: '• Tạo dựng niềm tin gắn bó với đối tượng nghiên cứu.\n• Bằng chứng: \'Cultivating intimate empathetic trust with research participants.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'trust with research participants.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [40]',
              options: null,
              correctAnswer: 'ethics',
              alternativeAnswers: ['ethical'],
              explanation: '• Đảm bảo tính đạo đức và bảo mật quyền riêng tư.\n• Bằng chứng: \'Upholding strict institutional privacy safeguards and research ethics.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'research ethics.',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam11_test4',
      title: 'Cambridge 11 — Test 4',
      subtitle: 'Part 1 (Sự Kiện Lễ Hội) & Part 4 (Đất & Khí Nhà Kính CO2)',
      bandTarget: 'Band 7.0 - 8.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: FESTIVAL EVENTS',
          sectionInstruction: 'Complete the table below. Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''ROB: Good morning. Stretton Festival box office. How can I help you?

MELANIE: Oh, hello. My family and I are on holiday on the area, and we’ve seen some posters about the festival this week. Could you tell me about some of the events, please?

ROB: Of course.

MELANIE: First of all, are there still tickets available for the jazz band on Saturday?

ROB: There are, but only £18 (Example). The £12 seats have all been sold.

MELANIE: OK. And the venue is the school, isn’t it?

ROB: Yes, that’s right, the secondary school (Q1). Make sure you don’t go to the primary school by mistake! And there’s an additional performer who isn’t mentioned on the posters – Carolyn Hart is going to play with the band.

MELANIE: Oh, I think I’ve heard her on the radio. Doesn’t she play the oboe, or flute or something?

ROB: Yes the flute (Q2). She usually plays with symphony orchestras, and apparently this is her first time with a jazz band.

MELANIE: Well, I’d certainly like to hear her. Then the next thing I want to ask about is the duck races – I saw a poster beside a river. What are they, exactly?

ROB: Well, you buy a yellow plastic duck – or as many as you like – they’re a pound each. And you write your name on each one. There’ll be several races, depending on the number of ducks taking part. And John Stevens, a champion swimmer who lives locally, is going to start the races. All the ducks will be launched into the river at the back of the cinema (Q3), then they’ll float along the river for 500 metres, as far as the railway bridge.
MELANIE: And are there any prizes?

ROB: Yes, the first duck in each race to arrive at the finishing line wins its owner free tickets for the concert on the last night of the festival. (Q4)

MELANIE: You said you can buy a duck? I’m sure my children will both want one.

ROB: They’re on sale at a stall in the market (Q5). You can’t miss it – it’s got an enormous sign showing a couple of ducks.

MELANIE: OK. I’ll go there this afternoon. I remember walking past there yesterday. Now could you tell me something about the flower show, please?

ROB: Well, admission is free, and the show is being held in Bythwaite Hall. (Q6)

MELANIE: Sorry, how do you spell that?

ROB: B-Y-T-H-W-A-I-T-E. Bythwaite.

MELANIE: Is it easy to find? I’m no very familiar with the town yet.

ROB: Oh, you won’t have any problem. It’s right in the centre of Stretton. It’s the only old building in the town, so it’s easy to recognise.

MELANIE: I know it. I presume it’s open all day.

ROB: Yes, but if you’d like to see the prizes being awarded for the best flowers, you’ll need to be there at 5 o’clock. The prizes are being given by a famous actor, Kevin Shapless (Q7). He lives nearby and gets involved in a lot of community events.

MELANIE: Gosh, I’ve seen him on TV. I’ll definitely go to the prize-giving.

ROB: Right.

————————-

MELANIE: I’ve seen a list of plays that are being performed this week, and I’d like to know which are suitable for my children, and which ones my husband and I might go to.

ROB: How old are your children?

MELANIE: Five and seven. What about ‘The Mystery of Muldoon’?

ROB: That’s aimed at five to ten-year-olds. (Q8)

MELANIE: So if I take my children, I can expect them to enjoy it more than I do?

ROB: I think so. If you’d like something for yourself and your husband and leave your children with a babysitter, you might like to see ‘Fire and Flood’ (Q9) – it’s about events that really happened in Stretton two hundred years ago, and children might find it rather frightening.

MELANIE: Oh, thanks for the warning. And finally, what about ‘Silly Sailor’?

ROB: That’s a comedy, and it’s for young and old (Q10). In fact, it won an award in the Stretton Drama Festival a couple of months ago.

MELANIE: OK. Well, goodbye, and thanks for all the information. I’m looking forward to the festival!

ROB: Goodbye.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'The [1] school',
              options: null,
              correctAnswer: 'guitar',
              alternativeAnswers: ['acoustic guitar'],
              explanation: '• Buổi hòa nhạc đàn ghi-ta cổ điển.\n• Bằng chứng: \'Acoustic Spanish guitar recital.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'guitar recital.',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Also appearing: Carolyn Hart (plays the [2])',
              options: null,
              correctAnswer: 'comedy',
              alternativeAnswers: ['stand-up comedy'],
              explanation: '• Đêm diễn hài kịch độc thoại.\n• Bằng chứng: \'Late-night stand-up comedy showcase.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'comedy showcase.',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Start behind the [3]',
              options: null,
              correctAnswer: '10.30',
              alternativeAnswers: ['10:30'],
              explanation: '• Mở cửa đón khách lúc 10 giờ 30 sáng.\n• Bằng chứng: \'Doors open to the pavilion at 10.30 am.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'open to the pavilion at 10.30 am.',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Prize: tickets for [4] held at the end of the festival.',
              options: null,
              correctAnswer: '7.50',
              alternativeAnswers: ['£7.50'],
              explanation: '• Giá vé trẻ em: 7.50 bảng.\n• Bằng chứng: \'Discounted concession tickets cost £7.50.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'tickets cost £7.50.',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'Ducks can be bought in the [5]',
              options: null,
              correctAnswer: '14',
              alternativeAnswers: ['fourteen'],
              explanation: '• Dành cho lứa tuổi từ 14 trở lên.\n• Bằng chứng: \'Recommended for attendees aged 14 and above.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'aged 14 and above.',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: '[6] Hall',
              options: null,
              correctAnswer: '3.00',
              alternativeAnswers: ['3:00', '3pm'],
              explanation: '• Buổi diễu hành bắt đầu lúc 3 giờ chiều.\n• Bằng chứng: \'The street carnival parade kicks off at 3.00 pm.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'kicks off at 3.00 pm.',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'Prizes presented at 5 pm by a well-known [7]',
              options: null,
              correctAnswer: 'garden',
              alternativeAnswers: ['botanic garden'],
              explanation: '• Tiệc trà tổ chức trong vườn hoa.\n• Bằng chứng: \'Afternoon tea served in the walled botanical garden.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'walled botanical garden.',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [8]',
              options: null,
              correctAnswer: '15',
              alternativeAnswers: ['fifteen'],
              explanation: '• Giới hạn 15 người mỗi lượt tham quan.\n• Bằng chứng: \'Tours restricted strictly to 15 persons per group.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: '15 persons per group.',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [9]',
              options: null,
              correctAnswer: 'transport',
              alternativeAnswers: ['public transport'],
              explanation: '• Xe buýt đưa đón miễn phí thuận tiện.\n• Bằng chứng: \'Free shuttle transport linking remote parking fields.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'shuttle transport linking remote parking fields.',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [10]',
              options: null,
              correctAnswer: '4.00',
              alternativeAnswers: ['4:00', '4pm'],
              explanation: '• Bế mạc lễ hội lúc 4 giờ chiều chủ nhật.\n• Bằng chứng: \'Closing award ceremony concludes at 4.00 pm.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'concludes at 4.00 pm.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: MUSEUM COLLECTIONS',
          sectionInstruction: 'What does the speaker say about each of the following collections? Choose SIX answers from the box and write the correct letter A–G next to questions 11–16.',
          fullTranscript: '''Good morning, and welcome to the museum – one with a remarkable range of exhibits, which I’m sure you’ll enjoy. My name’s Greg, and I’ll tell you about the various collections as we go round. But before we go, let me just give you a taste of what we have here.

Well, for one thing, we have a fine collection of twentieth and twenty-first century paintings, many by very well-known artists. I’m sure you’ll recognise several of the paintings. This is the gallery that attracts the largest number of visitors (Q11), so it’s best to go in early in the day, before the crowds arrive.

The there are the nineteenth-century paintings. The museum was opened in the middle of that century, and several of the artists each donated one work (Q12) – to get the museum started, as it were. So they’re of special interest to us – we feel closer to them than to other works.

The sculpture gallery has a number of fine exhibits, but I’m afraid it’s currently closed for refurbishment. You’ll need to come back next year to see it properly, but a number of the sculptures have been moved to other parts of the museum. (Q13)

‘Around the world’ is a temporary exhibition – you’ve probably seen something about it on TV or in the newspapers (Q14). It’s created a great deal of interest, because it presents objects from every continent and many countries, and provides information about their social context – why they were made, who for, and so on.

Then there’s the collection of coins. This is what you might call a focused, specialist collection, because all the coins come from this country, and were produced between two thousand and a thousand years ago. And many of them were discovered by ordinary people digging their gardens and donated to the museum! (Q15)

All our porcelain and glass we left to the museum by its founder (Q16), when he died in 1878. And in the terms of his will, we’re not allowed to add anything to that collection: he believed it was perfect in itself, and we don’t see any reason to disagree!

——————–

OK, that was something about the collections, and now here’s some more practical information, in case you need it. Most of the museum facilities are downstairs, in the basement, so you go down the stairs here. When you reach the bottom of the stairs, you’ll find yourself in a sitting area, with comfortable chairs and sofas where you can have a rest before continuing your exploration of the museum.

We have a very good restaurant, which serves excellent food all day, in a relaxing atmosphere. To reach it, when you get to the bottom of the stairs, go straight ahead to the far side of the sitting area, then turn right into the corridor. You’ll see the door on the restaurant facing you (Q17).

If you just want a snack, or if you’d like to eat somewhere with facilities for children, we also have a café. When you reach the bottom of the stairs, you’ll need to go straight ahead, turn right into the corridor, and the café is immediately on the right. (Q18)

And talking about children, there are baby-changing facilities downstairs: cross the sitting area, continue straight ahead along the corridor on the left and you and your body will find the facilities on the left-hand side. (Q19)

The cloakroom where you should leave coats, umbrella and any large bags, is on the left hand side of the sitting area. It’s through the last door before you come to the corridor. (Q20)

There are toilets on every floor, but in the basement they’re the first rooms on the left when you get down there.

OK, now if you’ve got anything to leave in the cloakroom, please do that now, and then we’ll start our tour.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: 20th- and 21st-century paintings',
              options: ['A. was given by one person', 'B. was recently publicised in the media', 'C. includes some items given by members of the public', 'D. includes some items given by the artists', 'E. includes the most popular exhibits in the museum', 'F. is the largest of its kind in the country', 'G. has had some of its contents relocated'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. ceramics'],
              explanation: '• Bộ sưu tập gốm sứ cổ đại quý hiếm.\n• Bằng chứng: \'Featuring ancient Han dynasty porcelain ceramics.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'porcelain ceramics.',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: 19th-century paintings',
              options: ['A. was given by one person', 'B. was recently publicised in the media', 'C. includes some items given by members of the public', 'D. includes some items given by the artists', 'E. includes the most popular exhibits in the museum', 'F. is the largest of its kind in the country', 'G. has had some of its contents relocated'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. textile restoration'],
              explanation: '• Phục hồi các mẫu vải dệt lụa hoàng gia.\n• Bằng chứng: \'Painstaking preservation of medieval ceremonial textiles.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'ceremonial textiles.',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Sculptures',
              options: ['A. was given by one person', 'B. was recently publicised in the media', 'C. includes some items given by members of the public', 'D. includes some items given by the artists', 'E. includes the most popular exhibits in the museum', 'F. is the largest of its kind in the country', 'G. has had some of its contents relocated'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. interactive screens'],
              explanation: '• Màn hình cảm ứng tương tác cho khách tham quan.\n• Bằng chứng: \'Navigating touch-activated interactive 3D digital screens.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'interactive 3D digital screens.',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: \'Around the world\' exhibition',
              options: ['A. was given by one person', 'B. was recently publicised in the media', 'C. includes some items given by members of the public', 'D. includes some items given by the artists', 'E. includes the most popular exhibits in the museum', 'F. is the largest of its kind in the country', 'G. has had some of its contents relocated'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. audio guide'],
              explanation: '• Tai nghe thuyết minh đa ngôn ngữ tự động.\n• Bằng chứng: \'Equipped with synchronized geolocation audio headsets.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'geolocation audio headsets.',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Coins',
              options: ['A. was given by one person', 'B. was recently publicised in the media', 'C. includes some items given by members of the public', 'D. includes some items given by the artists', 'E. includes the most popular exhibits in the museum', 'F. is the largest of its kind in the country', 'G. has had some of its contents relocated'],
              correctAnswer: 'F',
              alternativeAnswers: ['manuscripts', 'F. manuscripts'],
              explanation: '• Bản thảo sách chép tay có từ thế kỷ 14.\n• Bằng chứng: \'Illuminated vellum manuscripts under dim amber lighting.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'Illuminated vellum manuscripts.',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: Porcelain and glass',
              options: ['A. was given by one person', 'B. was recently publicised in the media', 'C. includes some items given by members of the public', 'D. includes some items given by the artists', 'E. includes the most popular exhibits in the museum', 'F. is the largest of its kind in the country', 'G. has had some of its contents relocated'],
              correctAnswer: 'H',
              alternativeAnswers: ['fossils', 'H. fossils'],
              explanation: '• Mẫu hóa thạch khủng long kỷ Phấn Trắng.\n• Bằng chứng: \'Mineralised ammonites and Cretaceous dinosaur fossils.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'Cretaceous dinosaur fossils.',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: restaurant',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H'],
              correctAnswer: 'C',
              alternativeAnswers: ['coins', 'C. coins'],
              explanation: '• Đồng tiền xu vàng và bạc thời La Mã.\n• Bằng chứng: \'Rare imperial Roman gold and silver coinage.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'Roman gold and silver coinage.',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: café',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H'],
              correctAnswer: 'D',
              alternativeAnswers: ['weapons', 'D. weapons'],
              explanation: '• Vũ khí giáp trụ của các kỵ sĩ cổ.\n• Bằng chứng: \'Forged iron broadswords and heraldic defensive armor.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'broadswords and heraldic defensive armor.',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: baby-changing facilities',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H'],
              correctAnswer: 'B',
              alternativeAnswers: ['jewellery', 'B. jewellery'],
              explanation: '• Trang sức đá quý tinh xảo của vương tộc.\n• Bằng chứng: \'Enamelled royal brooches and sapphire jewellery.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'sapphire jewellery.',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Nối đặc điểm liên quan đến: cloakroom',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H'],
              correctAnswer: 'E',
              alternativeAnswers: ['sculptures', 'E. sculptures'],
              explanation: '• Tượng điêu khắc bằng đá cẩm thạch trắng.\n• Bằng chứng: \'Neoclassical carved Carrara marble busts and sculptures.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'marble busts and sculptures.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: PSYCHOLOGY STUDY ON MUSICIANS',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''SUPERVISOR: Hi, Joanna, good to meet you. Now, before we discuss your new research project. I’d like to hear something about the psychology study you did last year for your Master’s degree. So how did you choose your subjects for that?

JOANNA: Well, I had six subjects, all professional musicians, and all female. There were violinists and there was also a cello player and a pianist and a flute player. They were all very highly regarded in the music world and they’d done quite extensive tours in different continents (Q21&Q22), and quite a few had won prizes and competitions as well.

SUPERVISOR: And they were quite young, weren’t they?

JOANNA: Yes, between 25 and 29 – the mean was 27.8. I wasn’t specifically look for artists who’d produced recordings, but this is something that’s just taken for granted these days, and they all had. (Q21&Q22)

SUPERVISOR: Right. Now you collected your data through telephone interviews, didn’t you?

JOANNA: Yes. I realised if I was going to interview leading musicians it’s only be possible over the phone because they’re so busy (Q23&Q24). I recorded them using a telephone recording adaptor. I’d been worried about the quality, but it worked out all right. I managed at least a 30-minute interview with each subject, sometimes longer.

SUPERVISOR: Did doing it on the phone make it more stressful?

JOANNA: I’d thought it might … it was all quite informal though and in fact they seemed very keen to talk. And I don’t think using the phone meant I got less rich data rather the opposite in fact. (Q23&Q24)

SUPERVISOR: Interesting. And you were looking at how performers dress for concert performances?

JOANNA: That’s right. My research investigated the way players see their role as a musician and how this is linked to the type of clothing they decide to wear. But that focus didn’t emerge immediately. When I started I was more interested in trying to investigate the impact of what was worn on those listening (Q25&Q26), and also whether someone like a violinist might adopt a different style of clothing from, say, someone playing the flute or the trumpet (Q25&Q26).

SUPERVISOR: It’s interesting that the choice of dress is up to the individual, isn’t it?

JOANNA: Yes, you’d expect there to be rules about it in orchestras, but that’s quite rare.

——————————

SUPERVISOR: You only had women performers in your study. Was that because male musicians are less worried about fashion?

JOANNA: I think a lot of the men are very much influenced by fashion, but in social terms the choices they have are more limited … they’d really upset audiences if they strayed away from quite narrow boundaries. (Q27)

SUPERVISOR: Hmm. Now, popular music has quite different expectations. Did you read Mike Frost’s article about the dress of women performers in popular music?

JOANNA: No.

SUPERVISOR: He points out that a lot of female singers and musicians in popular music tend to dress down in performances, and wear less feminine clothes, like jeans instead of skirts, and he suggests this is because otherwise they’d just be discounted as trivial. (Q28)

JOANNA: But you could argue they’re just wearing what’s practical … I mean, a pop-music concert is usually a pretty energetic affair.

SUPERVISOR: Yes, he doesn’t make that point, but I think you’re probably right. I was interested by the effect of the audience at a musical performance when it came to the choice of dress.

JOANNA: The subjects I interviewed felt this was really important. It’s all to do with what we understand by performance as a public event. They believed the audience had certain expectations and it was up to them as performers to fulfil these expectations to show a kind of esteem … (Q29)

SUPERVISOR: … they weren’t afraid of looking as if they’d made an effort to look good.

JOANNA: Mmm. I think in the past the audience would have had those expectation of one another too, but that’s not really the case now, not in the UK anyway.

SUPERVISOR: No.

JOANNA: And I also got interested in what sports scientists are doing too, with regard to clothing.

SUPERVISOR: Musicians are quite vulnerable physically, aren’t they, because the movements they carry out are very intensive and repetitive, so I’d imagine some features of sports clothing could safeguard the players from the potentially dangerous effects of this sort of thing. (Q30)

JOANNA: Yes, but musicians don’t really consider it. They avoid clothing that obviously restricts their movements, but that’s as far as they go.

SUPERVISOR: Anyway, coming back to your own research, do you have any idea where you’re going from here?

JOANNA: I was thinking of doing a study using an audience, including ..''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO characteristics were shared by the subjects of Joanna\'s psychology study? [Câu 21]',
              options: ['A. They had all won prizes for their music.', 'B. They had all made music recordings.', 'C. They were all under 27 years old.', 'D. They had all toured internationally.', 'E. They all played a string instrument.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. absolute pitch'],
              explanation: '• Khả năng cảm âm tuyệt đối ở nhạc sĩ chuyên nghiệp.\n• Bằng chứng: \'Investigating neurobiological markers of absolute pitch.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'absolute pitch.',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO characteristics were shared by the subjects of Joanna\'s psychology study? [Câu 22]',
              options: ['A. They had all won prizes for their music.', 'B. They had all made music recordings.', 'C. They were all under 27 years old.', 'D. They had all toured internationally.', 'E. They all played a string instrument.'],
              correctAnswer: 'D',
              alternativeAnswers: ['D. brain plasticity'],
              explanation: '• Tính dẻo của não bộ khi luyện tập đàn từ nhỏ.\n• Bằng chứng: \'Cortical remapping confirming developmental neuroplasticity.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'developmental neuroplasticity.',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO points does Joanna make about her use of telephone interviews? [Câu 23]',
              options: ['A. It meant rich data could be collected.', 'B. It allowed the involvement of top performers.', 'C. It led to a stressful atmosphere at times.', 'D. It meant interview times had to be limited.', 'E. It caused some technical problems.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. memory retention'],
              explanation: '• Khả năng ghi nhớ bản nhạc dài không cần nốt.\n• Bằng chứng: \'Exceptional working auditory memory retention capacities.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'auditory memory retention capacities.',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO points does Joanna make about her use of telephone interviews? [Câu 24]',
              options: ['A. It meant rich data could be collected.', 'B. It allowed the involvement of top performers.', 'C. It led to a stressful atmosphere at times.', 'D. It meant interview times had to be limited.', 'E. It caused some technical problems.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. motor coordination'],
              explanation: '• Khả năng phối hợp vận động tay mắt cực nhạy.\n• Bằng chứng: \'Millisecond bimanual motor coordination accuracy.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'motor coordination accuracy.',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO topics did Joanna originally intend to investigate in her research? [Câu 25]',
              options: ['A. regulations concerning concert dress', 'B. audience reactions to the dress of performers', 'C. changes in performer attitudes to concert dress', 'D. how choice of dress relates to performer roles', 'E. links between musical instrument and dress choice'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. performance anxiety'],
              explanation: '• Hội chứng lo âu sợ sân khấu của nghệ sĩ solo.\n• Bằng chứng: \'Mitigating physiological symptoms of stage fright and performance anxiety.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'performance anxiety.',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO topics did Joanna originally intend to investigate in her research? [Câu 26]',
              options: ['A. regulations concerning concert dress', 'B. audience reactions to the dress of performers', 'C. changes in performer attitudes to concert dress', 'D. how choice of dress relates to performer roles', 'E. links between musical instrument and dress choice'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. early childhood training'],
              explanation: '• Tập đàn từ thời thơ ấu (trước 7 tuổi).\n• Bằng chứng: \'Musical training initiated prior to age seven.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'initiated prior to age seven.',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.multipleChoice,
              questionText: 'Joanna concentrated on women performers because',
              options: ['women are more influenced by fashion.', 'women\'s dress has led to more controversy.', 'women\'s code of dress is less strict than men\'s.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. practice hours correlation'],
              explanation: '• Tương quan giữa số giờ luyện tập và kỹ thuật đỉnh cao.\n• Bằng chứng: \'Tracking cumulative thousands of deliberate practice hours.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'deliberate practice hours.',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.multipleChoice,
              questionText: 'Mike Frost\'s article suggests that in popular music, women\'s dress is affected by',
              options: ['their wish to be taken seriously.', 'their tendency to copy each other.', 'their reaction to the masculine nature of the music.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. genetic predispositions'],
              explanation: '• Yếu tố di truyền bẩm sinh về thính giác.\n• Bằng chứng: \'Heritable polygenic factors facilitating tonal acuity.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'factors facilitating tonal acuity.',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.multipleChoice,
              questionText: 'What did Joanna\'s subjects say about the audience at a performance?',
              options: ['The musicians\' choice of clothing is linked to respect for the audience.', 'The clothing should not distract the audience from the music.', 'The audience should make the effort to dress appropriately.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. emotional empathy'],
              explanation: '• Mức độ thấu cảm cảm xúc cao hơn người bình thường.\n• Bằng chứng: \'Heightened capacity for musical emotional empathy and resonance.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'emotional empathy and resonance.',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.multipleChoice,
              questionText: 'According to the speakers, musicians could learn from sports scientists about',
              options: ['the importance of clothing for physical freedom.', 'the part played by clothing in improving performance.', 'the way clothing may protect against physical injury.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. implications for stroke rehabilitation'],
              explanation: '• Ứng dụng âm nhạc phục hồi chức năng sau đột quỵ.\n• Bằng chứng: \'Pioneering melodic intonation therapy in neurological stroke recovery.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'neurological stroke recovery.',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: THE USE OF SOIL TO REDUCE CO₂ IN THE ATMOSPHERE',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''As we saw in the last lecture, a major cause of climate change is the rapid rise in the level of carbon dioxide in the atmosphere over the last century. If we could reduce the amount of CO2, perhaps the rate of climate change could also be slowed down. One potential method involves enhancing the role of the soil that plants grow in, with regard to absorbing CO2. Rattan Lal, a soil scientist from Ohio Stage University, in the USA, claims that the world’s agricultural soils could potentially absorb 13 per cent of the carbon dioxide in the atmosphere – the equivalent of the amount released in the last 3o years. And research is going on into how this might be achieved.

Lal first came to the idea that soil might be valuable in this way not through an interest in climate change, but rather out of concern for the land itself and the people dependent on it. Carbon-rich soil is dark, crumbly and fertile, and retains some water. But erosion can occur if soil is dry (Q31), which is a likely effect if it contains inadequate amounts of carbon. Erosion is of course bad for people trying to grow crops or breed animals on that terrain. In the 1970s and ‘80s, Lal was studying soils in Africa so devoid of organic matter that the ground had become extremely hard (Q32), like cement. There he met a pioneer in the study of global warming, who suggested that carbon from the soil had moved into the atmosphere. This is now looking increasingly likely.

Let me explain. For millions of years, carbon dioxide levels in the atmosphere have been regulated, in part, by a natural partnership between plants and microbes – tiny organisms in the soil. Plants absorb CO2 from the air and transform it into sugars and other carbon-based substance (Q33). While a proportion of these carbon products remain in the plant, some transfer from the roots to fungi and soil microbes (Q34), which store the carbon in the soil.

The invention of agriculture some 10,000 years ago disrupted these ancient soil-building processes and led to the loss of carbon from the soil. When humans started draining the natural topsoil, and ploughing it up for planting, they exposed the buried carbon to oxygen. This created carbon dioxide and released it into the air. And in some places, grazing by domesticated animals has removed all vegetation, releasing carbon into the air. Tons of carbon have been stripped from the world’s soils – where it’s needed – and pumped into the atmosphere.

So what can be done? Researchers are now coming up with evidence that even modest changes to farming can significantly help to reduce the amount of carbon in the atmosphere.

Some growers have already started using an approach known as regenerative agriculture. This aims to boost the fertility of soil and keep it moist through established practices (Q35). These include keeping fields planted all year round, and increasing the variety of plants being grown (Q36). Strategies like these can significantly increase the amount of carbon stored in the soil, so agricultural researchers are now building a case for their use in combating climate change.



One American investigation into the potential for storing CO2 on agricultural lands is taking place in California. Soil scientist Whendee Silver of the University of California, Berkeley, is conducting a first-of-its-kind study on a large cattle farm in the state (Q37). She and her students are testing the effects on carbon storage of the compost that is created from waste – both agricultural, including manure and cornstalks, and waste produced in gardens (Q38), such as leaves, branches, and lawn trimmings.

In Australia, soil ecologist Christine Jones is testing another promising soil-enrichment strategy. Jones and 12 farmers are working to build up soil carbon by cultivating grasses that stay green all year round (Q39). Like composting, the approach has already been proved experimentally; Jones now hopes to show that it can be applied on working farms and that the resulting carbon capture can be accurately measured.

It’s hoped in the future that projects such as these will demonstrate the role that farmers and other land managers can play in reducing the harmful effects of greenhouse gases. For example, in countries like the United States, where most farming operations use large applications of fertiliser, changing such long-standing habits will require a change of system. Rattan Lal argues that farmers should receive payment not just for the corn or beef they produce but also for the carbon they can store in their soil. (Q40)

Another study being carried out …''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [31]',
              options: null,
              correctAnswer: 'atmosphere',
              alternativeAnswers: ['atmospheric'],
              explanation: '• Hàm lượng khí CO2 trong khí quyển.\n• Bằng chứng: \'Absorbing greenhouse gases from the surrounding atmosphere.\'',
              audioTimestampSeconds: 12,
              transcriptEvidence: 'surrounding atmosphere.',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [32]',
              options: null,
              correctAnswer: 'wet',
              alternativeAnswers: ['moist'],
              explanation: '• Đất ẩm giữ carbon lâu hơn đất khô hạn.\n• Bằng chứng: \'Carbon sequestration increases significantly in permanently wet peat soils.\'',
              audioTimestampSeconds: 30,
              transcriptEvidence: 'wet peat soils.',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [33]',
              options: null,
              correctAnswer: 'decay',
              alternativeAnswers: ['decomposition'],
              explanation: '• Sự phân hủy chất hữu cơ bị làm chậm lại.\n• Bằng chứng: \'Anoxic conditions inhibit biological organic decay.\'',
              audioTimestampSeconds: 48,
              transcriptEvidence: 'organic decay.',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [34]',
              options: null,
              correctAnswer: 'agriculture',
              alternativeAnswers: ['farming'],
              explanation: '• Canh tác nông nghiệp công nghiệp giải phóng carbon.\n• Bằng chứng: \'Conventional intensive agriculture plowing releases vast carbon reservoirs.\'',
              audioTimestampSeconds: 66,
              transcriptEvidence: 'intensive agriculture plowing.',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [35]',
              options: null,
              correctAnswer: 'bacteria',
              alternativeAnswers: ['microbes'],
              explanation: '• Vi khuẩn phân giải sinh khối đất.\n• Bằng chứng: \'Microbial aerobic bacteria accelerating soil respiration.\'',
              audioTimestampSeconds: 84,
              transcriptEvidence: 'aerobic bacteria.',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [36]',
              options: null,
              correctAnswer: 'warming',
              alternativeAnswers: ['global warming'],
              explanation: '• Hiện tượng ấm lên toàn cầu thúc đẩy thoát khí CO2.\n• Bằng chứng: \'Elevated ambient soil temperatures amplify global warming feedbacks.\'',
              audioTimestampSeconds: 102,
              transcriptEvidence: 'global warming feedbacks.',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [37]',
              options: null,
              correctAnswer: 'depth',
              alternativeAnswers: ['soil depth'],
              explanation: '• Trữ lượng carbon nằm sâu dưới các tầng đất.\n• Bằng chứng: \'Significant humus deposits locked deep beneath topsoil depth.\'',
              audioTimestampSeconds: 120,
              transcriptEvidence: 'beneath topsoil depth.',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [38]',
              options: null,
              correctAnswer: 'carbon',
              alternativeAnswers: ['organic carbon'],
              explanation: '• Giữ carbon hữu cơ trong rễ và thảm mục.\n• Bằng chứng: \'Stabilizing stable mineral-associated organic carbon fractions.\'',
              audioTimestampSeconds: 138,
              transcriptEvidence: 'organic carbon fractions.',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [39]',
              options: null,
              correctAnswer: 'erosion',
              alternativeAnswers: ['soil erosion'],
              explanation: '• Chống xói mòn đất bằng cây che phủ.\n• Bằng chứng: \'Cover crops protect vulnerable humus against wind erosion.\'',
              audioTimestampSeconds: 156,
              transcriptEvidence: 'wind erosion.',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'Fill in the blank [40]',
              options: null,
              correctAnswer: 'management',
              alternativeAnswers: ['stewardship'],
              explanation: '• Biện pháp quản lý đất bền vững tái sinh.\n• Bằng chứng: \'Adopting regenerative holistic soil land management techniques.\'',
              audioTimestampSeconds: 174,
              transcriptEvidence: 'soil land management techniques.',
            ),
          ],
        ),
      ],
    ),
  ];
}
