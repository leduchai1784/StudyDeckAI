# StudyDeck AI — Bảng Chuẩn Màu & Theme Hệ Thống (THEME_STANDARDS.md)

Tài liệu này là **nguồn tham chiếu quy chuẩn giao diện (Single Source of Truth)** bắt buộc tuân thủ cho toàn bộ ứng dụng StudyDeck AI (Flutter Mobile & Web). Mọi thao tác thêm mới hoặc chỉnh sửa giao diện bắt buộc phải bám sát các thông số dưới đây để đảm bảo tính đồng bộ tuyệt đối, không bị lệch chuẩn.

---

## 1. Triết lý Thiết kế: "Form Vuông Tinh Tế" (Modern Boxed Aesthetic)

> [!IMPORTANT]
> **Tuyệt đối không dùng bo góc tròn dạng viên thuốc (Pill shape 20px–30px) cho nút bấm, thanh tìm kiếm hoặc filter chips.** 
> StudyDeck AI sử dụng ngôn ngữ thiết kế phẳng, hiện đại với khối hình học bo góc vuông nhẹ (4px – 8px – 12px).

### Bảng chuẩn Border Radius:

| Loại thành phần | Border Radius | Mã Flutter chuẩn | Ghi chú |
|---|---|---|---|
| **Badges / Nhãn / Tags** | **4px** | `BorderRadius.circular(4)` | Nhãn THI THẬT, Band điểm, Hashtag `#`, Category tag |
| **Nút bấm (Buttons)** | **8px** | `BorderRadius.circular(8)` | Nút `Luyện tập`, `Thi thật`, `ElevatedButton`, `OutlinedButton` |
| **Filter Chips / Tabs** | **8px** | `BorderRadius.circular(8)` | Chip phân loại (`Tất cả`, `IELTS`, `Cambridge 20`, v.v.) |
| **Ô tìm kiếm (Search Bar)**| **8px** | `BorderRadius.circular(8)` | Chiều cao chuẩn 46px, viền `#E2E8F0` |
| **Icon Buttons phụ** | **8px** | `BorderRadius.circular(8)` | Nút bộ lọc phễu góc trên, nút icon điều hướng |
| **Cards / Thẻ nội dung** | **10px – 12px** | `BorderRadius.circular(12)` | Thẻ bài nghe, thẻ đề thi Cambridge, thẻ lộ trình |
| **Bottom Sheet / Modal** | **12px – 16px** | `BorderRadius.vertical(top: Radius.circular(16))` | Bo góc trên đỉnh modal |

---

## 2. Quy chuẩn Nút Quay Lại (Back Button Standard)

- **Widget bắt buộc sử dụng:** `const AppBackButton()` (nằm tại `lib/shared/widgets/app_back_button.dart`).
- **Hình thức:** Borderless (không viền, không nền khối hộp, không bóng), chỉ giữ lại icon góc nhọn mềm mại:
  - Icon: `Icons.chevron_left_rounded`
  - Kích thước icon: `size: 26`
  - Màu sắc: `AppTheme.brandTextPrimary` (`#1E1B4B` hoặc `#0F172A`)
  - Chức năng: Mặc định gọi `Navigator.maybePop(context)`, hỗ trợ truyền `onPressed` khi cần xác nhận thoát.
- **Vị trí chuẩn:** Luôn đặt trong `AppBar.leading` của `AppBar` chuẩn Flutter:
  ```dart
  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0.5,
    leading: const AppBackButton(),
    title: const Text('Tiêu đề màn hình'),
  )
  ```
  *(Không bọc thêm `Padding` hay `SafeArea` tự tạo ngoài AppBar vì sẽ làm lệch toạ độ so với các màn khác).*

---

## 3. Bảng Màu Chuẩn (Color Palette & Tokens)

### 3.1 Màu Thương Hiệu & Hệ Thống (Brand Core)

| Token | Hex | Tên màu | Sử dụng trong UI |
|---|---|---|---|
| `brandPrimary` | `#4F46E5` | Indigo đậm | CTA chính, Tab active, Active State, Icon điểm nhấn |
| `brandPrimaryLight` | `#C7D2FE` | Indigo nhạt | Viền active, nền hover |
| `brandBackground` | `#F8FAFC` / `#F9FAFB` | Slate sáng | Nền toàn bộ màn hình app |
| `brandSurface` | `#FFFFFF` | Trắng tinh khiết | Nền của thẻ Card, AppBar, Bottom Sheet |
| `brandBorder` | `#E2E8F0` | Slate Border | Viền mảnh 1px cho Card, Search bar, Container |
| `brandTextPrimary` | `#1E1B4B` / `#0F172A` | Navy Đậm | Tiêu đề H1/H2, Tên bài học, Text quan trọng |
| `brandTextSecondary` | `#64748B` / `#6B7280` | Slate Grey | Phụ đề, mô tả bài tập, thời lượng, placeholder |
| `brandSuccess` | `#10B981` | Emerald Green | Trạng thái tích cực, đáp án đúng |
| `brandError` | `#EF4444` | Red | Cảnh báo thoát, lỗi, đáp án sai |

### 3.2 Màu Phân Nhóm Thể Loại (Category Pastel Tints)

Khi hiển thị các danh mục bài tập hoặc kỹ năng khác nhau:

