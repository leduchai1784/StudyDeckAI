# StudyDeck AI — Design System

Tài liệu chuẩn giao diện (UI Design System) dùng làm nguồn tham chiếu duy nhất cho toàn bộ màn hình Mobile + Web. Mọi màn hình mới hoặc chỉnh sửa đều phải tuân theo các quy tắc dưới đây — không tự ý thêm màu/bo góc/font ngoài danh sách này.

---

## 1. Bảng màu (Color Palette)

### 1.1 Màu gốc thương hiệu

| Token | Hex | Vai trò |
|---|---|---|
| `primary` | `#4F46E5` | Indigo — nút CTA chính, thẻ nổi bật, icon active, thanh điều hướng active |
| `primary-light` | `#C7D2FE` | Nền avatar, hover state, tint nhạt của primary |
| `accent` | `#F59E0B` | Amber — streak, nhắc nhở/urgency, huy hiệu AI |
| `accent-light` | `#FAEEDA` | Nền pill/badge amber, nền icon-chip nhắc nhở |
| `success` | `#10B981` | Đáp án đúng, hoàn thành, trạng thái tích cực |
| `error` | `#EF4444` | Đáp án sai, cảnh báo, nút "Again" |
| `text-primary` | `#1E1B4B` | Văn bản chính, tiêu đề |
| `text-secondary` | `#6B7280` | Mô tả phụ, placeholder |
| `text-muted` | `#9AA0AE` | Caption, timestamp, icon inactive |
| `background` | `#F9FAFB` | Nền màn hình mặc định (bên trong khung app) |
| `surface` | `#FFFFFF` | Nền card, nút outline |
| `border` | `#E2E2EA` | Viền card 1px mặc định |

### 1.2 Bộ màu pastel cho nhóm nội dung (Skill / Category tint)

Dùng khi cần phân biệt nhiều mục cùng cấp (vd 4 kỹ năng, nhóm tính năng AI) **mà không được lệch khỏi họ màu thương hiệu**. Mỗi tint gồm: nền nhạt + icon/chữ đậm cùng tông.

| Nhóm | Nền nhạt | Icon/chữ đậm | Dùng cho |
|---|---|---|---|
| Indigo | `#EAF2FE` | `#2563EB` | Listening, AI Tutor, thông tin trung tính |
| Green | `#E9F7EF` | `#0F9D58` | Reading, trạng thái tích cực nhẹ |
| Amber | `#FDF1DD` / `#FAEEDA` | `#B45309` | Speaking, Flashcard/nhắc nhở, RAG |
| Purple | `#F3EAFB` | `#7C3AED` | Writing |
| Indigo đậm (chip) | `#EEEDFE` | `#4F46E5` | Icon-chip Flashcard, mục lộ trình AI |

**Nguyên tắc:** tối đa **4 tint** xuất hiện cùng lúc trên 1 màn hình. Không dùng màu bão hòa 100% (hồng đậm, cam cháy, xanh dương gắt...) làm nền mảng lớn — chỉ dùng làm icon/chữ nhấn trên nền nhạt.

### 1.3 Cấm dùng

❌ Không dùng màu nâu, đỏ gạch, hoặc bất kỳ hex nào ngoài bảng trên cho nút bấm/CTA.
❌ Không dùng 2 sắc thái khác nhau của cùng "primary" trong cùng 1 màn (vd vừa `#4F46E5` vừa `#4C2FBF`) — chỉ 1 giá trị hex chính xác cho mỗi token.

---

## 2. Typography

**Font:** Be Vietnam Pro (Google Fonts) — font duy nhất toàn app, hỗ trợ đầy đủ dấu tiếng Việt.

| Cấp | Weight | Size (mobile) | Dùng cho |
|---|---|---|---|
| H1 | Bold (700) | 16–18px | Tiêu đề màn hình, tên module |
| H2 | Bold (700) | 13–14px | Tiêu đề section trong màn hình |
| Body semibold | SemiBold (600) | 10–11px | Tên item (deck, bài học...), label nút |
| Body regular | Regular (400) | 9–10px | Mô tả, nội dung phụ |
| Caption | Regular (400) | 7–8px | Timestamp, badge nhỏ, chú thích |

Không dùng quá 4 cấp cỡ chữ trong cùng 1 màn hình.

---

## 3. Bo góc (Border Radius) — chuẩn "vuông"

Hệ số bo góc cố định theo cấp, **không tự do chọn số** ngoài bảng:

| Token | Giá trị | Dùng cho |
|---|---|---|
| `radius-xs` | 6px | Badge nhỏ, tag |
| `radius-sm` | 8–9px | Nút bấm, icon-chip nhỏ |
| `radius-md` | 10–12px | Card nội dung, icon-chip lớn |
| `radius-lg` | 14px | Card nổi bật (CTA card, thẻ pastel) |
| `radius-xl` | 18–22px | Khung ngoài cùng (phone mockup/modal lớn) |
| `radius-full` | 999px | Pill/badge tròn hoàn toàn (streak, status) |

