import '../models/speaking_shadowing_model.dart';

class SpeakingShadowingData {
  static const List<ShadowingExercise> allExercises = [
    // ------------------------------------------------------------------------
    // 1. IELTS Speaking Band 8.0 - Hometown & Heritage
    // ------------------------------------------------------------------------
    ShadowingExercise(
      id: 'shd_ielts_hometown',
      title: 'Hometown & Cultural Heritage',
      topic: 'Hometown',
      category: 'ielts_speaking',
      bandTarget: 'Band 7.5 - 8.5',
      description: 'Luyện ngữ điệu mô tả nơi chốn với từ vựng Band 8.0 và cách nhấn trọng âm cảm xúc.',
      sentences: [
        ShadowingSentence(
          id: 'shd_ht_1',
          englishText: 'I was born and raised in a bustling coastal city that never seems to sleep.',
          vietnameseTranslation: 'Tôi sinh ra và lớn lên tại một thành phố ven biển nhộn nhịp dường như không bao giờ ngủ.',
          phonetic: '/aɪ wɒz bɔːn ænd reɪzd ɪn ə ˈbʌslɪŋ ˈkəʊstl ˈsɪti ðæt ˈnɛvə siːmz tuː sliːp/',
          stressWords: ['born', 'raised', 'bustling', 'coastal', 'never', 'sleep'],
        ),
        ShadowingSentence(
          id: 'shd_ht_2',
          englishText: 'What I treasure most about my hometown is the genuinely hospitable and welcoming locals.',
          vietnameseTranslation: 'Điều tôi trân quý nhất về quê hương mình là những người dân bản địa thực sự hiếu khách và nồng ấm.',
          phonetic: '/wɒt aɪ ˈtrɛʒə məʊst əˈbaʊt maɪ ˈhəʊmtaʊn ɪz ðə ˈʤɛnjʊɪnli ˈhɒspɪtəbl ænd ˈwɛlkəmɪŋ ˈləʊkəlz/',
          stressWords: ['treasure', 'hometown', 'genuinely', 'hospitable', 'welcoming'],
        ),
        ShadowingSentence(
          id: 'shd_ht_3',
          englishText: 'Over the past decade, rapid urban development has transformed the local skyline dramatically.',
          vietnameseTranslation: 'Trong thập kỷ qua, sự phát triển đô thị nhanh chóng đã biến đổi đường chân trời nơi đây một cách ngoạn mục.',
          phonetic: '/ˈəʊvə ðə pɑːst ˈdɛkeɪd ˈræpɪd ˈɜːbən dɪˈvɛləpmənt hæz trænsˈfɔːmd ðə ˈləʊkəl ˈskaɪlaɪn drəˈmætɪkli/',
          stressWords: ['decade', 'rapid', 'urban', 'transformed', 'dramatically'],
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 2. IELTS Speaking Band 8.0 - Technology & Artificial Intelligence
    // ------------------------------------------------------------------------
    ShadowingExercise(
      id: 'shd_ielts_tech',
      title: 'Artificial Intelligence & Modern Life',
      topic: 'Technology',
      category: 'ielts_speaking',
      bandTarget: 'Band 7.5 - 8.5',
      description: 'Ngữ điệu bàn luận công nghệ, thể hiện quan điểm khách quan với nhịp nói chuẩn tự nhiên.',
      sentences: [
        ShadowingSentence(
          id: 'shd_tech_1',
          englishText: 'Artificial intelligence has undoubtedly revolutionized the way we acquire new knowledge.',
          vietnameseTranslation: 'Trí tuệ nhân tạo chắc chắn đã tạo nên cuộc cách mạng trong cách chúng ta tiếp thu kiến thức mới.',
          phonetic: '/ˌɑːtɪˈfɪʃəl ɪnˈtɛlɪʤəns hæz ʌnˈdaʊtɪdli ˌrɛvəˈluːʃnaɪzd ðə weɪ wiː əˈkwaɪə njuː ˈnɒlɪʤ/',
          stressWords: ['Artificial', 'intelligence', 'undoubtedly', 'revolutionized', 'knowledge'],
        ),
        ShadowingSentence(
          id: 'shd_tech_2',
          englishText: 'While digital tools offer immense convenience, we must establish healthy technological boundaries.',
          vietnameseTranslation: 'Mặc dù các công cụ kỹ thuật số mang lại sự tiện lợi to lớn, chúng ta phải thiết lập những ranh giới lành mạnh.',
          phonetic: '/waɪl ˈdɪʤɪtl tuːlz ˈɒfə ɪˈmɛns kənˈviːnjəns wiː mʌst ɪsˈtæblɪʃ ˈhɛlθi ˌtɛknəˈlɒʤɪkəl ˈbaʊndəriz/',
          stressWords: ['immense', 'convenience', 'healthy', 'boundaries'],
        ),
        ShadowingSentence(
          id: 'shd_tech_3',
          englishText: 'I rely heavily on smart productivity applications to keep my academic schedule seamless.',
          vietnameseTranslation: 'Tôi phụ thuộc khá nhiều vào các ứng dụng năng suất thông minh để giữ lịch trình học tập luôn trơn tru.',
          phonetic: '/aɪ rɪˈlaɪ ˈhɛvɪli ɒn smɑːt ˌprɒdʌkˈtɪvɪti ˌæplɪˈkeɪʃənz tuː kiːp maɪ ˌækəˈdɛmɪk ˈʃɛdjuːl ˈsiːmləs/',
          stressWords: ['heavily', 'smart', 'productivity', 'seamless'],
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 3. IELTS Speaking Band 8.0 - Career & Work-Life Balance
    // ------------------------------------------------------------------------
    ShadowingExercise(
      id: 'shd_ielts_career',
      title: 'Career Ambitions & Well-being',
      topic: 'Career',
      category: 'ielts_speaking',
      bandTarget: 'Band 7.5 - 8.5',
      description: 'Luyện nhấn nhá các mệnh đề phức và diễn đạt mục tiêu nghề nghiệp đầy tự tin.',
      sentences: [
        ShadowingSentence(
          id: 'shd_cr_1',
          englishText: 'Striking a healthy work-life balance is vital for sustained psychological well-being.',
          vietnameseTranslation: 'Đạt được sự cân bằng lành mạnh giữa công việc và cuộc sống là điều tối quan trọng đối với sức khỏe tinh thần lâu dài.',
          phonetic: '/ˈstraɪkɪŋ ə ˈhɛlθi wɜːk laɪf ˈbæləns ɪz ˈvaɪtl fɔː səsˈteɪnd ˌsaɪkəˈlɒʤɪkəl ˈwɛlˌbiːɪŋ/',
          stressWords: ['Striking', 'healthy', 'balance', 'vital', 'psychological', 'well-being'],
        ),
        ShadowingSentence(
          id: 'shd_cr_2',
          englishText: 'I have always thrived in collaborative environments that tackle intellectually demanding problems.',
          vietnameseTranslation: 'Tôi luôn phát triển mạnh mẽ trong các môi trường làm việc hợp tác cùng giải quyết những bài toán đòi hỏi tư duy cao.',
          phonetic: '/aɪ hæv ˈɔːlweɪz θraɪvd ɪn kəˈlæbərətɪv ɪnˈvaɪərənmənts ðæt ˈtækl ˌɪntɪˈlɛktjʊəli dɪˈmɑːndɪŋ ˈprɒbləmz/',
          stressWords: ['thrived', 'collaborative', 'environments', 'demanding'],
        ),
        ShadowingSentence(
          id: 'shd_cr_3',
          englishText: 'In the foreseeable future, I aspire to spearhead innovative educational community initiatives.',
          vietnameseTranslation: 'Trong tương lai gần, tôi khao khát được dẫn đầu các sáng kiến giáo dục đổi mới sáng tạo cho cộng đồng.',
          phonetic: '/ɪn ðə fɔːˈsiːəbl ˈfjuːʧə aɪ əsˈpaɪə tuː ˈspɪəhɛd ˈɪnəvətɪv ˌɛʤʊˈkeɪʃənl kəˈmjuːnɪti ɪˈnɪʃɪətɪvz/',
          stressWords: ['foreseeable', 'future', 'aspire', 'spearhead', 'innovative'],
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 4. Natural Conversation - Socializing & Weekend Downtime
    // ------------------------------------------------------------------------
    ShadowingExercise(
      id: 'shd_conv_weekend',
      title: 'Casual Chat & Weekend Downtime',
      topic: 'Conversations',
      category: 'conversation',
      bandTarget: 'Band 6.5 - 7.5',
      description: 'Học cách luyến âm tự nhiên của người bản xứ trong các cuộc trò chuyện thân mật hàng ngày.',
      sentences: [
        ShadowingSentence(
          id: 'shd_wk_1',
          englishText: 'To be completely honest, I could not ask for a better way to unwind after such an exhausting week.',
          vietnameseTranslation: 'Thành thật mà nói, tôi chẳng thể mong một cách thư giãn nào tuyệt hơn sau một tuần mệt mỏi như vậy.',
          phonetic: '/tuː biː kəmˈpliːtli ˈɒnɪst aɪ kʊd nɒt ɑːsk fɔːr ə ˈbɛtə weɪ tuː ʌnˈwaɪnd ˈɑːftə sʌʧ ən ɪgˈzɔːstɪŋ wiːk/',
          stressWords: ['honesty', 'better', 'unwind', 'exhausting'],
        ),
        ShadowingSentence(
          id: 'shd_wk_2',
          englishText: 'How about we grab some artisan coffee and catch up on everything we have missed?',
          vietnameseTranslation: 'Hay là chúng mình đi làm tách cà phê thủ công rồi cập nhật tình hình sau bao ngày không gặp nhé?',
          phonetic: '/haʊ əˈbaʊt wiː græb sʌm ˈɑːtɪzæn ˈkɒfi ænd kæʧ ʌp ɒn ˈɛvrɪθɪŋ wiː hæv mɪst/',
          stressWords: ['grab', 'artisan', 'coffee', 'catch up'],
        ),
        ShadowingSentence(
          id: 'shd_wk_3',
          englishText: 'That sounds like an absolute blast, count me in without any hesitation!',
          vietnameseTranslation: 'Nghe có vẻ vui hết nấc đấy, cứ tính phần tôi vào mà không cần do dự gì nhé!',
          phonetic: '/ðæt saʊndz laɪk ən ˈæbsəluːt blɑːst kaʊnt miː ɪn wɪˈðaʊt ˈɛni ˌhɛzɪˈteɪʃən/',
          stressWords: ['absolute', 'blast', 'count me in', 'hesitation'],
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 5. Natural Conversation - Expressing Perspectives & Nuance
    // ------------------------------------------------------------------------
    ShadowingExercise(
      id: 'shd_conv_opinions',
      title: 'Nuanced Opinions & Gentle Debating',
      topic: 'Opinions',
      category: 'conversation',
      bandTarget: 'Band 7.0 - 8.0',
      description: 'Luyện ngữ điệu bày tỏ góc nhìn đa chiều, phản biện lịch thiệp và giữ hòa khí trong đàm thoại.',
      sentences: [
        ShadowingSentence(
          id: 'shd_op_1',
          englishText: 'From my personal perspective, there is definitely no one-size-fits-all solution to this issue.',
          vietnameseTranslation: 'Theo góc nhìn cá nhân của tôi, chắc chắn không có một giải pháp chung nào phù hợp cho mọi hoàn cảnh trong vấn đề này.',
          phonetic: '/frɒm maɪ ˈpɜːsnl pəˈspɛktɪv ðeər ɪz ˈdɛfɪnɪtli nəʊ wʌn saɪz fɪts ɔːl səˈluːʃən tuː ðɪs ˈɪʃuː/',
          stressWords: ['personal', 'perspective', 'definitely', 'one-size-fits-all'],
        ),
        ShadowingSentence(
          id: 'shd_op_2',
          englishText: 'I completely see where you are coming from, though we also need to weigh the long-term trade-offs.',
          vietnameseTranslation: 'Tôi hoàn toàn hiểu lý lẽ của bạn, dẫu vậy chúng ta cũng cần cân nhắc những sự đánh đổi về lâu dài.',
          phonetic: '/aɪ kəmˈpliːtli siː weə juː ɑː ˈkʌmɪŋ frɒm ðəʊ wiː ˈɔːlsəʊ niːd tuː weɪ ðə lɒŋ tɜːm treɪd ɒfs/',
          stressWords: ['completely', 'see', 'weigh', 'long-term', 'trade-offs'],
        ),
        ShadowingSentence(
          id: 'shd_op_3',
          englishText: 'That is a remarkably perceptive insight that often gets overlooked in typical discussions.',
          vietnameseTranslation: 'Đó là một nhận định sắc bén và sâu sắc mà thường bị bỏ qua trong các cuộc thảo luận thông thường.',
          phonetic: '/ðæt ɪz ə rɪˈmɑːkəbli pəˈsɛptɪv ˈɪnsaɪt ðæt ˈɒfn gɛts ˌəʊvəˈlʊkt ɪn ˈtɪpɪkəl dɪsˈkʌʃənz/',
          stressWords: ['remarkably', 'perceptive', 'insight', 'overlooked'],
        ),
      ],
    ),
  ];
}