| Danh mục | Nền badge (`badgeColor`) | Màu chữ & icon (`badgeTextColor`) |
|---|---|---|
| **IELTS / Cambridge** | `#EEF2FF` | `#4F46E5` |
| **TED-Ed** | `#FEE2E2` | `#DC2626` |
| **BBC 6-Minute** | `#FEF3C7` | `#D97706` |
| **Giao Tiếp / Đời Sống** | `#DCFCE7` | `#16A34A` |
| **Band Target Tag** | `#F1F5F9` | `#475569` |

---

## 4. Cấu Trúc AppBar Tiêu Chuẩn (AppBar Anatomy)

Mọi màn hình danh sách kỹ năng / bài học đều dùng chung mẫu AppBar:

```dart
appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0.5,
  leading: const AppBackButton(),
  centerTitle: false, // Hoặc true tuỳ thuộc màn hình
  title: const Text(
    'Tên Màn Hình',
    style: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: AppTheme.brandTextPrimary,
    ),
  ),
  actions: [
    // Nút action phụ (Filter hoặc Badge đếm bài)
  ],
)
```

---

## 5. Cấu Trúc Thẻ Bài Tập Tiêu Chuẩn (Card Anatomy)

Mỗi thẻ bài học / đề thi trong danh sách bao gồm:

```
+---------------------------------------------------------------+
| [Category: 4px]  [Band: 4px]            🕒 6 câu • ~7p (12px) |
|                                                               |
| Tên Bài Học Nổi Bật (Bold 15px - #0F172A)                     |
|                                                               |
| [# Chủ đề: 4px]                          [ ▶ Luyện tập : 8px] |
+---------------------------------------------------------------+
```

- **Container:** Nền trắng, viền `#E2E8F0` 1px, bo góc `12px`, padding `14px`.
- **Top Row:** Nhãn danh mục (bo 4px) + Nhãn Band (bo 4px) + Thời lượng bên phải (`#64748B`).
- **Middle Row:** Tiêu đề bài học font đậm, kích thước 15–16px.
- **Bottom Row:** Hashtag chủ đề bo 4px (chữ xám, dấu `#` màu tím) + Nút CTA bo 8px.

---

## 7. Kiến Trúc Phân Cấp Cho Các Kỹ Năng Cambridge (Cambridge Hub Hierarchy)

Áp dụng bắt buộc cho các màn hình Hub kỹ năng luyện thi Cambridge (Reading, Listening...):

1. **Màn hình ngoài (Outer Hub Screen):**
   - **Tuyệt đối không** hiển thị danh sách phẳng (flat list) toàn bộ hàng chục bài test đơn lẻ cùng lúc.
   - **Chỉ hiển thị các Thẻ Bộ Sách Cambridge (Volume Cards):** Khối vuông CAM bo 8–10px mang màu sắc nhận diện từng tập (`_getVolumeColor`), tên tập (`Cambridge IELTS 15`), số lượng test (`4 đề thi Academic • 160 câu hỏi`), huy hiệu trạng thái (`MỚI NHẤT` / `CHÍNH THỨC`), và tiến độ làm bài (`Đã làm X/Y đề`).
2. **Màn hình trong (Inner Tests Screen):**
   - Nhấn vào bộ sách nào mới điều hướng vào màn hình danh sách test (`Cambridge...TestsListScreen`) của cuốn đó.
   - Hiển thị banner tổng quan cuốn sách, danh sách chi tiết các bài test (Test 1..4), phần thi con (Passages/Sections), và nút bấm hành động `Làm bài ngay` / `Làm lại`.
3. **Cơ chế tìm kiếm tức thì (Search Fallback):**
   - Khi thanh tìm kiếm có ký tự, màn hình ngoài tự động chuyển sang hiển thị danh sách các bài test con phù hợp để người dùng truy cập nhanh.

---

## 8. Nguyên Tắc Giảm Tải Nhận Thức (Cognitive Load Minimization)

Áp dụng cho mọi màn hình kỹ năng luyện thi (Speaking, Writing, Reading, Listening):
- **Không nhồi nhét văn bản:** Loại bỏ các đoạn giới thiệu dài nhiều dòng ở header banner; thay bằng 1 câu ngắn gọn hoặc các chỉ số định lượng súc tích.
- **Phân cấp màu sắc tinh gọn:** Không đặt quá 3 badge màu pastel khác nhau trong cùng một thẻ bài tập.
- **Trọng tâm hành động:** Mỗi màn hình chỉ có duy nhất 1 nút hành động chính (Primary CTA) nổi bật nhất, các nút còn lại dùng dạng Outlined hoặc icon phụ.

---

## 9. Danh Sách Kiểm Tra Trước Khi Hoàn Tất Chỉnh Sửa (Checklist)

- [ ] Nút quay lại đã dùng `AppBackButton()` và nằm đúng vị trí trong `AppBar.leading` chưa?
- [ ] Không có nút bấm hay filter chip nào bị bo góc viên thuốc `20px+` chưa?
- [ ] Tất cả nút bấm và chip đã dùng `BorderRadius.circular(8)` chưa?
- [ ] Tất cả badge nhỏ đã dùng `BorderRadius.circular(4)` chưa?
- [ ] Module luyện đề Cambridge đã áp dụng kiến trúc phân cấp (ngoài hiện bộ sách, ấn vào mới hiện test) chưa?
- [ ] Giao diện đã được tinh gọn, chống quá tải thị giác & chữ nghĩa thừa thãi chưa?
- [ ] Màu sắc sử dụng có nằm trong bảng token ở mục 3 không?
- [ ] Chạy lệnh `dart analyze` đảm bảo 0 lỗi syntax / lint?