---

## 4. Khoảng cách (Spacing) — lưới 4px

Mọi padding/margin/gap phải là bội số của **4px**: `4, 8, 12, 16, 20, 24, 32`.

- Padding trong card: `10–14px`
- Khoảng cách giữa 2 section: `16–20px`
- Gap giữa các item trong lưới (grid 2 cột): `6–8px`
- Padding màn hình ngoài cùng: `12–16px`

---

## 5. Đổ bóng (Elevation)

**Nguyên tắc: Flat design — hạn chế tối đa shadow.**

- Card mặc định: viền `1px solid border` (`#E2E2EA`), **không** đổ bóng (box-shadow).
- Chỉ dùng shadow rất nhẹ (`0 1px 3px rgba(0,0,0,.04)`) cho phần tử nổi trên cùng (vd nút FAB, bottom sheet) — không dùng cho card thường.
- Không dùng shadow đậm/lan rộng (tránh cảm giác "nặng", lỗi thời).

---

## 6. Icon

- Bộ icon: **Tabler Icons** (outline, nét đều, bo tròn nhẹ) — không trộn nhiều bộ icon khác nhau.
- Kích thước chuẩn: `14px` (icon trong hàng danh sách), `16–18px` (icon trong card/nav), `24–26px` (icon-chip lớn).
- Màu icon luôn khớp token màu của ngữ cảnh (icon trong card pastel Indigo → màu `#2563EB`, không dùng đen/xám mặc định).

---

## 7. Thành phần chuẩn (Components)

### 7.1 Nút bấm (Button)

| Loại | Nền | Chữ | Dùng khi |
|---|---|---|---|
| Primary | `primary` (#4F46E5) | Trắng, SemiBold | Hành động chính duy nhất trên màn hình |
| Secondary/Outline | Trắng, viền `primary` | `primary`, SemiBold | Hành động phụ |
| Text link | Trong suốt | `primary`, SemiBold | Hành động ít quan trọng nhất (vd "Đăng nhập" khi CTA chính là "Đăng ký") |
| Danger outline | Trắng, viền đỏ nhạt | `error`, SemiBold | Đăng xuất, xóa |

**Quy tắc:** mỗi màn hình chỉ có **1 nút Primary** — nếu có nhiều hành động, các nút còn lại phải là Secondary/Text link.

### 7.2 Thẻ (Card)

- **Card trắng mặc định:** nền `surface`, viền `border` 1px, `radius-md`/`radius-lg`, không shadow.
- **Card nổi bật (CTA/Hero):** nền `primary` full màu, chữ trắng — chỉ dùng **1 card loại này mỗi màn hình** (vd "Mục tiêu hôm nay").
- **Card pastel (phân loại):** nền tint nhạt (mục 1.2), icon trắng đặt trong ô nhỏ nổi trên nền tint.

### 7.3 Badge / Pill

- Badge trạng thái: nền tint nhạt tương ứng, chữ đậm cùng tông, `radius-full` hoặc `radius-xs`.
- Không dùng nền đặc (solid) bão hòa cho badge đặt chồng lên card đã có màu — badge nên đặt trên nền trắng/tint nhạt hơn card nền để không cạnh tranh thị giác.

### 7.4 Progress bar

- Track: trắng 20–25% opacity (nếu nền màu) hoặc `#EDEDF2` (nếu nền trắng).
- Fill: trắng (nếu nền `primary`) hoặc `primary` (nếu nền trắng).
- Bo góc `radius-xs`, chiều cao 4–6px.

### 7.5 Thanh điều hướng dưới (Bottom Navigation)

- 5 tab cố định: `Trang chủ · Bài học · AI Tutor · Bộ thẻ · Hồ sơ`.
- Icon inactive: `text-muted` (#9AA0AE), icon active: `primary`, có filled-icon variant cho tab active.
- Label 7–8px, hiển thị dưới mọi icon (không ẩn label).

---

## 8. Nguyên tắc tổng quát (Do's & Don'ts)

✅ Tối đa 4 màu tint xuất hiện đồng thời trên 1 màn hình.
✅ Mỗi màn hình chỉ có 1 CTA Primary — các hành động khác giảm cấp bậc thị giác.
✅ Card đồng nhất bo góc theo đúng 1 cấp trong bảng mục 3, không tự chọn số lẻ.
✅ Badge/thông tin phụ luôn nhỏ và nhạt hơn nội dung chính của card.

❌ Không phối màu ngẫu nhiên ngoài bảng token (đặc biệt tránh nâu, đỏ gạch, cam cháy).
❌ Không dùng nhiều shadow/viền chồng lớp gây rối mắt.
❌ Không tạo 2 "loại điểm số/trình độ" cùng ý nghĩa trên 1 màn hình (vd vừa "Level" game vừa "Band điểm" thật) — chỉ giữ 1 thước đo năng lực thống nhất.

---

*Phiên bản 1.0 — tổng hợp từ các quyết định thiết kế đã thống nhất trong quá trình làm SRS và mockup StudyDeck AI.*
