# StudyDeck AI — Danh Mục Skills & Rules (Hướng Dẫn & Tra Cứu)

Thư mục này lưu trữ toàn bộ các **Skills** (Kỹ năng chuyên môn mở rộng) và **Rules** (Quy tắc lập trình & ứng xử) được tích hợp trực tiếp vào dự án **StudyDeck AI**.

---

## 🎯 1. Skills (Kỹ Năng Chuyên Môn)

Tất cả các skill được đặt tại [.agents/skills/](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/) và được AI tự động nhận diện theo cơ chế progressive disclosure.

### 🌟 Kỹ Năng Cốt Lõi Dự Án (Project-Scoped Skills)
Nằm tại [.agents/skills/](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/):

| Skill | Đường dẫn | Tóm tắt mục tiêu |
| :--- | :--- | :--- |
| **Karpathy Guidelines** | [karpathy-guidelines/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/karpathy-guidelines/SKILL.md) | 4 nguyên tắc vàng của Andrej Karpathy: Suy nghĩ trước khi code, Tinh gọn tối đa, Can thiệp chuẩn xác, Thực thi có kiểm chứng. |
| **Frontend Design** | [frontend-design/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/frontend-design/SKILL.md) | Thiết kế giao diện độc bản mang cá tính cao, chống rập khuôn AI, trau chuốt typography, motion và microcopy. |
| **Ponytail** | [ponytail/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/ponytail/SKILL.md) | Triết lý Lazy Senior Dev: Viết lượng code tối thiểu, ưu tiên code có sẵn/stdlib, can thiệp chuẩn xác, giải thích ngắn gọn. |
| **Ponytail Review** | [ponytail-review/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/ponytail-review/SKILL.md) | Review chất lượng: kiểm tra tính đúng đắn, an toàn, hiệu năng, kiểm thử vùng rủi ro, loại bỏ dòng thừa. |
| **Ponytail Audit** | [ponytail-audit/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/ponytail-audit/SKILL.md) | Rà soát toàn diện repo: bắt lỗi, lỗ hổng bảo mật, tải thực tế, code thiếu test, đề xuất xóa hoặc gộp code. |
| **Ponytail Debt** | [ponytail-debt/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/ponytail-debt/SKILL.md) | Sổ cái nợ kỹ thuật: liệt kê các comment `shortcut:` để theo dõi việc trì hoãn nâng cấp code. |
| **Ponytail Gain** | [ponytail-gain/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/ponytail-gain/SKILL.md) | Báo cáo định lượng hiệu quả tinh gọn (-53% code, -41% thời gian, -45% token). |
| **Ponytail Help** | [ponytail-help/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/ponytail-help/SKILL.md) | Hướng dẫn nhanh về các cấp độ (lite, full, ultra) và lệnh của Ponytail. |

*(Lưu ý: 34 Han skills lập trình/kế hoạch cũ đã được di chuyển an toàn vào thư mục sao lưu `[.agents/skills_backup/](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills_backup/)` để giải phóng context window).*

### 🎭 Hệ Thống Agency Agents Mở Rộng (268 Global Agents)
Cài đặt tại cấu hình toàn cục `C:\Users\lehai\.gemini\config\skills/` từ kho [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents), tự động nhận diện và sẵn sàng kích hoạt trong StudyDeck AI qua cú pháp `agency-<slug>`:

| Phân ngành tiêu biểu | Agent đại diện | Cú pháp gọi gợi ý | Tóm tắt năng lực |
| :--- | :--- | :--- | :--- |
| **Mobile & Cross-Platform** | Mobile App Builder | `agency-mobile-app-builder` | Chuyên gia Flutter, iOS, Android, tối ưu hiệu năng và UX native. |
| **UI/UX Design** | UI Designer | `agency-ui-designer` | Thiết kế giao diện, component libraries, typography và design systems. |
| **Frontend Architecture** | Frontend Developer | `agency-frontend-developer` | Xây dựng UI chuẩn pixel-perfect, tối ưu render pipeline. |
| **Code Review & Audit** | Code Reviewer | `agency-code-reviewer` | Review mã nguồn chuyên sâu, bảo mật và kiến trúc sạch. |
| **Database Tuning** | Database Optimizer | `agency-database-optimizer` | Tối ưu schema, truy vấn Supabase/PostgreSQL và chiến lược indexing. |
| **Voice AI & Dictation** | Voice AI Integration | `agency-voice-ai-integration-engineer` | Tích hợp xử lý âm thanh, speech-to-text, luyện nghe & chính tả. |
| **Testing Automation** | Test Automation | `agency-test-automation-engineer` | Thiết kế kịch bản test tự động, unit test & integration test. |
| **Minimal Scope Diff** | Minimal Change Engineer | `agency-minimal-change-engineer` | Can thiệp tối thiểu chuẩn phẫu thuật, ngăn ngừa scope creep. |

