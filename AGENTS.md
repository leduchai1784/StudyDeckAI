# Karpathy-Inspired Coding Guidelines & Behavioral Rules

Bộ quy tắc ứng xử và tiêu chuẩn lập trình dành cho AI Coding Assistant khi phát triển dự án **StudyDeck AI**, kế thừa từ các nguyên tắc và quan sát của **Andrej Karpathy** về các cạm bẫy của LLM trong lập trình.

---

## 1. Think Before Coding (Suy nghĩ trước khi viết mã)

> **"Không đoán mò. Không giấu sự mơ hồ. Luôn nêu rõ đánh đổi (tradeoffs)."**

Trước khi chỉnh sửa hay viết code:
- **Nêu rõ giả định (Assumptions)**: Nếu yêu cầu chưa rõ hoặc có điểm không chắc chắn, hãy chủ động hỏi lại người dùng thay vì tự tiện phỏng đoán và làm theo một hướng sai.
- **Trình bày các phương án**: Khi có nhiều cách giải thích hoặc nhiều hướng tiếp cận, hãy liệt kê các giải pháp kèm ưu/nhược điểm (tradeoffs) để người dùng lựa chọn, không âm thầm tự quyết định.
- **Biết phản biện khi cần**: Nếu có cách tiếp cận đơn giản, an toàn hoặc hiệu quả hơn phương án người dùng đề xuất, hãy giải thích và đưa ra gợi ý thay thế.
- **Dừng lại khi thấy bối rối**: Nếu gặp mâu thuẫn trong logic, kiến trúc hoặc mã nguồn, hãy dừng lại, chỉ rõ điểm vướng mắc và xin ý kiến làm rõ.

---

## 2. Simplicity First (Ưu tiên sự đơn giản tối đa)

> **"Viết lượng code tối thiểu để giải quyết vấn đề. Không suy đoán hay vẽ vời tính năng tương lai."**

Chống lại xu hướng over-engineering và tạo các abstraction cồng kềnh:
- **Không tự thêm tính năng**: Chỉ làm đúng những gì được yêu cầu, không tự tạo thêm các tính năng "tiện ích" đi kèm nếu chưa được hỏi.
- **Không trừu tượng hóa cho code dùng một lần**: Không tạo class trừu tượng, wrapper hay helper chỉ cho một đoạn code đơn lẻ.
- **Không tạo cấu hình dư thừa**: Tránh việc thêm các tham số `config`, cờ bật/tắt hoặc tính linh hoạt (flexibility) giả định khi chưa có nhu cầu thực tế.
- **Không bắt lỗi cho các kịch bản bất khả thi**: Giữ luồng xử lý thẳng thắn, tránh lồng ghép quá nhiều lớp try-catch phòng thủ không cần thiết.
- **Quy tắc kiểm tra**: *"Một Senior Engineer nhìn vào đoạn code này có thấy nó bị làm quá phức tạp không?"* Nếu có, hãy viết lại cho tinh gọn và trực diện. Nếu 200 dòng có thể rút gọn thành 50 dòng mà vẫn sạch và rõ ràng, hãy chọn 50 dòng.

---

## 3. Surgical Changes (Can thiệp chuẩn xác như phẫu thuật)

> **"Chỉ chạm vào đúng những gì bắt buộc phải sửa. Dọn dẹp đúng những gì mình tạo ra."**

Khi chỉnh sửa code trong dự án:
- **Can thiệp khu trú**: Chỉ sửa đúng phạm vi hàm/widget/file liên quan trực tiếp đến nhiệm vụ.
- **Không tự tiện "cải tiến" code lân cận**: Không tự ý sửa formatting, đổi tên biến, di chuyển hàm hoặc sửa comment của các phần code xung quanh nếu không thuộc phạm vi yêu cầu.
- **Tôn trọng phong cách hiện có**: Tuân thủ triệt để cấu trúc thư mục, kiến trúc dự án và quy chuẩn thiết kế của StudyDeck AI (`design-system.md`, `THEME_STANDARDS.md`).
- **Xử lý mã thừa (Dead code)**: Nếu phát hiện code thừa ngoài phạm vi đang làm, hãy chỉ ra cho người dùng biết, **không tự ý xóa**.
- **Sau khi hoàn thành**: Dọn sạch các file tạm, log debug hoặc biến thừa do chính mình tạo ra trong quá trình làm việc.

---

## 4. Goal-Driven Execution (Hành động có tiêu chí kiểm chứng)

> **"Định nghĩa tiêu chí thành công rõ ràng. Kiểm chứng từng bước thay vì làm việc cảm tính."**

Biến các yêu cầu mơ hồ thành các mục tiêu có thể xác minh được:
- **Tiêu chuẩn hoàn thành (Definition of Done)**: Luôn xác định rõ ràng: Làm sao để biết tác vụ đã thành công 100%?
- **Quy trình từng bước kèm kiểm chứng**:
  - `[Bước 1: Thực hiện]` $\rightarrow$ `[Kiểm chứng: Chạy lệnh / Test cụ thể]`
  - `[Bước 2: Thực hiện]` $\rightarrow$ `[Kiểm chứng: flutter analyze / Hot reload UI]`
- **Không để lỗi tích tụ**: Không chuyển sang bước kế tiếp nếu bước hiện tại chưa vượt qua bước kiểm chứng.
- **Đảm bảo tính toàn vẹn**: Sau mỗi lần thay đổi mã nguồn, luôn chạy `flutter analyze` để đảm bảo 0 lỗi (0 errors, 0 warnings mới).

---

## 5. Tham Khảo Kỹ Năng & Quy Chuẩn (Skills & Rules)

Toàn bộ tài liệu chi tiết được tổ chức và lưu trữ trực tiếp trong dự án để dễ dàng tra cứu:
- 📖 **Danh mục tổng hợp**: [.agents/README.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/README.md)
- 🎨 **Kỹ năng thiết kế giao diện**: [.agents/skills/frontend-design/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/frontend-design/SKILL.md)
- 🧠 **Kỹ năng tiêu chuẩn Karpathy**: [.agents/skills/karpathy-guidelines/SKILL.md](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/skills/karpathy-guidelines/SKILL.md)
- 📂 **Thư mục quy tắc chi tiết**: [.agents/rules/](file:///c:/BC_TotNghiep/StudyDeckAI/.agents/rules/)
