# StudyDeck AI — Thiết kế Cơ sở dữ liệu

> Trích từ tài liệu SRS_StudyDeck_AI.docx, mục 4 (Database Design)
> CSDL: PostgreSQL, mở rộng bằng **pgvector** để lưu vector embedding phục vụ RAG.

---

## 1. Sơ đồ quan hệ thực thể (ERD) — Mối quan hệ giữa các bảng

| # | Quan hệ | Mô tả |
|---|---------|-------|
| 1 | `users` (1) — (n) `decks`, `documents`, `quiz_results`, `learning_logs`, `recommendations` | Một người dùng sở hữu nhiều bộ thẻ, tài liệu, kết quả làm bài, nhật ký học tập và đề xuất học tập. |
| 2 | `courses` (1) — (n) `lessons` (1) — (n) `vocabulary` | Khóa học chứa nhiều bài học, mỗi bài học chứa nhiều mục từ vựng/ngữ pháp (bảng `vocabulary` dùng chung, phân biệt bằng trường `type`). |
| 3 | `decks` (1) — (n) `flashcards` | Mỗi bộ thẻ chứa nhiều flashcard. |
| 4 | `vocabulary` (1) — (n) `flashcards` *(nullable)* | Flashcard tham chiếu tới `vocabulary_id` khi được tạo từ nội dung khóa học hoặc do AI trích xuất. Nếu người học tự thêm từ ngoài chương trình (VD: trích từ tài liệu RAG), flashcard lưu trực tiếp qua `custom_word`/`custom_meaning` mà không cần bản ghi `vocabulary` tương ứng. |
| 5 | `lessons` (1) — (n) `quizzes` (1) — (n) `questions` | Một bài học có thể gắn nhiều quiz, mỗi quiz gồm nhiều câu hỏi; `questions` có thể tham chiếu `vocabulary` (tùy chọn) để biết câu hỏi kiểm tra từ vựng nào. |
| 6 | `users` (1) — (n) `quiz_results` (1) — (n) `quiz_answers` | Mỗi lượt làm bài được ghi lại chi tiết theo từng câu trả lời, phục vụ phân tích sâu cho Learning Analytics. |
| 7 | `documents` (1) — (n) `document_chunks` | Mỗi tài liệu được chia thành nhiều đoạn (chunk) có vector embedding riêng. |
| 8 | `recommendations` → `vocabulary` *(tùy chọn)* | Xác định đề xuất ôn tập gắn với từ vựng cụ thể nào. |
| 9 | `users` (1) — (n) `writing_submissions` | Mỗi bài viết người dùng nộp được lưu lại kèm điểm và nhận xét chi tiết từ AI Writing Evaluator. |
| 10 | `lessons` (1) — (n) `reading_passages`, `listening_exercises` *(nullable)* | Một bài học có thể gắn kèm bài đọc/bài nghe bổ trợ, hoặc do AI sinh độc lập không gắn bài học cụ thể. |
| 11 | `quizzes` (1) — (n) `reading_passages`, `listening_exercises` *(tùy chọn)* | Mỗi bài đọc/bài nghe có thể gắn một bộ câu hỏi kiểm tra hiểu bài, tái sử dụng lại hạ tầng `quizzes`/`questions`/`quiz_results` sẵn có thay vì tạo cơ chế chấm điểm riêng. |

---

## 2. Đặc tả các bảng dữ liệu chính

### `users`
Quản lý tài khoản, xác thực, phân quyền và hồ sơ học tập của người dùng.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh duy nhất của người dùng. |
| email | VARCHAR(100) | Unique, Not Null | Địa chỉ email dùng để đăng nhập. |
| password_hash | VARCHAR(255) | Not Null | Mật khẩu đã mã hóa. |
| full_name | VARCHAR(100) | | Họ và tên người dùng. |
| role | ENUM | Not Null | Learner, Administrator. |
| level | VARCHAR(20) | | Trình độ hiện tại của học viên. |
| target_level | VARCHAR(20) | | Mục tiêu trình độ muốn đạt được. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm tạo tài khoản. |
| updated_at | TIMESTAMP | Nullable | Thời điểm cập nhật hồ sơ gần nhất. |
| last_login_at | TIMESTAMP | Nullable | Thời điểm đăng nhập gần nhất. |
| avatar_url | VARCHAR(255) | Nullable | Đường dẫn ảnh đại diện của người dùng. |

### `courses`
Danh mục các khóa học theo chủ đề và trình độ.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh khóa học. |
| title | VARCHAR(150) | Not Null | Tên khóa học. |
| topic | VARCHAR(50) | | Chủ đề (giao tiếp, TOEIC...). |
| level | VARCHAR(20) | | Trình độ áp dụng. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm tạo khóa học. |
| description | TEXT | Nullable | Mô tả chi tiết nội dung khóa học. |
| thumbnail_url | VARCHAR(255) | Nullable | Đường dẫn ảnh đại diện (thumbnail) của khóa học. |

