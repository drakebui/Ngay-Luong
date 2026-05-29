# 03 — Data Models

> Code Dart đã viết sẵn cho 2 model lõi:
> - `lib/features/income/domain/income_profile.dart`
> - `lib/features/crush/domain/crush_models.dart`
>
> File này mô tả ngữ nghĩa từng field để agent hiểu và build repository/UI quanh chúng.
> KHÔNG đổi tên field/enum đã chốt mà không cập nhật cả 3 nơi: code + doc này + UI.

---

## 1. IncomeProfile

Đại diện cách người dùng khai báo thu nhập. Lưu trong **secure storage** (JSON), KHÔNG vào DB thường.

| Field | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|---|---|
| `mode` | `IncomeMode` | ✅ | monthly / daily / hourly / project |
| `monthlyNetIncome` | `double?` | mode=monthly | Thu nhập net/tháng (VND) |
| `dailyIncome` | `double?` | mode=daily | Thu nhập/ngày (VND) |
| `hourlyIncome` | `double?` | mode=hourly | Thu nhập/giờ (VND) |
| `projectIncome` | `double?` | mode=project | Thu nhập dự án (VND) |
| `projectTotalHours` | `double?` | project (1 trong 2) | Tổng giờ làm dự án |
| `projectTotalDays` | `double?` | project (1 trong 2) | Tổng ngày làm dự án |
| `workDaysPerMonth` | `int` | mặc định 22 | Số ngày làm/tháng (dùng derive lương ngày & % tháng) |
| `workHoursPerDay` | `double` | mặc định 8 | Số giờ làm/ngày (dùng derive lương giờ) |
| `currency` | `String` | mặc định "VND" | Để mở rộng sau |
| `updatedAt` | `DateTime` | ✅ | Lần cập nhật gần nhất |

**Giá trị mặc định khi user không nhập:** `workDaysPerMonth = 22`, `workHoursPerDay = 8`. Tài liệu hóa rõ trong UI ("mặc định 22 ngày/8 giờ, có thể đổi").

`IncomeMode`:
```
enum IncomeMode { monthly, daily, hourly, project }
```

### Giá trị dẫn xuất (do WageCalculator tính, KHÔNG lưu)
- `dailyWage` — lương 1 ngày. Luôn tính được ở cả 4 mode.
- `hourlyWage` — lương 1 giờ. Tính được nếu biết số giờ.
- `monthlyIncomeEstimate` — để tính % thu nhập tháng (có thể dùng default 22 ngày nếu mode không cho trực tiếp).

Xem công thức đầy đủ ở `04_CALCULATIONS.md`.

---

## 2. CheckResult

Kết quả của một lần Quick Check. Là object tạm (không nhất thiết lưu DB nếu user không lưu card).

| Field | Kiểu | Ý nghĩa |
|---|---|---|
| `price` | `double` | Giá nhập vào (VND) |
| `daysOfWage` | `double` | Số ngày đi làm (hero) |
| `hoursOfWork` | `double` | Số giờ làm |
| `pctOfMonthlyIncome` | `double?` | % thu nhập tháng (null nếu không ước tính được) |
| `costPerUse` | `double?` | Chỉ có khi user nhập số lần dùng (Phase 3) |

---

## 3. CrushCard

Một món đang được cân nhắc. Lưu trong **Drift (SQLite)**. Ảnh lưu file local, DB chỉ giữ `imagePath`.

| Field | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|---|---|
| `id` | `String` (uuid) | ✅ | Khóa chính |
| `name` | `String?` | optional | Tên món |
| `price` | `double` | ✅ | Giá (VND) |
| `category` | `String?` | optional | Phân loại tự do hoặc preset |
| `imagePath` | `String?` | optional | Đường dẫn file ảnh local đã nén |
| `daysOfWageSnapshot` | `double` | ✅ | **Snapshot** số ngày lương lúc tạo (vì thu nhập có thể đổi) |
| `hoursOfWorkSnapshot` | `double` | ✅ | Snapshot giờ làm lúc tạo |
| `pctOfMonthlyIncomeSnapshot` | `double?` | optional | Snapshot % tháng lúc tạo |
| `reason` | `CrushReason?` | optional | Lý do muốn mua (FOMO check) |
| `mood` | `String?` | optional | Mood lúc muốn mua (tự do, Phase 2) |
| `note` | `String?` | optional | Ghi chú |
| `status` | `CrushStatus` | ✅ | Trạng thái hiện tại |
| `createdAt` | `DateTime` | ✅ | Ngày tạo |
| `updatedAt` | `DateTime` | ✅ | Cập nhật gần nhất |
| `remindAt` | `DateTime?` | optional | Mốc nhắc tiếp theo |
| `remindCount` | `int` | mặc định 0 | Số lần đã nhắc (để chống nhắc vô hạn) |

> **Vì sao snapshot?** Người dùng có thể đổi thu nhập sau này. Con số "ngày lương" gắn với cảm xúc tại thời điểm muốn mua, nên lưu snapshot. Có thể cho tính lại theo thu nhập hiện tại như một tùy chọn phụ, nhưng mặc định hiển thị snapshot.

### Enums

```
enum CrushReason {
  reallyNeed,       // Cần thật
  onSale,           // Đang sale
  sawReview,        // Thấy review
  tiktokMadeMeWeak, // TikTok làm tôi yếu lòng
  treatMyself,      // Tự thưởng
  stress,           // Stress
  justLikeIt,       // Không biết nữa, thấy thích
}

enum CrushStatus {
  crushing,         // Đang mê
  sleepOnIt,        // Để mai tính
  stillCrushing,    // Vẫn mê
  overIt,           // Hết mê
  waitingForSale,   // Chờ sale
  bought,           // Đã mua
  skipped,          // Đã bỏ qua
}
```

`label` (tiếng Việt) cho mỗi enum value lấy từ `07_COPY_VI.md`, gắn qua extension trong `crush_models.dart`.

### Trạng thái nào tính vào Anti-haul
- `overIt` và `skipped` → cộng `daysOfWageSnapshot` vào tổng "ngày lương không bay màu".
- `bought` → KHÔNG tính.
- `waitingForSale`, `crushing`, `sleepOnIt`, `stillCrushing` → đang treo, chưa tính.

---

## 4. ReminderPreset (lựa chọn mốc nhắc)

Không cần lưu DB; là enum giúp tính `remindAt`.

```
enum ReminderPreset {
  tonight,     // Tối nay (20:00 hôm nay, hoặc +2h nếu đã qua 20:00)
  after24h,    // +24 giờ
  after3Days,  // +3 ngày
  after7Days,  // +7 ngày
  untilPayday, // Tới ngày lương kế tiếp (dùng paydayDay trong settings, mặc định ngày 5)
  custom,      // User tự chọn ngày/giờ
}
```

Logic tính `remindAt` từ preset: xem `08_DATA_PERSISTENCE.md` §Reminder.

---

## 5. Settings (shared_preferences)

| Key | Kiểu | Mặc định | Ý nghĩa |
|---|---|---|---|
| `onboarding_done` | bool | false | Đã setup thu nhập chưa |
| `app_lock_enabled` | bool | false | Bật Face ID/vân tay |
| `noti_detail_mode` | bool | false | Cho phép noti hiện tên/giá/ngày lương (mặc định tắt = private) |
| `mascot_enabled` | bool | true | Bật mascot ví (Phase 2) |
| `payday_day` | int | 5 | Ngày lương trong tháng (cho untilPayday & Salary Day Mode) |
| `theme_mode` | string | "system" | light / dark / system |

Lưu ý: KHÔNG để bất kỳ field thu nhập nào trong shared_preferences.
