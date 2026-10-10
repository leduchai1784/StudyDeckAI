// Dữ liệu chuẩn đề thi IELTS Cambridge 12 (Test 1, 2, 3, 4)
// Nguồn tham khảo: https://theieltsdictionary.com/practice/listening
import '../models/listening_test_model.dart';

class Cambridge12MockData {
  static const List<ListeningTest> tests = [
    ListeningTest(
      id: 'cam12_test1',
      title: 'Cambridge 12 — Test 1',
      subtitle: 'Part 1 (FAMILY EXCURSIONS) & Part 2 (TALK TO NEW KITCHEN ASSISTANTS)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: FAMILY EXCURSIONS',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''TC EMPLOYEE: Hi. Can I help you?

VISITOR: I’d like to find out if you have any excursions suitable for families.

TC EMPLOYEE: Sure. How about taking your family for a cruise? We have a steamship that takes passengers out several times a day (Example) – it’s over 100 years old.

VISITOR: That sounds interesting. How long is the trip?

TC EMPLOYEE: About an hour and a half. And don’t forget to take pictures of the mountains (Q1). They’re all around you when you’re on the boat and they look fantastic.

VISITOR: OK. And I assume there’s a café or something on board?

TC EMPLOYEE: Sure. How old are your children?

VISITOR: Er, my daughter’s fifteen and my son’s seven.

TC EMPLOYEE: Right. Well there are various things you can do once you’ve crossed the lake, to make a day of it. One thing that’s very popular is a visit to the Country Farm. You’re met off the boat by the farmer and he’ll take you to the holding pens, where the sheep are kept. Children love feeling them!

VISITOR: My son would love that. He really likes animals.

TC EMPLOYEE: Well, there’s also a 40-minute trek round the farm on a horse (Q2), if he wants.

VISITOR: Do you think he’d manage it? He hasn’t done that before.

TC EMPLOYEE: Sure. It’s suitable for complete beginners.

VISITOR: Ah, good.

TC EMPLOYEE: And again, visitors are welcome to explore the farm on their own, as long as they take care to close gates and so on. There are some very beautiful gardens along the side of the lake which also belong to the farm (Q3) – they’ll be just at their best now. You could easily spend an hour or two there.

VISITOR: OK. Well that all sounds good. And can we get lunch there? (Q4)

TC EMPLOYEE: You can, and it’s very good, though it’s not included in the basic cost. You pay when you get there.

VISITOR: Right.

————————-

VISITOR: So is there anything else to do over on that side of the lake?

TC EMPLOYEE: Well, what you can do is take a bike over on the ship and then go on a cycling trip. There’s a trail there called the Back Road – you could easily spend three or four hours exploring it, and the scenery’s wonderful. They’ll give you a map when you get your ticket for the cruise – there’s no extra charge. (Q5)

VISITOR: What’s the trail like in terms of difficulty?

TC EMPLOYEE: Quite challenging in places. It wouldn’t be suitable for your seven-year-old. It needs someone who’s got a bit more experience. (Q6)

VISITOR: Hmm. Well, my daughter loves cycling and so do I, so maybe the two of us could go, and my wife and son could stay on the farm. That might work out quite well. But we don’t have bikes here… is there somewhere we could rent them?

TC EMPLOYEE: Yes, there’s a place here in the city. It’s called Ratchesons. (Q7)

VISITOR: I’ll just make a note of that – er, how do you spell it?

TC EMPLOYEE: R-A-T-C-H-E-S-O-N-S. It’s just be the cruise ship terminal.

VISITOR: OK.

TC EMPLOYEE: You’d also need to pick up a repair kit for the bike from there to take along with you, and you’d need to take along a snack and some water – it’d be best to get those in the city.

VISITOR: Fine. That shouldn’t be a problem. And I assume I can rent a helmet from the bike place? (Q8)

TC EMPLOYEE: Sure, you should definitely get that. It’s a great ride, but you want to be well prepared because it’s very remote – you won’t see any shops round there, or anywhere to stay (Q9), so you need to get back in time for the last boat.

VISITOR: Yeah. So what sort of prices are we looking at here?

TC EMPLOYEE: Let’s see, that’d be one adult and one child for the cruise with farm tour, that’s \$117, and an adult and a child for the cruise only so that’s \$214 dollars altogether. Oh, wait a minute, how old did you say your daughter was?

VISITOR: Fifteen.

TC EMPLOYEE: Then I’m afraid it’s \$267 (Q10) because she has to pay the adult fare, which is \$75 instead of the child fare which is \$22 – sorry about that.

VISITOR: That’s OK. Er, so how do …''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'Can take photos of the [1] that surround the lake',
              options: null,
              correctAnswer: '4',
              alternativeAnswers: ['4/four', '4', 'four'],
              explanation: '• Đáp án chuẩn: 4\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: '4',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'Visit can include a 40-minute ride on a [2]',
              options: null,
              correctAnswer: '46 wombat',
              alternativeAnswers: ['46 wombat'],
              explanation: '• Đáp án chuẩn: 46 wombat\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: '46 wombat',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Visitors can walk in the farm\'s [3] by the lake',
              options: null,
              correctAnswer: 'thursday',
              alternativeAnswers: ['thursday'],
              explanation: '• Đáp án chuẩn: thursday\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'thursday',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: '[4] is available at extra cost',
              options: null,
              correctAnswer: '8.30',
              alternativeAnswers: ['8.30'],
              explanation: '• Đáp án chuẩn: 8.30\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: '8.30',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'A [5] is provided',
              options: null,
              correctAnswer: 'red',
              alternativeAnswers: ['red'],
              explanation: '• Đáp án chuẩn: red\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'red',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'Only suitable for cyclists who have some [6]',
              options: null,
              correctAnswer: 'lunch',
              alternativeAnswers: ['lunch'],
              explanation: '• Đáp án chuẩn: lunch\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'lunch',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: '– Bikes can be hired from [7] (near the Cruise Ship Terminal)',
              options: null,
              correctAnswer: 'glasses',
              alternativeAnswers: ['glasses'],
              explanation: '• Đáp án chuẩn: glasses\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'glasses',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: '– a [8] (can be hired)',
              options: null,
              correctAnswer: 'ball',
              alternativeAnswers: ['ball'],
              explanation: '• Đáp án chuẩn: ball\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'ball',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'There are no [9] or accommodation in the area',
              options: null,
              correctAnswer: 'aunt',
              alternativeAnswers: ['aunt'],
              explanation: '• Đáp án chuẩn: aunt\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'aunt',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'Total cost for whole family of cruise and farm visit: \$[10]',
              options: null,
              correctAnswer: 'month',
              alternativeAnswers: ['month'],
              explanation: '• Đáp án chuẩn: month\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'month',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: TALK TO NEW KITCHEN ASSISTANTS',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''Good morning everyone. My name’s Joy Parkins and I’m the restaurant manager. And I understand that none of you’ve had any previous experience as kitchen assistants? Well, you might be feeling a bit nervous now, but most of our kitchen assistants say they enjoy the work. OK, they might get shouted at sometimes, but it’s nothing personal, and they’re pleased that they have so many different things to do, which means they never get bored (Q11). And I’ll tell you straightaway that if you do well, we might think about moving you up and giving you some more responsibility.

Right, well, you’ve all shown up on time, which is an excellent start. Now I’m glad to see none of you have unsuitable footwear, so that’s good – you need to be careful as the floors can get very wet and slippery. Those of you with long hair have got it well out of the way, but some of you’ll need to remove your rings and bracelets – just put them somewhere safe for today, and remember to leave them at home tomorrow, as they can be a safety hazard. (Q12)

Now it’s going to be a busy day for you all today – we don’t have any tables free for this evening, and only a few for lunch (Q13). Fortunately we’ve got our Head Chef back – he was away on holiday all last week which meant the other chefs had extra work. Now, I’ll tell you a bit more about the job in a minute but first, some general regulations. For all of you, whatever your age, there’s some equipment you mustn’t use until you’ve been properly trained, like the waste disposal system for example, for health and safety reasons. Then I think there are two of you here who are under 18 – that’s Emma and Jake, isn’t it? Right, so for you two, the meat slicer is out of bounds (Q14). And of course none of you are allowed to use the electric mixer until you’ve been shown how it works.

Now you may have heard that this can be a stressful job, and I have to say that can be true. You’ll be working an eight-hour day for the first week, though you’ll have the chance to do overtime after that as well if you want to. But however long the hours are, you’ll get a break in the middle. What you will find is that you’re on your feet all day long, lifting and carrying, so if you’re not fit now you soon will be! You’ll find you don’t have much chance to take it easy – when someone tells you to do something you need to do it straightaway (Q15&Q16) – but at least we do have a very efficient air conditioning system compared with some kitchens.

——————-

Now let me tell you about some of the people you need to know. So as I said, I’m Joy Parkins and I decide who does what during the day and how long they work for (Q17). I’ll be trying to get you to work with as many different people in the kitchen as possible, so that you learn while you’re on the job. One person whose name you must remember is David Field. If you injure yourself at all, even if it’s really minor, you must report to him and he’ll make sure the incident is recorded and you get the appropriate treatment (Q18). He’s trained to give basic treatment to staff himself, or he’ll send you off somewhere else if necessary. Then there’s Dexter Wills – he’s the person you need to see if you smash a plate or something like that (Q19). Don’t just leave it and hope no one will notice – it’s really important to get things noted and replaced or there could be problems late. And finally, there’s Mike Smith. He’s the member of staff who takes care of all the stores of perishables, so if you notice we’re getting low in flour or sugar or something, make sure you let him know so he can put in an order. (Q20)

OK, now the next thing …''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'According to the manager, what do most people like about the job of kitchen assistant?',
              options: ['A. the variety of work.', 'B. the friendly atmosphere.', 'C. the opportunities for promotion.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. the opportunities for promotion.', 'C', 'the opportunities for promotion.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'The manager is concerned about some of the new staff\'s',
              options: ['A. jewellery.', 'B. hair styles.', 'C. shoes.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E', 'e'],
              explanation: '• Lựa chọn đúng: E\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'The manager says that the day is likely to be busy for kitchen staff because',
              options: ['A. it is a public holiday.', 'B. the head chef is absent.', 'C. the restaurant is almost fully booked.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. the head chef is absent.', 'B', 'the head chef is absent.'],
              explanation: '• Lựa chọn đúng: B\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'Only kitchen staff who are 18 or older are allowed to use',
              options: ['A. the waste disposal unit.', 'B. the electric mixer.', 'C. the meat slicer.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. the waste disposal unit.', 'A', 'the waste disposal unit.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'According to the manager, which TWO things can make the job of kitchen assistant stressful? (Lựa chọn 1)',
              options: ['A. They have to follow orders immediately.', 'B. The kitchen gets very hot.', 'C. They may not be able to take a break.', 'D. They have to do overtime.', 'E. The work is physically demanding.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. They may not be able to take a break.', 'C', 'They may not be able to take a break.'],
              explanation: '• Lựa chọn đúng: C\\n• Đọc kỹ câu hỏi để nắm bắt các đặc điểm quan trọng.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.multipleChoice,
              questionText: 'According to the manager, which TWO things can make the job of kitchen assistant stressful? (Lựa chọn 2)',
              options: ['A. They have to follow orders immediately.', 'B. The kitchen gets very hot.', 'C. They may not be able to take a break.', 'D. They have to do overtime.', 'E. The work is physically demanding.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. The kitchen gets very hot.', 'B', 'The kitchen gets very hot.'],
              explanation: '• Lựa chọn đúng: B\\n• Đọc kỹ câu hỏi để nắm bắt các đặc điểm quan trọng.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Responsibilities: Joy Parkins',
              options: ['A. training courses', 'B. food stocks', 'C. first aid', 'D. breakages', 'E. staff discounts', 'F. timetables'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. first aid', 'C', 'first aid'],
              explanation: '• Nối chính xác: C cho "Joy Parkins".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Responsibilities: David Field',
              options: ['A. training courses', 'B. food stocks', 'C. first aid', 'D. breakages', 'E. staff discounts', 'F. timetables'],
              correctAnswer: 'D',
              alternativeAnswers: ['D. breakages', 'D', 'breakages'],
              explanation: '• Nối chính xác: D cho "David Field".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Responsibilities: Dexter Wills',
              options: ['A. training courses', 'B. food stocks', 'C. first aid', 'D. breakages', 'E. staff discounts', 'F. timetables'],
              correctAnswer: 'D',
              alternativeAnswers: ['D. breakages', 'D', 'breakages'],
              explanation: '• Nối chính xác: D cho "Dexter Wills".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Responsibilities: Mike Smith',
              options: ['A. training courses', 'B. food stocks', 'C. first aid', 'D. breakages', 'E. staff discounts', 'F. timetables'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. training courses', 'A', 'training courses'],
              explanation: '• Nối chính xác: A cho "Mike Smith".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'A',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: PAPER ON PUBLIC LIBRARIES',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''TRUDIE: OK, Stewart. We need to start planning our paper on public libraries. Have you thought of an angle yet?

STEWART: Well, there’s so much we could look into. How libraries have changed over the centuries, for instance, or how different countries organise them. What do you think, Trudie?

TRUDIE: Maybe we should concentrate on this country, and try relate the changes in libraries to external developments, like the fact that far more people can read than a century ago, and that the local population may speak lots of different languages. (Q21)

STEWART: We could include something about changes in the source of funding, too.

TRUDIE: Yes, but remember we’re only supposed to write a short paper, so it’s probably best if we don’t go into funding in any detail.

STEWART: Right. Well, shall we just brainstorm a few ideas, to get started?

TRUDIE: OK. We obviously need to look at the impact of new technology, particularly the internet. Now that lots of books have been digitalised, people can access them from their own computers at home.

STEWART: And if everyone did that, libraries would be obsolete.

TRUDIE: Yes.

STEWART: But the digitalised books that are available online for free are mostly out of copyright, aren’t they? And copyright in this country lasts for 70 years after the author dies. So you won’t find the latest best-seller or up-to-date information. (Q22)

TRUDIE: That’s an important point. Anyway, I find it hard to concentrate when I’m reading a long text on a green. I’d much rather read a physical book. And it takes longer to read on a screen.

STEWART: Oh, I prefer it. I suppose it’s just a personal preference.

TRUDIE: Mm. I expect that libraries will go on evolving in the next few years. Some have already become centres where community activities take place, like local clubs meeting there. I think that’ll become even more common.

STEWART: I’d like to think so, and that they’ll still be serving their traditional function, but I’m not so sure. There are financial implications, after all. What I’m afraid will happen is that books and magazines will all disappear, and there’ll just be rows and rows of computers (Q23). They won’t look anything like the libraries we’re used to.

TRUDIE: Well, we’ll see.

———————–
TRUDIE: I’ve just had an idea. Why don’t we make an in-depth study of our local public library as background to our paper?

STEWART: Yes, that’d be interesting, and raise all sorts of issues. Let’s make a list of possible things we could ask about, then work out some sort of structure. For instance, um, we could interview some of the staff, and find out whether the library has its own budget, or if that’s controlled by the local council. (Q24)

TRUDIE: And what their policies are. I know they don’t allow food, but I’d love to find out what types of noise they ban – there always seems to be a lot of talking, but never music. I don’t know if that’s a policy or it just happens.

STEWART: Ah, I’ve often wondered. Then there are things like how the library is affected by employment laws. I suppose there are rules about working hours, facilities for staff, and so on. (Q25)

TRUDIE: Right. Then there are other issues relating to the design of the building and how customers use it. Like what measures does the library take to ensure their safety? (Q26) They’d need floor coverings that aren’t slippery, and emergency exits, for instance. Oh, and another thing – there’s the question of the kind of insurance the library needs to have, in case anyone gets injured. (Q27)

STEWART: Yes, that’s something else to find out. You know something I’ve often wondered?

TRUDIE: What’s that?

STEWART: Well, you know they’ve got an archive of local newspapers going back years? Well, next to it they’ve got the diary of a well-known politician from the late 19th century (Q28). I wonder why it’s there. Do you know what his connection was with this area?

TRUDIE: No idea. Let’s add it to our list of things to find out. Oh, I’ve just thought – you know people might ask in the library about local organisations, like sports clubs? Well, I wonder if they keep a database, or whether they just look online. (Q29)

STEWART: Right. I quite fancy finding out what the differences are between a library that’s open to the public and one that’s part of a museum, for example (Q30) – they must be very different.

TRUDIE: Mmm. Then something else I’d like to know is …''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'What will be the main topic of Trudie and Stewart\'s paper?',
              options: ['A. how public library services are organised in different countries.', 'B. how changes in society are reflected in public libraries.', 'C. how the funding of public libraries has changed.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. how the funding of public libraries has changed.', 'C', 'how the funding of public libraries has changed.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'They agree that one disadvantage of free digitalised books is that',
              options: ['A. they may take a long time to read.', 'B. they can be difficult to read.', 'C. they are generally old.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. they may take a long time to read.', 'A', 'they may take a long time to read.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'Stewart expects that in the future libraries will',
              options: ['A. maintain their traditional function.', 'B. become centres for local communities.', 'C. no longer contain any books.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. maintain their traditional function.', 'A', 'maintain their traditional function.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.gapFill,
              questionText: 'whether it has a [24] of its own',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B', 'b'],
              explanation: '• Đáp án chuẩn: B\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.gapFill,
              questionText: 'how it\'s affected by laws regarding all aspects of [25]',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B', 'b'],
              explanation: '• Đáp án chuẩn: B\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.gapFill,
              questionText: 'how the design needs to take the [26] of customers into account',
              options: null,
              correctAnswer: 'E',
              alternativeAnswers: ['E', 'e'],
              explanation: '• Đáp án chuẩn: E\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.gapFill,
              questionText: 'what [27] is required in case of accidents',
              options: null,
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Đáp án chuẩn: D\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.gapFill,
              questionText: 'why a famous person\'s [28] is located in the library',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.gapFill,
              questionText: 'whether it has a [29] of local organisations',
              options: null,
              correctAnswer: 'G',
              alternativeAnswers: ['G', 'g'],
              explanation: '• Đáp án chuẩn: G\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'G',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.gapFill,
              questionText: 'how it\'s different from a library in a [30]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C', 'c'],
              explanation: '• Đáp án chuẩn: C\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'C',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: FOUR BUSINESS VALUES',
          sectionInstruction: 'Complete the notes below. Write NO MORE THAN TWO WORDS for each answer.',
          fullTranscript: '''In public discussion of business, we take certain values for granted. Today I’m going to talk about four of them: collaboration, hard work, creativity and excellence. Most people would say they’re all ‘good things’. I’m going to suggest that’s an over-simple view.

The trouble with these values is that they’re theoretical concepts, removed from the reality of day-to-day business. Pursue values by all means, but be prepared for what may happen as a result. They can actually cause damage, which is not at all the intention. (Q31)

Business leaders generally try to do the right thing. But all too often the right thing backfires, if those leaders adopt values without understanding and managing the side effects that arise (Q32). The values can easily get in the way of what’s actually intended.

OK. So the first value I’m going to discuss is collaboration. Er, let me give you an example. On a management training course I once attended, we were put into groups and had to construct a bridge across a stream (Q33), using building blocks that we were given. The rule was that everyone in the team had to move at least one building block during the construction. This was intended to encourage teamwork.

But it was really a job best done by one person. The other teams tried to collaborate on building the structure, and descended into confusion (Q34), with everyone getting in each other’s way. Our team leader solved the challenge brilliantly. She simply asked everyone in the team to move a piece a few centimetres, to comply with the rule, and then let the person in the team with an aptitude for puzzles like this build it alone. We finished before any other team. My point is that the task wasn’t really suited to teamworking, so why make it one?

Teamwork can also lead to inconsistency – a common cause of poor sales. In the case of a smartphone that a certain company launched, one director wanted to target the business market, and another demanded it was aimed at consumers. The company wanted both directors to be involved, so gave the product a consumer-friendly name, but marketed it to companies. The result was that it met the needs of neither group. It would have been better to let one director or the other have his way, not both. (Q35)

Now industriousness, or hard work. It’s easy to mock people who say they work hard: after all, a hamster running around in a wheel is working hard – and getting nowhere. Of course hard work is valuable, but only when properly targeted. Otherwise it wastes the resources that companies value most – time and energy. And that’s bad for the organisation. (Q36)

There’s a management model that groups people according to four criteria: clever, hard-working, stupid and lazy. Here ‘lazy’ means having a rational determination not to carry out unnecessary tasks (Q37). It doesn’t mean trying to avoid work altogether. Most people display two of these characteristics, and the most valuable people are those who are both clever and lazy: they possess intellectual clarity, and they don’t rush into making decisions. They come up with solutions to save the time and energy spent by the stupid and hard-working group. Instead of throwing more man-hours at a problem, the clever and lazy group looks for a more effective solution.

Next we come to creativity. This often works well – creating an attention-grabbing TV commercial, for example, might lead to increased sales. But it isn’t always a good thing. Some advertising campaigns are remembered for their creativity, without having any effect on sales. This happened a few years ago with the launch of a chocolate bar: subsequent research showed that plenty of consumers remembered the adverts, but had no idea what was being advertised (Q38). The trouble is that the creator derives pleasure from coming up with the idea, and wrongly assumes the audience for the campaign will share that feeling.

A company that brings out thousands of new products may seem more creative than a company that only has a few, but it may be too creative, and make smaller profits. Creativity needs to be targeted, to solve a problem that the company has identified (Q39). Just coming up with more and more novel products isn’t necessarily a good thing.

And finally, excellence. We all know companies that claim they ‘strive for excellence’, but it takes a long time to achieve excellence. In business, being first with a product is more profitable than having the best product. A major study of company performance compared pioneers – that is, companies bringing out the first version of a particular product – with followers, the companies that copied and improved on that product. The study found that the pioneers commanded an average market share of 29 percent, while the followers achieved less than half that, only 13 percent (Q40) – even though their product might have been better.

Insisting on excellence in everything we do is time-consuming, wastes energy and leads to losing out on opportunities. Sometimes, second-rate work is more worthwhile than excellence. ‘Make sure it’s excellent’ sounds like a good approach to business, but the ‘just-get-started’ approach is likely to be more successful.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'Many business values can result in [31] .',
              options: null,
              correctAnswer: 'achievement',
              alternativeAnswers: ['achievement/achievements', 'achievement', 'achievements'],
              explanation: '• Đáp án chuẩn: achievement\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'achievement',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'Senior managers need to understand and deal with the potential [32] that may result.',
              options: null,
              correctAnswer: 'personality',
              alternativeAnswers: ['personality/character', 'personality', 'character'],
              explanation: '• Đáp án chuẩn: personality\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'personality',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'During a training course, the speaker was in a team that had to build a [33]',
              options: null,
              correctAnswer: 'situational',
              alternativeAnswers: ['situational'],
              explanation: '• Đáp án chuẩn: situational\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'situational',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'Other teams experienced [34] from trying to collaborate.',
              options: null,
              correctAnswer: 'friend',
              alternativeAnswers: ['friend'],
              explanation: '• Đáp án chuẩn: friend\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'friend',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'Sales of a [35] were poor because of collaboration.',
              options: null,
              correctAnswer: 'aspirations',
              alternativeAnswers: ['aspirations/ambitions', 'aspirations', 'ambitions'],
              explanation: '• Đáp án chuẩn: aspirations\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'aspirations',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Hard work may be a bad use of various company [36]',
              options: null,
              correctAnswer: 'style',
              alternativeAnswers: ['style'],
              explanation: '• Đáp án chuẩn: style\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'style',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'The word \'lazy\' in this context refers to people who avoid doing tasks that are [37]',
              options: null,
              correctAnswer: 'development',
              alternativeAnswers: ['development'],
              explanation: '• Đáp án chuẩn: development\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'development',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'An advertising campaign for a [38] was memorable but failed to boost sales.',
              options: null,
              correctAnswer: 'vision',
              alternativeAnswers: ['vision'],
              explanation: '• Đáp án chuẩn: vision\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'vision',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Creativity should be used as a response to a particular [39]',
              options: null,
              correctAnswer: 'structures',
              alternativeAnswers: ['structures'],
              explanation: '• Đáp án chuẩn: structures\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'structures',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'According to one study, on average, pioneers had a [40] that was far higher than that of followers.',
              options: null,
              correctAnswer: 'innovation',
              alternativeAnswers: ['innovation/innovations', 'innovation', 'innovations'],
              explanation: '• Đáp án chuẩn: innovation\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'innovation',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam12_test2',
      title: 'Cambridge 12 — Test 2',
      subtitle: 'Part 1 (EVENTS DURING KENTON FESTIVAL) & Part 2 (THEATRE TRIP TO MUNICH)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: EVENTS DURING KENTON FESTIVAL',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''MAN: Good morning, Kenton Festival box office. How can I help you?

WOMAN: Oh, good morning. I’m coming to Kenton for a few days’ holiday next month, and a friend told me there’s a festival. She gave me this number to find out about it.

MAN: That’s right, the festival begins on the 16th of May (Example) and goes on till the 19th.

WOMAN: Oh, that’s great. I’ll be there from the 15th till the 19th. So could you tell me the programme, please?

MAN: Well, on the first day, there’s the opening ceremony, in the town centre. People start gathering around 2 o’clock, to get a good place to see from, and the events will start at 2.45 (Q1), and finish about 5.30.

WOMAN: OK, thanks. I’ll make sure I get there early to get a good spot.

MAN: The festival will be officially opened by the mayor. He’ll just speak for a few minutes, welcoming everyone to the festival. All the town councillors will be there, and of course lots of other people.

WOMAN: Right.

MAN: Then there’ll be a performance by a band (Q2). Most years we have a children’s choir, but this year the local army cadets offered to perform, and they’re very good.

WOMAN: Uhuh.
MAN: After that, a community group from the town will perform a play they’ve written themselves, just a short one. It’s about Helen Tungate (Q3). I don’t know if you’ve heard of her?

WOMAN: I certainly have. She was a scientist years ago. (Q4)

MAN: That’s right. She was born in Kenton exactly 100 years ago, so we’re celebrating her centenary.

WOMAN: I’m a biologist, so I’ve always been interested in her, I didn’t realise she came from Kenton.

MAN: Yes. Well, all that will take place in the afternoon, and later, as the sun sets, there’ll be a firework display. You should go to the park to watch, as you’ll get the best view from there, and the display takes place on the opposite side of the river (Q5). It’s always one of the most popular events in the festival.

WOMAN: Sounds great.

————————

WOMAN: And what’s happening on the other days?

MAN: There are several events that go on the whole time. For example, the students of the art college have produced a number of videos, all connected with relationships between children and their grandparents. (Q6)

WOMAN: That sounds interesting. It makes a change from children and parents, doesn’t it!

MAN: Exactly. Because the art college is in use for classes, throughout the festival, the videos are being shown in Handsworth House. (Q7)

WOMAN: How do you spell the name?

MAN: H-A-N-D-S-W-O-R-T-H. Handsworth House. It’s close to the Town Hall.

WOMAN: Right.

MAN: Now let me see, what else can I tell you about?

WOMAN: Are there any displays of ballet dancing? I’m particularly interested in that as I do it as a hobby.

MAN: There isn’t any ballet, I’m afraid, but there’ll be a demonstration of traditional dances from all round the country. (Q8)

WOMAN: Oh, that’d be nice. Where’s that being held?
MAN: It’s in the market in the town centre – the outdoor one, not the covered market (Q9). And it’s on at 2 and 5 every afternoon of the festival, apart from the first day.

WOMAN: Lovely. I’m interested in all kinds of dancing, so I’m sure I’ll enjoy that!

MAN: Mmm. I’m sure you will.

WOMAN: And I’d really like to go to some concerts, if there are any.

MAN: Yes, there are several. Three performed by professionals, and one by local children.

WOMAN: And where is it being held?

MAN: It’s in the library, which is in Part Street. On the 18th, at 6.30 in the evening.

WOMAN: I presume I’ll need tickets for that.

MAN: Yes, you can book online, or you can buy them when you arrive in Kenton, either at the festival box office, or from any shops displaying our logo in the windows. (Q10)

WOMAN: Well, I think that’ll keep me busy for the whole of my stay in Kenton. Thank you so much for all your help.

MAN: You’re welcome. I hope you enjoy your stay. WOMAN: Thank you. Goodbye.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'In town centre, starting at [1]',
              options: null,
              correctAnswer: '4',
              alternativeAnswers: ['4/four', '4', 'four'],
              explanation: '• Đáp án chuẩn: 4\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: '4',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'A [2] will perform',
              options: null,
              correctAnswer: '46 wombat',
              alternativeAnswers: ['46 wombat'],
              explanation: '• Đáp án chuẩn: 46 wombat\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: '46 wombat',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'Performance of a [3] about Helen Tungate (a {4})',
              options: null,
              correctAnswer: 'thursday',
              alternativeAnswers: ['thursday'],
              explanation: '• Đáp án chuẩn: thursday\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'thursday',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'Performance of a {3} about Helen Tungate (a [4])',
              options: null,
              correctAnswer: '8.30',
              alternativeAnswers: ['8.30'],
              explanation: '• Đáp án chuẩn: 8.30\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: '8.30',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'Evening fireworks display situated across the [5]',
              options: null,
              correctAnswer: 'red',
              alternativeAnswers: ['red'],
              explanation: '• Đáp án chuẩn: red\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'red',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'Video about relationships that children have with their [6]',
              options: null,
              correctAnswer: 'lunch',
              alternativeAnswers: ['lunch'],
              explanation: '• Đáp án chuẩn: lunch\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'lunch',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'Venue: [7] House',
              options: null,
              correctAnswer: 'glasses',
              alternativeAnswers: ['glasses'],
              explanation: '• Đáp án chuẩn: glasses\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'glasses',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'Performance of [8] Dances',
              options: null,
              correctAnswer: 'ball',
              alternativeAnswers: ['ball'],
              explanation: '• Đáp án chuẩn: ball\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'ball',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'Venue: the [9] market in the town centre',
              options: null,
              correctAnswer: 'aunt',
              alternativeAnswers: ['aunt'],
              explanation: '• Đáp án chuẩn: aunt\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'aunt',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'Tickets available online from festival box office and from shops which have the festival [10] in their windows',
              options: null,
              correctAnswer: 'month',
              alternativeAnswers: ['month'],
              explanation: '• Đáp án chuẩn: month\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'month',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: THEATRE TRIP TO MUNICH',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''Right. I’ve now almost succeeded in finalising plans for our tour, so I’ll bring you up to date with what I know.

As you know, we’re flying first to Munich, on Monday the 4th.

The flight is at 11.30, so it’s too early to have lunch at the airport. I suggest we meet there for coffee at 10 (Q11), which should give us plenty of time for breakfast before we leave home.

When we arrive in Munich, we’ll be met at the airport by Claus Bauer. Claus works for a tour operator (Q12), and he’ll look after us for the time we’ll be in Germany. He’s already liaised with the managers of the theatres we’re going to visit, and he’s also arranged for an officer of the National Theatre in Munich to show us round the theatre one afternoon during our stay.

Now last time we discussed this trip, I didn’t have the precise cost for hotel rooms, but now I have. The normal rate at the hotel where we’re staying is 150 euros a night for a double room. I’d hoped to get that down to 120 euros, but in fact I’ve been able to negotiate a rate of 110 (Q13). That’ll be reflected in the final payment which you’ll need to make by the end of this week.

On Tuesday, the day after our arrival, I had hoped we could sit in on a rehearsal at one of the theatres, but unfortunately that’s proved very difficult to arrange, so instead we’ll have a coach trip to one of the amazing castles in the mountains south of Munich.

On Tuesday evening, we’ll all have dinner together in a restaurant near our hotel. From talking to you all about your preferences, it was clear that a typical local restaurant would be too meat-oriented for some of you. Some of you suggested an Italian restaurant, but I must confess that I decided to book a Lebanese one (Q14), as we have plenty of opportunities to go to an Italian restaurant at home.

On Wednesday afternoon, the director of the play we’re going to see that evening will talk to us at the theatre (Q15). She’ll describe the whole process of producing a play, including how she chose the actors, and, as the play we’re going to see is a modern one, how she worked with the playwright.

——————

Right. Now I’d just like to make a few points about the plays we’re going to see, partly because it might influence your choice of clothes to take with you!

The play we’re seeing on Wednesday evening is a modern one, and we’re going to the premiere (Q16), so it’ll be quite a dressy occasion, though of course you don’t have to dress formally. I gather it’s rather a multimedia production, with amazing lighting effects and a soundtrack of electronic music, though unfortunately the playwright is ill and is unlikely to be able to attend.

On Thursday we’re seeing a play that was first performed last year, when it was commissioned to mark a hundred years since the birth in the town of a well-known scientist (Q17). We’re going to see a revival of that production, which aroused a lot of interest.

Friday’s play will really make you think hard about what clothes to pack, as it’ll be in the garden of a palace (Q18). It’s a beautiful setting, but I’d better warn you, there won’t be much protection from the wind.

On Saturday, we’re going by coach to a theatre in another town, not far from Munich. This will be the opening of a drama festival, and the mayor and all the other dignitaries of the town will be attending (Q19). After the performance, the mayor is hosting a reception for all the audience, and there’ll be a band playing traditional music of the region.

And after having a day off on Sunday, our final play is on Monday, and it’s in the stunning setting of the old Town Hall, which dates back to the 14th century (Q20). The performance marks the fifty years that the lead actor has been on stage, and the play is the one where he made his first professional appearance, all those years ago.

And the day after that, we’ll be flying back home. Now have you got any questions before I …

Choose the correct letter, A, B or C.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'When the group meet at the airport they will have',
              options: ['A. breakfast.', 'B. coffee.', 'C. lunch.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. lunch.', 'C', 'lunch.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'The group will be met at Munich Airport by',
              options: ['A. an employee at the National Theatre.', 'B. a theatre manager.', 'C. a tour operator.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E', 'e'],
              explanation: '• Lựa chọn đúng: E\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'How much will they pay per night for a double room at the hotel?',
              options: ['A. 110 euros.', 'B. 120 euros.', 'C. 150 euros.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. 120 euros.', 'B', '120 euros.'],
              explanation: '• Lựa chọn đúng: B\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'What type of restaurant will they go to on Tuesday evening?',
              options: ['A. an Italian restaurant.', 'B. a Lebanese restaurant.', 'C. a typical restaurant of the region.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. an Italian restaurant.', 'A', 'an Italian restaurant.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'Who will they meet on Wednesday afternoon?',
              options: ['A. an actor.', 'B. a playwright.', 'C. a theatre director.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. a theatre director.', 'C', 'a theatre director.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.matching,
              questionText: 'Comments: Wednesday',
              options: ['A. The playwright will be present.', 'B. The play was written to celebrate an anniversary.', 'C. The play will be performed inside a historic building.', 'D. The play will be accompanied by live music.', 'E. The play will be performed outdoors.', 'F. The play will be performed for the first time.', 'G. The performance will be attended by officials from the town.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. The play was written to celebrate an anniversary.', 'B', 'The play was written to celebrate an anniversary.'],
              explanation: '• Nối chính xác: B cho "Wednesday".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Comments: Thursday',
              options: ['A. The playwright will be present.', 'B. The play was written to celebrate an anniversary.', 'C. The play will be performed inside a historic building.', 'D. The play will be accompanied by live music.', 'E. The play will be performed outdoors.', 'F. The play will be performed for the first time.', 'G. The performance will be attended by officials from the town.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. The play will be performed inside a historic building.', 'C', 'The play will be performed inside a historic building.'],
              explanation: '• Nối chính xác: C cho "Thursday".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Comments: Friday',
              options: ['A. The playwright will be present.', 'B. The play was written to celebrate an anniversary.', 'C. The play will be performed inside a historic building.', 'D. The play will be accompanied by live music.', 'E. The play will be performed outdoors.', 'F. The play will be performed for the first time.', 'G. The performance will be attended by officials from the town.'],
              correctAnswer: 'D',
              alternativeAnswers: ['D. The play will be accompanied by live music.', 'D', 'The play will be accompanied by live music.'],
              explanation: '• Nối chính xác: D cho "Friday".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Comments: Saturday',
              options: ['A. The playwright will be present.', 'B. The play was written to celebrate an anniversary.', 'C. The play will be performed inside a historic building.', 'D. The play will be accompanied by live music.', 'E. The play will be performed outdoors.', 'F. The play will be performed for the first time.', 'G. The performance will be attended by officials from the town.'],
              correctAnswer: 'D',
              alternativeAnswers: ['D. The play will be accompanied by live music.', 'D', 'The play will be accompanied by live music.'],
              explanation: '• Nối chính xác: D cho "Saturday".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Comments: Monday',
              options: ['A. The playwright will be present.', 'B. The play was written to celebrate an anniversary.', 'C. The play will be performed inside a historic building.', 'D. The play will be accompanied by live music.', 'E. The play will be performed outdoors.', 'F. The play will be performed for the first time.', 'G. The performance will be attended by officials from the town.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. The playwright will be present.', 'A', 'The playwright will be present.'],
              explanation: '• Nối chính xác: A cho "Monday".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'A',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: SCANDINAVIAN STUDIES',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''BETH: Oh good morning. You must be James. I’m Beth Cartwright – please call be Beth.

JAMES: Thank you.

BETH: Now as this is your first tutorial since you started on the Scandinavian Studies course, I’d like to find out something about you. Why did you decide to take this course?

JAMES: Well, my mother is Danish, and although we always lived in England, she used to talk about her home a lot, and that made me want to visit Denmark. We hardly ever did, though – my mother usually went on her own. But whenever her relations or friends were in England they always came to see us. (Q21)

BETH: I see. So I assume you already speak Danish, one of the languages you’ll be studying.

JAMES: I can get by when I talk to people, though I’m not terribly accurate.

BETH: Now you probably know that you’ll spend the third year of the course abroad. Have you had any thoughts about that?

JAMES: I’m really looking forward to it. And although Denmark seems the obvious place to go, because of my family connections, I’d love to spend the time in Iceland.

BETH: Oh, I’m sure it can be arranged. Do you have any plans for when you graduate? A lot of students go on to take a master’s degree.

JAMES: I think the four years of the undergraduate course will be enough for me. I’m interested in journalism, and I quite like the idea of moving to Scandinavia and writing for magazines (Q22). I’d find that more creative than translating, which I suppose most graduates do.

BETH: OK. Now how are you finding the courses you’re taking this term, James?

JAMES: Well, I’m really enjoying the one on Swedish cinema.

BETH: That’ll continue next term, but the one on Scandinavian literature that’s running at the moment will be replaced by more specialised courses (Q23). Oh, and by the way, if you’re interested in watching Danish television programmes – there’s going to be a course on that the term after next.

JAMES: That sounds good.

BETH: Have you started thinking about the literature paper that you have to write in the next few weeks?

JAMES: Yes, my first choice would be to do something on the Icelandic sagas.

BETH: Hmm. The trouble with that is that a lot of people choose that topic, and it can be difficult to get hold of the books you’ll need. Why not leave that for another time?

JAMES: Right.

BETH: You might find modern novels or 19th century playwrights interesting. (Q24)

JAMES: I’ve read or seen several plays in translation, so that would be a good idea.

BETH: Fine. I’ll put you down for that topic.

JAMES: Right. So what would you advise me to aim at in the paper?

BETH: First I suggest you avoid taking one writer and going into a great deal of detail. That approach certainly has its place, but I think you first need to get an understanding of the literature in the context of the society in which it was produced – who it was written for, how it was published, and so on (Q25). I also think that’s more fruitful than placing it within the history of the genre.

JAMES: OK, that sounds reasonable.

————————

JAMES: Could I ask for some advice about writing the paper I’m working on about the Vikings? I have to do that this week, and I’m a bit stuck.

BETH: Of course. Have you decided yet what to write about?

JAMES: No, I haven’t. There’s so much that seems interesting – Viking settlement in other countries, trade, mythology …

BETH: Well, what I suggest is that you read an assignment a student wrote last year (Q26), which is kept in the library. It’s short and well focused, and I’m sure you’ll find it helpful. I’ll give you the details in a moment. Textbooks usually cover so many topics, it can be very difficult to choose just one.

JAMES: OK. I’ve got a DVD of the film about the Vikings that came out earlier this year. Should I watch that again?

BETH: If it’s the one I am thinking of, hmm, I’d ignore it – it’s more fantasy than reality. But I’ve got a recording of a documentary that you should watch (Q27). It makes some interesting and provocative points, which I think will help you to focus your topic.

JAMES: Right.

BETH: So then should I work out an outline? (Q28)

JAMES: Yes. Just headings for different sections, at this stage. And then you should start looking for suitable articles and books to draw on, and take notes (Q29) which you organise according to those headings.

BETH: I see.

JAMES: Then put short phrases and sentences as bullet points under each heading (Q30). Make sure that this skeleton makes sense and flows properly, before writing up the paper in full.

BETH: OK. Thanks, that’s very helpful.''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.multipleChoice,
              questionText: 'James chose to take Scandinavian Studies because when he was a child',
              options: ['A. he was often taken to Denmark.', 'B. his mother spoke to him in Danish.', 'C. a number of Danish people visited his family.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. a number of Danish people visited his family.', 'C', 'a number of Danish people visited his family.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.multipleChoice,
              questionText: 'When he graduates, James would like to',
              options: ['A. take a postgraduate course.', 'B. work in the media.', 'C. become a translator.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. take a postgraduate course.', 'A', 'take a postgraduate course.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.multipleChoice,
              questionText: 'Which course will end this term?',
              options: ['A. Swedish cinema.', 'B. Danish television programmes.', 'C. Scandinavian literature.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. Swedish cinema.', 'A', 'Swedish cinema.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.multipleChoice,
              questionText: 'They agree that James\'s literature paper this term will be on',
              options: ['A. 19th century playwrights.', 'B. the Icelandic sagas.', 'C. modern Scandinavian novels.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. the Icelandic sagas.', 'B', 'the Icelandic sagas.'],
              explanation: '• Lựa chọn đúng: B\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.multipleChoice,
              questionText: 'Beth recommends that James\'s paper should be',
              options: ['A. a historical overview of the genre.', 'B. an in-depth analysis of a single writer.', 'C. a study of the social background to the literature.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. an in-depth analysis of a single writer.', 'B', 'an in-depth analysis of a single writer.'],
              explanation: '• Lựa chọn đúng: B\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.gapFill,
              questionText: 'He\'ll read a [26] and choose his topic.',
              options: null,
              correctAnswer: 'E',
              alternativeAnswers: ['E', 'e'],
              explanation: '• Đáp án chuẩn: E\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.gapFill,
              questionText: 'He\'ll borrow a [27] from Beth.',
              options: null,
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Đáp án chuẩn: D\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.gapFill,
              questionText: 'He\'ll plan the [28] of the paper.',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.gapFill,
              questionText: 'He\'ll read some source material and write [29]',
              options: null,
              correctAnswer: 'G',
              alternativeAnswers: ['G', 'g'],
              explanation: '• Đáp án chuẩn: G\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'G',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.gapFill,
              questionText: 'He\'ll write the paper using [30]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C', 'c'],
              explanation: '• Đáp án chuẩn: C\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'C',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: CONFLICT AT WORK',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Over the years, attitudes towards workers have changed considerably. After all, there was a time when workers had no rights at all, and laboured in appalling conditions. Conditions have improved a lot, but conflict in the workplace is still common. And human resources managers nowadays need to be able to deal with it when necessary.

What is conflict in the workplace? Definitions vary, but I’m taking it to refer to a whole range of behaviours that the victim finds unacceptable, from minor, harmless arguments to – at the opposite extreme – physical violence. Much of this is covered by the term bullying (Q31), by which I mean one or more people behaving abusively or aggressively against another who is in a weaker position. Although all behaviour like this is a form of conflict, not all conflict can be described in these terms.

As with all human behaviour, there are numerous reasons for it. But often it’s caused by someone who feels the need to show their superiority over someone else (Q32), in order to feel that they aren’t at the lowest level in a hierarchy or a group of people.

In some cases one person simply dislikes the other, on the basis that the personality of one is in some way incompatible with that of the other person (Q33). A general habit of optimism in one person could make them intolerant of a colleague who’s constantly pessimistic – not that that justifies treating them badly, of course.

Some conflicts arise when people are more interested in promoting themselves and their team than in the company as a whole. These conflicts are called ‘structural’ (Q34), and could come about, for example, when a sales team believe they are the only people in the business who do any useful work, and look down on behind-the-scenes administrators.

Conflict obviously affects the individuals concerned – the situation is likely to be very stressful for victims, resulting in their absence from work, possibly for months (Q35). For the company, if no effort is made to deal with conflict, it can spiral out of control, and even lead to the breakdown of the business.

Some interesting work with chief executives – CEOs – has uncovered some of the reasons why they may treat colleagues badly. Many CEOs combine two opposing characteristics: confidence – that is, the belief that they’re capable of great achievements – with a high level of anxiety (Q36), a fear of missing targets, whether set by themselves or by the directors of the company. This combination can make them respond badly to anyone who questions their decisions.

In a high pressure work environment, such characteristics become problematic. And it’s particularly difficult to tackle the situation where colleagues, managers and board members are all trying to achieve their own visions. When they can’t agree on strategic issues and on where they see the business going, there are real problems. (Q37)

For managers at lower levels within the organisation, it might seem that an autocratic form of management – where the chief executive gives orders and everyone else has to obey – would see more conflict than others. Interestingly, though, a company with a more democratic business model, can suffer more, when uncertainty about who to report to leads to conflicting demands. (Q38)

Now I’ll say a little about dealing with the type of conflict that has harmful effects. Of course the ideal is to prevent it arising in the first place. A good manager, at any level, will make efforts to earn the respect of the people they work with (Q39), particularly those who report to them. That will involve politeness in all communications, and treating them as equals who happen to have a different role within the organisation.

Sometimes, of course, conflict does occur, and can get out of hand. In such cases the human resources department often gets involved. However, if one of the parties in a conflict sees human resources as simply a mouthpiece for the chief executive, then an external mediator might be able to help (Q40). By talking to both sides, and trying to find the truth of what’s been happening, they can build a clear picture of the situation, and give feedback that both sides will accept, precisely because they’re independent.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'Conflict mostly consists of behaviour in the general category of [31]',
              options: null,
              correctAnswer: 'achievement',
              alternativeAnswers: ['achievement/achievements', 'achievement', 'achievements'],
              explanation: '• Đáp án chuẩn: achievement\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'achievement',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'Often a result of people wanting to prove their [32]',
              options: null,
              correctAnswer: 'personality',
              alternativeAnswers: ['personality/character', 'personality', 'character'],
              explanation: '• Đáp án chuẩn: personality\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'personality',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'Also caused by differences in [33] between people',
              options: null,
              correctAnswer: 'situational',
              alternativeAnswers: ['situational'],
              explanation: '• Đáp án chuẩn: situational\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'situational',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: '\'[34]\' conflicts: people more concerned about own team than about company',
              options: null,
              correctAnswer: 'friend',
              alternativeAnswers: ['friend'],
              explanation: '• Đáp án chuẩn: friend\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'friend',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'Conflict-related stress can cause [35] that may last for months',
              options: null,
              correctAnswer: 'aspirations',
              alternativeAnswers: ['aspirations/ambitions', 'aspirations', 'ambitions'],
              explanation: '• Đáp án chuẩn: aspirations\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'aspirations',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Many have both [36] and anxiety',
              options: null,
              correctAnswer: 'style',
              alternativeAnswers: ['style'],
              explanation: '• Đáp án chuẩn: style\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'style',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'There may be conflict between people who have different [37]',
              options: null,
              correctAnswer: 'development',
              alternativeAnswers: ['development'],
              explanation: '• Đáp án chuẩn: development\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'development',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'A structure that is more [38] may create a feeling of uncertainty about who staff should report to.',
              options: null,
              correctAnswer: 'vision',
              alternativeAnswers: ['vision'],
              explanation: '• Đáp án chuẩn: vision\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'vision',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Bosses need to try hard to gain [39]',
              options: null,
              correctAnswer: 'structures',
              alternativeAnswers: ['structures'],
              explanation: '• Đáp án chuẩn: structures\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'structures',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'Someone from outside the company may be given the role of [40] in order to resolve conflicts.',
              options: null,
              correctAnswer: 'innovation',
              alternativeAnswers: ['innovation/innovations', 'innovation', 'innovations'],
              explanation: '• Đáp án chuẩn: innovation\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'innovation',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam12_test3',
      title: 'Cambridge 12 — Test 3',
      subtitle: 'Part 1 (PUBLIC LIBRARY) & Part 2 (BC TRAVEL ACTIVITY HOLIDAYS)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: PUBLIC LIBRARY',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Section 1 audio recorded for Cambridge 12 — Test 3. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test3-Section1.mp3

Topics covered: Part 1: PUBLIC LIBRARY.
Follow the audio carefully to answer questions 1 to 10.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'an expanded section for books on [1]',
              options: null,
              correctAnswer: '4',
              alternativeAnswers: ['4/four', '4', 'four'],
              explanation: '• Đáp án chuẩn: 4\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: '4',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'a new section on local [2]',
              options: null,
              correctAnswer: '46 wombat',
              alternativeAnswers: ['46 wombat'],
              explanation: '• Đáp án chuẩn: 46 wombat\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: '46 wombat',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'a community room for meetings (also possible to [3] there)',
              options: null,
              correctAnswer: 'thursday',
              alternativeAnswers: ['thursday'],
              explanation: '• Đáp án chuẩn: thursday\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'thursday',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'a new section of books for [4]',
              options: null,
              correctAnswer: '8.30',
              alternativeAnswers: ['8.30'],
              explanation: '• Đáp án chuẩn: 8.30\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: '8.30',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'the next Science Club meeting: experiments using things from your [5]',
              options: null,
              correctAnswer: 'red',
              alternativeAnswers: ['red'],
              explanation: '• Đáp án chuẩn: red\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'red',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'this Friday: a local author talks about a novel based on a real [6]',
              options: null,
              correctAnswer: 'lunch',
              alternativeAnswers: ['lunch'],
              explanation: '• Đáp án chuẩn: lunch\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'lunch',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'IT support is available on Tuesday – no [7] is necessary',
              options: null,
              correctAnswer: 'glasses',
              alternativeAnswers: ['glasses'],
              explanation: '• Đáp án chuẩn: glasses\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'glasses',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'free check of blood [8] and cholesterol levels (over 60s only)',
              options: null,
              correctAnswer: 'ball',
              alternativeAnswers: ['ball'],
              explanation: '• Đáp án chuẩn: ball\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'ball',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'the library shop sells wall-charts, cards and [9]',
              options: null,
              correctAnswer: 'aunt',
              alternativeAnswers: ['aunt'],
              explanation: '• Đáp án chuẩn: aunt\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'aunt',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'evenings and weekends: free [10] is available',
              options: null,
              correctAnswer: 'month',
              alternativeAnswers: ['month'],
              explanation: '• Đáp án chuẩn: month\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'month',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: BC TRAVEL ACTIVITY HOLIDAYS',
          sectionInstruction: 'Choose TWO letters A–E.',
          fullTranscript: '''Section 2 audio recorded for Cambridge 12 — Test 3. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test3-Section2_1.mp3

Topics covered: Part 2: BC TRAVEL ACTIVITY HOLIDAYS.
Follow the audio carefully to answer questions 11 to 20.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO age groups are taking increasing numbers of holidays with BC Travel? (Lựa chọn 1)',
              options: ['A. 16–30 years', 'B. 31–42 years', 'C. 43–54 years', 'D. 55–64 years', 'E. over 65 years'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. 43–54 years', 'C', '43–54 years'],
              explanation: '• Lựa chọn đúng: C\\n• Đọc kỹ câu hỏi để nắm bắt các đặc điểm quan trọng.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO age groups are taking increasing numbers of holidays with BC Travel? (Lựa chọn 2)',
              options: ['A. 16–30 years', 'B. 31–42 years', 'C. 43–54 years', 'D. 55–64 years', 'E. over 65 years'],
              correctAnswer: 'E',
              alternativeAnswers: ['E. over 65 years', 'E', 'over 65 years'],
              explanation: '• Lựa chọn đúng: E\\n• Đọc kỹ câu hỏi để nắm bắt các đặc điểm quan trọng.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO are the main reasons given for the popularity of activity holidays? (Lựa chọn 1)',
              options: ['A. Clients make new friends.', 'B. Clients learn a useful skill.', 'C. Clients learn about a different culture.', 'D. Clients are excited by the risk involved.', 'E. Clients find them good value for money.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. Clients learn a useful skill.', 'B', 'Clients learn a useful skill.'],
              explanation: '• Lựa chọn đúng: B\\n• Đọc kỹ câu hỏi để nắm bắt các đặc điểm quan trọng.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'Which TWO are the main reasons given for the popularity of activity holidays? (Lựa chọn 2)',
              options: ['A. Clients make new friends.', 'B. Clients learn a useful skill.', 'C. Clients learn about a different culture.', 'D. Clients are excited by the risk involved.', 'E. Clients find them good value for money.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. Clients make new friends.', 'A', 'Clients make new friends.'],
              explanation: '• Lựa chọn đúng: A\\n• Đọc kỹ câu hỏi để nắm bắt các đặc điểm quan trọng.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.multipleChoice,
              questionText: 'How does BC Travel plan to expand the painting holidays?',
              options: ['A. by adding to the number of locations.', 'B. by increasing the range of levels.', 'C. by employing more teachers.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. by employing more teachers.', 'C', 'by employing more teachers.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.multipleChoice,
              questionText: 'Why are BC Travel\'s cooking holidays unusual?',
              options: ['A. They only use organic foods.', 'B. They have an international focus.', 'C. They mainly involve vegetarian dishes.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. They have an international focus.', 'B', 'They have an international focus.'],
              explanation: '• Lựa chọn đúng: B\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.multipleChoice,
              questionText: 'What does the speaker say about the photography holidays?',
              options: ['A. Clients receive individual tuition.', 'B. The tutors are also trained guides.', 'C. Advice is given on selling photographs.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. Advice is given on selling photographs.', 'C', 'Advice is given on selling photographs.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.gapFill,
              questionText: '• also reduces [18]',
              options: null,
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Đáp án chuẩn: D\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.gapFill,
              questionText: '[19] control',
              options: null,
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Đáp án chuẩn: D\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.gapFill,
              questionText: '• one holiday that is specially designed for [20]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'A',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: STAGES IN DOING A TOURISM CASE STUDY',
          sectionInstruction: 'Complete the flow-chart below. Choose SIX answers from the box and write the correct letter A–H next to questions 21–26.\nA patterns\nB names\nC sources\nD questions\nE employees\nF solutions\nG headings\nH officials',
          fullTranscript: '''Section 3 audio recorded for Cambridge 12 — Test 3. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test3-Section3_1.mp3

Topics covered: Part 3: STAGES IN DOING A TOURISM CASE STUDY.
Follow the audio carefully to answer questions 21 to 30.''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.gapFill,
              questionText: 'Locate and read relevant articles, noting key information and also [21]',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C', 'c'],
              explanation: '• Đáp án chuẩn: C\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.gapFill,
              questionText: 'Select interviewees – these may be site [22], visitors or city {23}',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.gapFill,
              questionText: 'Select interviewees – these may be site {22}, visitors or city [23]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.gapFill,
              questionText: 'Check whether [24] of interviewees can be used.',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B', 'b'],
              explanation: '• Đáp án chuẩn: B\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.gapFill,
              questionText: 'Select relevant information and try to identify [25]',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B', 'b'],
              explanation: '• Đáp án chuẩn: B\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.gapFill,
              questionText: 'Do NOT end with [26]',
              options: null,
              correctAnswer: 'E',
              alternativeAnswers: ['E', 'e'],
              explanation: '• Đáp án chuẩn: E\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.multipleChoice,
              questionText: 'Natalie and Dave agree one reason why so few people visit Horton Castle is that',
              options: ['A. the publicity is poor.', 'B. it is difficult to get to.', 'C. there is little there of interest.'],
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Lựa chọn đúng: D\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.multipleChoice,
              questionText: 'Natalie and Dave agree that the greatest problem with a visitor centre could be',
              options: ['A. covering the investment costs.', 'B. finding a big enough space for it.', 'C. dealing with planning restrictions.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. covering the investment costs.', 'A', 'covering the investment costs.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.multipleChoice,
              questionText: 'What does Dave say about conditions in the town of Horton?',
              options: ['A. There is a lot of unemployment.', 'B. There are few people of working age.', 'C. There are opportunities for skilled workers.'],
              correctAnswer: 'G',
              alternativeAnswers: ['G', 'g'],
              explanation: '• Lựa chọn đúng: G\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'G',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.multipleChoice,
              questionText: 'According to Natalie, one way to prevent damage to the castle site would be to',
              options: ['A. insist visitors have a guide.', 'B. make visitors keep to the paths.', 'C. limit visitor numbers.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. limit visitor numbers.', 'C', 'limit visitor numbers.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'C',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: EFFECTS OF ENVIRONMENTAL CHANGE ON BIRDS',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Section 4 audio recorded for Cambridge 12 — Test 3. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test3-Section4_1.mp3

Topics covered: Part 4: EFFECTS OF ENVIRONMENTAL CHANGE ON BIRDS.
Follow the audio carefully to answer questions 31 to 40.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'It has also recently been found to affect birds which feed on [31]',
              options: null,
              correctAnswer: 'achievement',
              alternativeAnswers: ['achievement/achievements', 'achievement', 'achievements'],
              explanation: '• Đáp án chuẩn: achievement\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'achievement',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: '– the effects on birds\' [32] or mental processes, e.g. memory',
              options: null,
              correctAnswer: 'personality',
              alternativeAnswers: ['personality/character', 'personality', 'character'],
              explanation: '• Đáp án chuẩn: personality\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'personality',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: '– the effects on bird song (usually learned from a bird\'s [33])',
              options: null,
              correctAnswer: 'situational',
              alternativeAnswers: ['situational'],
              explanation: '• Đáp án chuẩn: situational\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'situational',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: '– songs learned by birds exposed to mercury are less [34]',
              options: null,
              correctAnswer: 'friend',
              alternativeAnswers: ['friend'],
              explanation: '• Đáp án chuẩn: friend\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'friend',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: '– this may have a negative effect on birds\' [35]',
              options: null,
              correctAnswer: 'aspirations',
              alternativeAnswers: ['aspirations/ambitions', 'aspirations', 'ambitions'],
              explanation: '• Đáp án chuẩn: aspirations\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'aspirations',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'allow more [36] for the experimenter',
              options: null,
              correctAnswer: 'style',
              alternativeAnswers: ['style'],
              explanation: '• Đáp án chuẩn: style\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'style',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'Migrating birds such as [37] containing mercury may be eaten by humans',
              options: null,
              correctAnswer: 'development',
              alternativeAnswers: ['development'],
              explanation: '• Đáp án chuẩn: development\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'development',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'Mercury also causes problems in learning [38]',
              options: null,
              correctAnswer: 'vision',
              alternativeAnswers: ['vision'],
              explanation: '• Đáp án chuẩn: vision\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'vision',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'Mercury in a mother\'s body from [39] may affect the unborn child',
              options: null,
              correctAnswer: 'structures',
              alternativeAnswers: ['structures'],
              explanation: '• Đáp án chuẩn: structures\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'structures',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'New regulations for mercury emissions will affect everyone\'s energy [40]',
              options: null,
              correctAnswer: 'innovation',
              alternativeAnswers: ['innovation/innovations', 'innovation', 'innovations'],
              explanation: '• Đáp án chuẩn: innovation\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'innovation',
            ),
          ],
        ),
      ],
    ),
    ListeningTest(
      id: 'cam12_test4',
      title: 'Cambridge 12 — Test 4',
      subtitle: 'Part 1 (CYCLE TOUR LEADER: APPLICANT ENQUIRY) & Part 2 (VISITING THE SHEEPMARKET AREA)',
      bandTarget: 'Band 6.0 - 7.5',
      durationMinutes: 30,
      sections: [
        ListeningSection(
          partNumber: 1,
          sectionTitle: 'Part 1: CYCLE TOUR LEADER: APPLICANT ENQUIRY',
          sectionInstruction: 'Write ONE WORD AND/OR A NUMBER for each answer.',
          fullTranscript: '''Section 1 audio recorded for Cambridge 12 — Test 4. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test4-Section1.mp3

Topics covered: Part 1: CYCLE TOUR LEADER: APPLICANT ENQUIRY.
Follow the audio carefully to answer questions 1 to 10.''',
          questions: [
            ListeningQuestion(
              questionNumber: 1,
              type: QuestionType.gapFill,
              questionText: 'wants a [1] job',
              options: null,
              correctAnswer: '4',
              alternativeAnswers: ['4/four', '4', 'four'],
              explanation: '• Đáp án chuẩn: 4\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: '4',
            ),
            ListeningQuestion(
              questionNumber: 2,
              type: QuestionType.gapFill,
              questionText: 'will soon start work as a [2]',
              options: null,
              correctAnswer: '46 wombat',
              alternativeAnswers: ['46 wombat'],
              explanation: '• Đáp án chuẩn: 46 wombat\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: '46 wombat',
            ),
            ListeningQuestion(
              questionNumber: 3,
              type: QuestionType.gapFill,
              questionText: 'has led cycle trips in [3]',
              options: null,
              correctAnswer: 'thursday',
              alternativeAnswers: ['thursday'],
              explanation: '• Đáp án chuẩn: thursday\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'thursday',
            ),
            ListeningQuestion(
              questionNumber: 4,
              type: QuestionType.gapFill,
              questionText: 'is currently doing voluntary work with members of a [4] club',
              options: null,
              correctAnswer: '8.30',
              alternativeAnswers: ['8.30'],
              explanation: '• Đáp án chuẩn: 8.30\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: '8.30',
            ),
            ListeningQuestion(
              questionNumber: 5,
              type: QuestionType.gapFill,
              questionText: 'available for five months from the 1st of [5]',
              options: null,
              correctAnswer: 'red',
              alternativeAnswers: ['red'],
              explanation: '• Đáp án chuẩn: red\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'red',
            ),
            ListeningQuestion(
              questionNumber: 6,
              type: QuestionType.gapFill,
              questionText: 'can\'t eat [6]',
              options: null,
              correctAnswer: 'lunch',
              alternativeAnswers: ['lunch'],
              explanation: '• Đáp án chuẩn: lunch\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'lunch',
            ),
            ListeningQuestion(
              questionNumber: 7,
              type: QuestionType.gapFill,
              questionText: 'address: 27 [7] Place, Dumfries',
              options: null,
              correctAnswer: 'glasses',
              alternativeAnswers: ['glasses'],
              explanation: '• Đáp án chuẩn: glasses\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'glasses',
            ),
            ListeningQuestion(
              questionNumber: 8,
              type: QuestionType.gapFill,
              questionText: 'postcode: [8]',
              options: null,
              correctAnswer: 'ball',
              alternativeAnswers: ['ball'],
              explanation: '• Đáp án chuẩn: ball\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'ball',
            ),
            ListeningQuestion(
              questionNumber: 9,
              type: QuestionType.gapFill,
              questionText: 'interview at 2.30 pm on [9]',
              options: null,
              correctAnswer: 'aunt',
              alternativeAnswers: ['aunt'],
              explanation: '• Đáp án chuẩn: aunt\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'aunt',
            ),
            ListeningQuestion(
              questionNumber: 10,
              type: QuestionType.gapFill,
              questionText: 'will plan a short [10] about being a tour guide',
              options: null,
              correctAnswer: 'month',
              alternativeAnswers: ['month'],
              explanation: '• Đáp án chuẩn: month\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'month',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 2,
          sectionTitle: 'Part 2: VISITING THE SHEEPMARKET AREA',
          sectionInstruction: 'Choose the correct letter A, B or C.',
          fullTranscript: '''Section 2 audio recorded for Cambridge 12 — Test 4. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test4-Section2.mp3

Topics covered: Part 2: VISITING THE SHEEPMARKET AREA.
Follow the audio carefully to answer questions 11 to 20.''',
          questions: [
            ListeningQuestion(
              questionNumber: 11,
              type: QuestionType.multipleChoice,
              questionText: 'Which is the most rapidly-growing group of residents in the Sheepmarket area?',
              options: ['A. young professional people.', 'B. students from the university.', 'C. employees in the local market.'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. employees in the local market.', 'C', 'employees in the local market.'],
              explanation: '• Lựa chọn đúng: C\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 12,
              type: QuestionType.multipleChoice,
              questionText: 'The speaker recommends the side streets in the Sheepmarket for their',
              options: ['A. international restaurants.', 'B. historical buildings.', 'C. arts and crafts.'],
              correctAnswer: 'E',
              alternativeAnswers: ['E', 'e'],
              explanation: '• Lựa chọn đúng: E\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 13,
              type: QuestionType.multipleChoice,
              questionText: 'Clothes designed by entrants for the Young Fashion competition must',
              options: ['A. be modelled by the designers themselves.', 'B. be inspired by aspects of contemporary culture.', 'C. be made from locally produced materials.'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. be inspired by aspects of contemporary culture.', 'B', 'be inspired by aspects of contemporary culture.'],
              explanation: '• Lựa chọn đúng: B\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 14,
              type: QuestionType.multipleChoice,
              questionText: 'Car parking is free in some car parks if you',
              options: ['A. stay for less than an hour.', 'B. buy something in the shops.', 'C. park in the evenings or at weekends.'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. stay for less than an hour.', 'A', 'stay for less than an hour.'],
              explanation: '• Lựa chọn đúng: A\\n• Đối chiếu từ đồng nghĩa và tránh bẫy gây nhiễu trong đoạn hội thoại.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 15,
              type: QuestionType.matching,
              questionText: 'Art and History in the Sheepmarket: The Reynolds House',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H', 'I. I'],
              correctAnswer: 'C',
              alternativeAnswers: ['C', 'c'],
              explanation: '• Nối chính xác: C cho "The Reynolds House".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 16,
              type: QuestionType.matching,
              questionText: 'Art and History in the Sheepmarket: The Thumb',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H', 'I. I'],
              correctAnswer: 'B',
              alternativeAnswers: ['B', 'b'],
              explanation: '• Nối chính xác: B cho "The Thumb".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 17,
              type: QuestionType.matching,
              questionText: 'Art and History in the Sheepmarket: The Museum',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H', 'I. I'],
              correctAnswer: 'C',
              alternativeAnswers: ['C', 'c'],
              explanation: '• Nối chính xác: C cho "The Museum".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 18,
              type: QuestionType.matching,
              questionText: 'Art and History in the Sheepmarket: The Contemporary Art Gallery',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H', 'I. I'],
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Nối chính xác: D cho "The Contemporary Art Gallery".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 19,
              type: QuestionType.matching,
              questionText: 'Art and History in the Sheepmarket: The Warner Gallery',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H', 'I. I'],
              correctAnswer: 'D',
              alternativeAnswers: ['D', 'd'],
              explanation: '• Nối chính xác: D cho "The Warner Gallery".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 20,
              type: QuestionType.matching,
              questionText: 'Art and History in the Sheepmarket: Nucleus',
              options: ['A. A', 'B. B', 'C. C', 'D. D', 'E. E', 'F. F', 'G. G', 'H. H', 'I. I'],
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Nối chính xác: A cho "Nucleus".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'A',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 3,
          sectionTitle: 'Part 3: PRESENTATION OF FILM ADAPTATIONS OF SHAKESPEARE\'S PLAYS',
          sectionInstruction: 'Complete the table below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Section 3 audio recorded for Cambridge 12 — Test 4. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test4-Section3.mp3

Topics covered: Part 3: PRESENTATION OF FILM ADAPTATIONS OF SHAKESPEARE'S PLAYS.
Follow the audio carefully to answer questions 21 to 30.''',
          questions: [
            ListeningQuestion(
              questionNumber: 21,
              type: QuestionType.gapFill,
              questionText: 'Introduce Giannetti\'s book containing a [21] of adaptations',
              options: null,
              correctAnswer: 'C',
              alternativeAnswers: ['C', 'c'],
              explanation: '• Đáp án chuẩn: C\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'C',
            ),
            ListeningQuestion(
              questionNumber: 22,
              type: QuestionType.gapFill,
              questionText: 'Ask class to suggest the [22] adaptations',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 23,
              type: QuestionType.gapFill,
              questionText: 'Prepare some [23]',
              options: null,
              correctAnswer: 'A',
              alternativeAnswers: ['A', 'a'],
              explanation: '• Đáp án chuẩn: A\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 24,
              type: QuestionType.gapFill,
              questionText: 'Discuss relationship between adaptations and [24] at the time of making the film',
              options: null,
              correctAnswer: 'B',
              alternativeAnswers: ['B', 'b'],
              explanation: '• Đáp án chuẩn: B\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 25,
              type: QuestionType.matching,
              questionText: 'Films: Ran',
              options: ['A. clearly shows the historical period', 'B. contains only parts of the play', 'C. is too similar to another kind of film', 'D. turned out to be unpopular with audiences', 'E. presents the play in a different period from the original', 'F. sets the original in a different country', 'G. incorporates a variety of art forms'],
              correctAnswer: 'B',
              alternativeAnswers: ['B. contains only parts of the play', 'B', 'contains only parts of the play'],
              explanation: '• Nối chính xác: B cho "Ran".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'B',
            ),
            ListeningQuestion(
              questionNumber: 26,
              type: QuestionType.matching,
              questionText: 'Films: Much Ado About Nothing',
              options: ['A. clearly shows the historical period', 'B. contains only parts of the play', 'C. is too similar to another kind of film', 'D. turned out to be unpopular with audiences', 'E. presents the play in a different period from the original', 'F. sets the original in a different country', 'G. incorporates a variety of art forms'],
              correctAnswer: 'E',
              alternativeAnswers: ['E. presents the play in a different period from the original', 'E', 'presents the play in a different period from the original'],
              explanation: '• Nối chính xác: E cho "Much Ado About Nothing".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'E',
            ),
            ListeningQuestion(
              questionNumber: 27,
              type: QuestionType.matching,
              questionText: 'Films: Romeo & Juliet',
              options: ['A. clearly shows the historical period', 'B. contains only parts of the play', 'C. is too similar to another kind of film', 'D. turned out to be unpopular with audiences', 'E. presents the play in a different period from the original', 'F. sets the original in a different country', 'G. incorporates a variety of art forms'],
              correctAnswer: 'D',
              alternativeAnswers: ['D. turned out to be unpopular with audiences', 'D', 'turned out to be unpopular with audiences'],
              explanation: '• Nối chính xác: D cho "Romeo & Juliet".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'D',
            ),
            ListeningQuestion(
              questionNumber: 28,
              type: QuestionType.matching,
              questionText: 'Films: Hamlet',
              options: ['A. clearly shows the historical period', 'B. contains only parts of the play', 'C. is too similar to another kind of film', 'D. turned out to be unpopular with audiences', 'E. presents the play in a different period from the original', 'F. sets the original in a different country', 'G. incorporates a variety of art forms'],
              correctAnswer: 'A',
              alternativeAnswers: ['A. clearly shows the historical period', 'A', 'clearly shows the historical period'],
              explanation: '• Nối chính xác: A cho "Hamlet".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'A',
            ),
            ListeningQuestion(
              questionNumber: 29,
              type: QuestionType.matching,
              questionText: 'Films: Prospero\'s Books',
              options: ['A. clearly shows the historical period', 'B. contains only parts of the play', 'C. is too similar to another kind of film', 'D. turned out to be unpopular with audiences', 'E. presents the play in a different period from the original', 'F. sets the original in a different country', 'G. incorporates a variety of art forms'],
              correctAnswer: 'G',
              alternativeAnswers: ['G. incorporates a variety of art forms', 'G', 'incorporates a variety of art forms'],
              explanation: '• Nối chính xác: G cho "Prospero\'s Books".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'G',
            ),
            ListeningQuestion(
              questionNumber: 30,
              type: QuestionType.matching,
              questionText: 'Films: Looking for Richard',
              options: ['A. clearly shows the historical period', 'B. contains only parts of the play', 'C. is too similar to another kind of film', 'D. turned out to be unpopular with audiences', 'E. presents the play in a different period from the original', 'F. sets the original in a different country', 'G. incorporates a variety of art forms'],
              correctAnswer: 'C',
              alternativeAnswers: ['C. is too similar to another kind of film', 'C', 'is too similar to another kind of film'],
              explanation: '• Nối chính xác: C cho "Looking for Richard".\\n• Chú ý các từ miêu tả tương đương trong băng ghi âm.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'C',
            ),
          ],
        ),
        ListeningSection(
          partNumber: 4,
          sectionTitle: 'Part 4: NOISE IN CITIES',
          sectionInstruction: 'Complete the notes below. Write ONE WORD ONLY for each answer.',
          fullTranscript: '''Section 4 audio recorded for Cambridge 12 — Test 4. Audio stream: https://pub-c71988294a9b45099e83dad66bb73426.r2.dev/ielts-listening/cam12/08_Cam12-Test4-Section4.mp3

Topics covered: Part 4: NOISE IN CITIES.
Follow the audio carefully to answer questions 31 to 40.''',
          questions: [
            ListeningQuestion(
              questionNumber: 31,
              type: QuestionType.gapFill,
              questionText: 'do not show other sources of noise, e.g. when windows are open or people\'s neighbours are in their [31]',
              options: null,
              correctAnswer: 'achievement',
              alternativeAnswers: ['achievement/achievements', 'achievement', 'achievements'],
              explanation: '• Đáp án chuẩn: achievement\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 10,
              transcriptEvidence: 'achievement',
            ),
            ListeningQuestion(
              questionNumber: 32,
              type: QuestionType.gapFill,
              questionText: 'have made people realize that the noise is a [32] issue that must be dealt with',
              options: null,
              correctAnswer: 'personality',
              alternativeAnswers: ['personality/character', 'personality', 'character'],
              explanation: '• Đáp án chuẩn: personality\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 28,
              transcriptEvidence: 'personality',
            ),
            ListeningQuestion(
              questionNumber: 33,
              type: QuestionType.gapFill,
              questionText: 'effect on the [33] of schoolchildren',
              options: null,
              correctAnswer: 'situational',
              alternativeAnswers: ['situational'],
              explanation: '• Đáp án chuẩn: situational\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 46,
              transcriptEvidence: 'situational',
            ),
            ListeningQuestion(
              questionNumber: 34,
              type: QuestionType.gapFill,
              questionText: 'Some noises can be considered pleasant e.g. the sound of a [34] in a town',
              options: null,
              correctAnswer: 'friend',
              alternativeAnswers: ['friend'],
              explanation: '• Đáp án chuẩn: friend\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 64,
              transcriptEvidence: 'friend',
            ),
            ListeningQuestion(
              questionNumber: 35,
              type: QuestionType.gapFill,
              questionText: 'To investigate this, researchers may use methods from [35] sciences e.g. questionnaires',
              options: null,
              correctAnswer: 'aspirations',
              alternativeAnswers: ['aspirations/ambitions', 'aspirations', 'ambitions'],
              explanation: '• Đáp án chuẩn: aspirations\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 82,
              transcriptEvidence: 'aspirations',
            ),
            ListeningQuestion(
              questionNumber: 36,
              type: QuestionType.gapFill,
              questionText: 'Plenty of activity in urban environments which are [36], but also allow people to relax',
              options: null,
              correctAnswer: 'style',
              alternativeAnswers: ['style'],
              explanation: '• Đáp án chuẩn: style\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 100,
              transcriptEvidence: 'style',
            ),
            ListeningQuestion(
              questionNumber: 37,
              type: QuestionType.gapFill,
              questionText: 'do not get much [37] in acoustics',
              options: null,
              correctAnswer: 'development',
              alternativeAnswers: ['development'],
              explanation: '• Đáp án chuẩn: development\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 118,
              transcriptEvidence: 'development',
            ),
            ListeningQuestion(
              questionNumber: 38,
              type: QuestionType.gapFill,
              questionText: 'how sound relates to [38]',
              options: null,
              correctAnswer: 'vision',
              alternativeAnswers: ['vision'],
              explanation: '• Đáp án chuẩn: vision\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 136,
              transcriptEvidence: 'vision',
            ),
            ListeningQuestion(
              questionNumber: 39,
              type: QuestionType.gapFill,
              questionText: 'whether physics can help us understand the [39] of sound',
              options: null,
              correctAnswer: 'structures',
              alternativeAnswers: ['structures'],
              explanation: '• Đáp án chuẩn: structures\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 154,
              transcriptEvidence: 'structures',
            ),
            ListeningQuestion(
              questionNumber: 40,
              type: QuestionType.gapFill,
              questionText: 'current disadvantage: they are [40]',
              options: null,
              correctAnswer: 'innovation',
              alternativeAnswers: ['innovation/innovations', 'innovation', 'innovations'],
              explanation: '• Đáp án chuẩn: innovation\\n• Cần chú ý nghe đúng chính tả và số lượng từ quy định.',
              audioTimestampSeconds: 172,
              transcriptEvidence: 'innovation',
            ),
          ],
        ),
      ],
    ),
  ];
}