### `lessons`
Các bài học cụ thể thuộc một khóa học, theo thứ tự học.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh bài học. |
| course_id | UUID | Foreign Key → courses | Khóa học chứa bài học này. |
| title | VARCHAR(150) | Not Null | Tên bài học. |
| order_index | INT | | Thứ tự bài học trong khóa học. |
| content | TEXT | | Nội dung/diễn giải của bài học. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm tạo bài học. |

### `vocabulary`
Kho từ vựng và điểm ngữ pháp gốc của hệ thống, dùng chung cho toàn bộ nội dung học tập (bài học, flashcard AI sinh, câu hỏi quiz, đề xuất ôn tập).

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh mục từ vựng/ngữ pháp. |
| lesson_id | UUID | Foreign Key → lessons | Bài học chứa mục này (có thể null nếu do AI trích xuất độc lập). |
| type | ENUM | Not Null | `word` (từ vựng) hoặc `grammar` (ngữ pháp). |
| term | VARCHAR(100) | Not Null | Từ vựng hoặc tên điểm ngữ pháp. |
| meaning | TEXT | Not Null | Nghĩa hoặc giải thích ngữ pháp. |
| example | TEXT | | Câu ví dụ minh họa. |
| pronunciation | VARCHAR(50) | | Phiên âm IPA (áp dụng cho từ vựng). |
| source | ENUM | | `system` (giáo trình) hoặc `ai_generated`. |
| part_of_speech | VARCHAR(20) | Nullable | Từ loại (danh từ, động từ, tính từ...), áp dụng cho mục `type = word`. |
| audio_url | VARCHAR(255) | Nullable | Đường dẫn file âm thanh phát âm của từ vựng. |

### `decks`
Bộ thẻ ghi nhớ (Deck) do người dùng tạo hoặc AI tự động sinh.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh bộ thẻ. |
| user_id | UUID | Foreign Key → users | Chủ sở hữu bộ thẻ. |
| name | VARCHAR(100) | Not Null | Tên bộ thẻ. |
| description | VARCHAR(255) | | Mô tả ngắn về bộ thẻ. |
| is_ai_generated | BOOLEAN | Default false | Bộ thẻ có do AI tự sinh hay không. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm tạo bộ thẻ. |

### `flashcards`
Thẻ ghi nhớ trong một Deck; có thể tham chiếu tới từ vựng gốc (`vocabulary`) hoặc lưu nội dung tự do do người dùng thêm.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh flashcard. |
| deck_id | UUID | Foreign Key → decks | Bộ thẻ chứa flashcard này. |
| vocabulary_id | UUID | Foreign Key → vocabulary (nullable) | Từ vựng gốc nếu thẻ tạo từ khóa học/AI trích xuất. |
| custom_word | VARCHAR(100) | Nullable | Từ do người dùng tự thêm (khi không có `vocabulary_id`). |
| custom_meaning | TEXT | Nullable | Nghĩa tự thêm tương ứng. |
| ease_factor | FLOAT | Default 2.5 | Hệ số độ dễ (thuật toán SM-2). |
| interval_days | INT | Default 1 | Chu kỳ ôn tập hiện tại (ngày). |
| next_review_at | TIMESTAMP | | Thời điểm ôn tập kế tiếp. |
| source | ENUM | | `manual`, `ai_generated`, `rag_document`. |
| repetition_count | INT | Default 0 | Số lần thẻ đã được ôn tập, phục vụ thuật toán SM-2. |
| last_reviewed_at | TIMESTAMP | Nullable | Thời điểm ôn tập gần nhất của thẻ. |

### `quizzes`
Bài kiểm tra gắn với một bài học hoặc do AI sinh tự do theo yêu cầu ôn tập.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh bài quiz. |
| lesson_id | UUID | Foreign Key → lessons (nullable) | Bài học liên quan (null nếu AI sinh tự do). |
| title | VARCHAR(150) | Not Null | Tên bài kiểm tra. |
| quiz_type | ENUM | | `multiple_choice`, `fill_blank`, `matching`. |
| created_by | ENUM | | `system` hoặc `ai_generated`. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm tạo bài quiz. |

### `questions`
Câu hỏi cụ thể thuộc một bài quiz.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh câu hỏi. |
| quiz_id | UUID | Foreign Key → quizzes | Bài quiz chứa câu hỏi này. |
| vocabulary_id | UUID | Foreign Key → vocabulary (nullable) | Từ vựng được kiểm tra (nếu có). |
| question_type | ENUM | | `multiple_choice`, `fill_blank`, `matching`. |
| content | TEXT | Not Null | Nội dung câu hỏi. |
| options | JSON | | Các lựa chọn (áp dụng cho trắc nghiệm). |
| correct_answer | TEXT | Not Null | Đáp án đúng. |

### `quiz_results`
Kết quả tổng hợp của một lượt làm bài quiz.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh lượt làm bài. |
| quiz_id | UUID | Foreign Key → quizzes | Bài quiz đã làm. |
| user_id | UUID | Foreign Key → users | Người thực hiện. |
| score | FLOAT | | Điểm số đạt được. |
| total_questions | INT | | Tổng số câu hỏi. |
| correct_count | INT | | Số câu trả lời đúng. |
| started_at | TIMESTAMP | | Thời điểm bắt đầu làm bài. |
| completed_at | TIMESTAMP | | Thời điểm hoàn thành. |