*(Toàn bộ 268 agents thuộc 18 phân ban: engineering, design, testing, marketing, sales, product, specialized... đã sẵn sàng sử dụng).*

---

## 📋 2. Rules (Bộ Quy Chuẩn Lập Trình & Ứng Xử)

Nằm trong [.agents/rules/](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/):

| Tên quy tắc | File | Nội dung chính |
| :--- | :--- | :--- |
| **Ponytail Rule** | [ponytail.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/ponytail.md) | Triết lý Lazy Senior Dev: code tốt nhất là code không cần viết, thay 50 dòng bằng 1 dòng, hoàn thành phần việc mà không thêm tính năng thừa. |
| **Karpathy Rules** | [karpathy-guidelines.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/karpathy-guidelines.md) | Chi tiết 4 nguyên tắc vàng bằng tiếng Việt, phân tích tradeoffs và kiểm chứng `flutter analyze`. |
| **Agentic Coding** | [agentic-coding.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/agentic-coding.mdc) | Tự chủ an toàn, tiến hành theo các bước tăng dần (incremental), luôn dọn dẹp file tạm và log debug. |
| **Code Quality** | [code-quality.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/code-quality.mdc) | Chống over-engineering, không tạo abstraction đơn lẻ cho code dùng một lần, chỉ validate dữ liệu ở ranh giới hệ thống. |
| **Core Behavior** | [core-behavior.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/core-behavior.mdc) | Điều tra và đọc kỹ mã nguồn trước khi trả lời, ưu tiên bắt tay hành động thay vì chỉ giải thích lý thuyết. |
| **Thinking & Reasoning** | [thinking-reasoning.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/thinking-reasoning.mdc) | Cân đối mức độ suy nghĩ theo độ phức tạp của bài toán, tự phản biện kiểm chứng giả định trước khi sửa code. |
| **Tool Usage** | [tool-usage.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/tool-usage.mdc) | Tối ưu hóa việc gọi công cụ, thực thi đồng thời khi các bước độc lập, tránh các thao tác thừa thãi. |
| **Language Rules** | [language-rules.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/language-rules.mdc) | Sử dụng 100% tiếng Việt tự nhiên trong phản hồi và giải thích; giữ nguyên tiếng Anh cho tên hàm, biến, class và comment mã nguồn. |
| **Project Rules** | [project-rules.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/project-rules.mdc) | Tuân thủ cấu trúc thư mục, quy ước kiến trúc và tài liệu thiết kế nội bộ (`design-system.md`, `THEME_STANDARDS.md`). |
| **Output Format** | [output-format.mdc](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/output-format.mdc) | Định dạng markdown rõ ràng, sử dụng link file clickable, trực quan hóa tiến độ bằng bảng hoặc checklist. |
| **AI Log Hook** | [ai-log-hook.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/ai-log-hook.md) | Cơ chế auto-logging transcript của AI; không chạy script log thủ công hay can thiệp vào thư mục `.ai-log/`. |

---

## 📖 3. Cấu Hình Toàn Cục & Sao Lưu (Global Configuration)

Toàn bộ các kỹ năng mở rộng (268 Agency Agents + 34 Han skills cũ) cùng tài liệu tham chiếu đã được chuyển an toàn sang thư mục cấu hình toàn cục của Antigravity:
- **Kỹ năng toàn cục**: `C:\Users\lehai\.gemini\config\skills/`
- **Tài liệu tham chiếu toàn cục**: `C:\Users\lehai\.gemini\config\references/`

Cơ chế này giúp giữ cho thư mục `.agents/` của dự án cực kỳ tinh gọn, tránh gây phình Git repository đồ án tốt nghiệp và tối ưu 100% Context Budget cho AI khi lập trình.
