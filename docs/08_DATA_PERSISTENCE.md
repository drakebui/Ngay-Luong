# 08 — Data Persistence

3 lớp lưu trữ, tách theo độ nhạy cảm:

| Lớp | Công nghệ | Lưu gì | Lý do |
|---|---|---|---|
| Secure storage | `flutter_secure_storage` | IncomeProfile (JSON), app-lock secret | Thu nhập nhạy cảm → Keychain/Keystore |
| DB quan hệ | Drift (SQLite) | CrushCard | Cần query theo ngày/trạng thái |
| File system | path_provider + image_compress | Ảnh món đồ (đã nén) | Ảnh không nên vào DB; chỉ lưu path |
| Settings nhẹ | shared_preferences | flags, toggles, payday_day, theme | Không nhạy cảm |

---

## 1. Secure storage — IncomeStorage

```
key "income_profile" -> IncomeProfile.toJson() (string)
key "app_lock_secret" -> (chỉ cần flag, dùng local_auth là chính)
```
- Đọc: parse JSON → IncomeProfile. Lỗi parse → coi như chưa setup.
- Ghi đè khi user sửa thu nhập. KHÔNG bao giờ log giá trị.

---

## 2. Drift — bảng `crush_cards`

| Cột | Kiểu Drift | Note |
|---|---|---|
| id | text (PK) | uuid |
| name | text nullable | |
| price | real | |
| category | text nullable | |
| image_path | text nullable | |
| days_of_wage_snapshot | real | |
| hours_of_work_snapshot | real | |
| pct_of_monthly_income_snapshot | real nullable | |
| reason | text nullable | lưu enum.name |
| mood | text nullable | |
| note | text nullable | |
| status | text | lưu enum.name |
| created_at | datetime | |
| updated_at | datetime | |
| remind_at | datetime nullable | |
| remind_count | integer | default 0 |

Index gợi ý: `remind_at`, `status` (cho Calendar query).

### Query cần có trong CrushRepository
- `watchAll()` — stream toàn bộ (cho Riverpod).
- `watchPending()` — status.isPending.
- `watchRemindToday()` — remind_at trong [đầu ngày, cuối ngày] hôm nay.
- `watchUpcoming()` — remind_at > giờ hiện tại, nhóm theo ngày.
- `watchByMonth(year, month)` — cho Month view (chỉ trả ngày có món, không cần chi tiết).
- `sumSavedDays()` — tổng days_of_wage_snapshot của status countsAsSaved (anti-haul).
- CRUD: `insert`, `update`, `delete` (kèm xóa file ảnh + hủy noti).

---

## 3. Ảnh

- Khi user chọn/chụp: nén bằng `flutter_image_compress` (quality ~70, max chiều dài ~1280px), lưu vào `getApplicationDocumentsDirectory()/crush_images/<uuid>.jpg`.
- DB chỉ lưu đường dẫn tương đối/tuyệt đối (chốt: tuyệt đối, vì sandbox app ổn định trên 1 thiết bị; MVP chưa sync).
- Xóa card → xóa file ảnh tương ứng.
- "Xóa toàn bộ dữ liệu" → xóa cả thư mục `crush_images`.

---

## 4. Reminder / Notification

### Tính `remindAt` từ `ReminderPreset` (giờ địa phương, dùng `timezone`)
```
tonight     -> hôm nay 20:00; nếu đã qua 20:00 thì now + 2h
after24h    -> now + 24h
after3Days  -> now + 3 ngày (giữ nguyên giờ, hoặc set 20:00)
after7Days  -> now + 7 ngày
untilPayday -> ngày `payday_day` của tháng kế tiếp gần nhất (>= ngày mai), 20:00
custom      -> user chọn date/time
```
Khuyến nghị: với các mốc theo ngày, đặt giờ nhắc mặc định **20:00** (giờ rảnh, dễ mở app).

### Lên lịch
- Dùng `flutter_local_notifications.zonedSchedule`, id = hash ổn định từ card.id.
- Khi đổi `remindAt` hoặc trạng thái rời pending → **hủy** notification cũ trước khi đặt mới.
- Payload notification = card.id → tap mở `/crush/:id/still`.

### Nội dung (privacy)
- Mặc định: title=`noti.defaultTitle`, body=`noti.defaultBody` (không tên/giá/ảnh/ngày lương).
- Nếu `noti_detail_mode = true`: dùng `noti.detailNamed` / `noti.detailDays`.

### Quyền
- iOS: xin quyền notification + (nếu cần) đặt category. Android 13+: xin `POST_NOTIFICATIONS`.
- Nếu user từ chối → vẫn lưu card, hiển thị nhắc trong app (Today view), không crash.

---

## 5. Migration & reset

- Drift schema version bắt đầu = 1. Mỗi lần đổi cột → tăng version + viết migration.
- "Xóa toàn bộ dữ liệu": xóa bảng crush_cards, xóa secure storage keys, xóa shared_preferences (trừ theme nếu muốn giữ), xóa thư mục ảnh, hủy mọi notification đã lên lịch.