### `quiz_answers`
Chi tiết từng câu trả lời trong một lượt làm bài — dữ liệu đầu vào quan trọng cho Learning Analytics.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh bản ghi trả lời. |
| quiz_result_id | UUID | Foreign Key → quiz_results | Thuộc lượt làm bài nào. |
| question_id | UUID | Foreign Key → questions | Câu hỏi được trả lời. |
| user_answer | TEXT | | Nội dung câu trả lời của người dùng. |
| is_correct | BOOLEAN | | Trả lời đúng hay sai. |

### `documents`
Tài liệu do người dùng tải lên phục vụ chức năng RAG.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh tài liệu. |
| user_id | UUID | Foreign Key → users | Người tải lên tài liệu. |
| file_name | VARCHAR(150) | Not Null | Tên tệp gốc. |
| file_path | TEXT | Not Null | Đường dẫn lưu trữ tệp. |
| file_type | ENUM | Not Null | `pdf`, `docx`. |
| file_size | INT | | Dung lượng tệp (byte). |
| status | ENUM | Default `processing` | `processing`, `ready`, `failed`. |
| uploaded_at | TIMESTAMP | Default NOW() | Thời điểm tải lên. |

### `document_chunks`
Các đoạn văn bản được chia nhỏ từ tài liệu, kèm vector embedding phục vụ tìm kiếm ngữ nghĩa.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh đoạn tài liệu. |
| document_id | UUID | Foreign Key → documents | Tài liệu gốc chứa đoạn này. |
| chunk_index | INT | | Thứ tự đoạn trong tài liệu. |
| chunk_text | TEXT | Not Null | Nội dung đoạn văn bản. |
| embedding | VECTOR | pgvector | Vector embedding của đoạn văn bản. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm xử lý. |

### `learning_logs`
Nhật ký ghi nhận mọi hoạt động học tập của người dùng, làm dữ liệu đầu vào cho Learning Analytics.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh bản ghi. |
| user_id | UUID | Foreign Key → users | Người dùng thực hiện hoạt động. |
| activity_type | ENUM | Not Null | `flashcard_review`, `quiz_attempt`, `ai_tutor_chat`, `document_qna`, `lesson_view`. |
| reference_id | UUID | | ID đối tượng liên quan (flashcard/quiz/...). |
| duration_seconds | INT | | Thời lượng thực hiện (giây). |
| is_correct | BOOLEAN | Nullable | Đúng/Sai, áp dụng cho flashcard/quiz. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm ghi nhận. |

### `recommendations`
Đề xuất học tập cá nhân hóa do Learning Analytics sinh ra cho từng người dùng.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | UUID | Primary Key | Định danh đề xuất. |
| user_id | UUID | Foreign Key → users | Người nhận đề xuất. |
| vocabulary_id | UUID | Foreign Key → vocabulary (nullable) | Từ vựng cụ thể được đề xuất ôn tập. |
| recommendation_type | ENUM | | `review_vocab`, `retry_quiz`, `new_lesson`. |
| predicted_retention | FLOAT | | Xác suất ghi nhớ dự đoán. |
| recommended_content | TEXT | | Mô tả nội dung được đề xuất. |
| is_dismissed | BOOLEAN | Default false | Người dùng đã bỏ qua đề xuất hay chưa. |
| created_at | TIMESTAMP | Default NOW() | Thời điểm sinh đề xuất. |

---

## 3. Các bảng bổ sung (chưa có đặc tả cột chi tiết trong SRS v1.0.0)

> Theo lưu ý ở mục 3.8 của SRS: để phục vụ nhóm màn hình Premium/Gamification, cần bổ sung các bảng sau ngoài phạm vi phiên bản hiện tại. Mô hình thu phí cũng cần bổ sung yêu cầu phi chức năng riêng về bảo mật thanh toán (PCI-DSS nếu tích hợp cổng thanh toán bên thứ ba) và chính sách hoàn tiền.

| Bảng | Mục đích |
|---|---|
| `subscriptions` | Gói Premium, trạng thái, ngày gia hạn. |
| `user_levels` | Điểm kinh nghiệm, cấp độ người dùng. |
| `badges` / `user_badges` | Huy hiệu đã mở khóa. |
| `leaderboard_entries` | Xếp hạng theo chu kỳ (tuần/tháng). |

---

## 4. Sơ đồ liên kết dạng tổng quan

```
users ──┬──< decks ──< flashcards >── vocabulary ──< recommendations
        ├──< documents ──< document_chunks
        ├──< quiz_results ──< quiz_answers
        ├──< learning_logs
        └──< writing_submissions

courses ──< lessons ──< vocabulary
                 │
                 ├──< quizzes ──< questions
                 └──< reading_passages / listening_exercises (nullable)
                              │
                              └── quizzes (tùy chọn, tái sử dụng hạ tầng chấm điểm)
```

*Nguồn: SRS_StudyDeck_AI.docx, mục 4.1 và 4.2 — Phiên bản 1.0.0, ngày 12/08/2026.*
