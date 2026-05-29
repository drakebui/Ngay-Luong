# 09 — Build Plan

Lộ trình theo milestone. Agent làm **tuần tự**, mỗi task xong phải đạt "Definition of Done" (xem `AGENTS.md` §6). Đừng nhảy cóc sang Phase sau khi MVP chưa chạy được end-to-end.

---

## M0 — Project setup (nửa ngày)

- [ ] `flutter create` với org/bundle id phù hợp; min SDK iOS 13 / Android 24.
- [ ] Thêm dependencies theo `pubspec.yaml`; `flutter pub get`.
- [ ] Cấu hình lint, analysis_options.yaml (strict).
- [ ] Tạo cây thư mục theo `02_ARCHITECTURE.md`.
- [ ] Copy sẵn 3 file lõi đã có: `wage_calculator.dart`, `income_profile.dart`, `crush_models.dart`.
- [ ] Setup `app.dart` với MaterialApp.router (go_router rỗng), localization `vi`.
- [ ] **DoD:** app chạy ra màn trống, analyze sạch.

## M1 — Calculation engine + tests (nửa ngày)

- [ ] Viết unit test cho `WageCalculator` phủ hết ví dụ A–E và edge cases trong `04_CALCULATIONS.md`.
- [ ] Tạo `core/utils/formatters.dart` (format ngày/giờ/%/tiền vi_VN theo §3 của `04`).
- [ ] Test formatters.
- [ ] **DoD:** `flutter test` xanh, mọi vector khớp.

## M2 — Income onboarding + storage (1 ngày)

- [ ] `IncomeStorage` (secure storage) + `IncomeRepository` + `incomeProfileProvider`.
- [ ] Màn S0 Onboarding (4 mode), validate `isUsable`, privacy banner.
- [ ] Lưu profile → set `onboarding_done`.
- [ ] **DoD:** nhập thu nhập, đóng app mở lại vẫn còn; analyze sạch.

## M3 — Quick Check + Result (1 ngày) ← lõi hook

- [ ] Màn S1 Home (price input + Check).
- [ ] Màn S2 Result: hero ngày lương + sub-metrics + microcopy (`result_phrasing.dart`).
- [ ] DecisionRow (4 nút) — tại đây mới chỉ Mua/Bỏ qua hiện microcopy; "Để mai tính"/"Lưu" nối ở M4.
- [ ] Xử lý chưa-onboarding (mở S0).
- [ ] **DoD:** nhập giá → thấy "X ngày đi làm" đúng số; demo được hook.

> 🎯 Mốc này là thời điểm tốt để dựng **web calculator landing** riêng (ngoài app) nếu muốn validate hook trước — nhưng đó là việc tách biệt, không nằm trong repo Flutter.

## M4 — Crush Card + Drift (1.5 ngày)

- [ ] Drift DB + bảng `crush_cards` + codegen.
- [ ] `CrushRepository` (CRUD + các watch query trong `08`).
- [ ] `crushCardsProvider`.
- [ ] Màn S3 Crush Card Editor (ảnh optional + tên + giá + FOMO reason + chọn mốc nhắc).
- [ ] Lưu snapshot ngày/giờ/% từ `WageCalculator` tại thời điểm tạo.
- [ ] Nén & lưu ảnh local; lưu image_path.
- [ ] Nối "Để mai tính"/"Lưu vào Calendar" từ S2 → tạo card.
- [ ] **DoD:** tạo, xem, sửa, xóa card; ảnh lưu/đọc đúng.

## M5 — Crush Calendar (1 ngày)

- [ ] Màn S4: 3 tab Today / Upcoming / Month.
- [ ] `crushCalendarProvider` derive view.
- [ ] Filter trạng thái; tap item → detail.
- [ ] Month view chỉ chấm, không lộ chi tiết.
- [ ] **DoD:** card có remindAt hiện đúng tab; privacy ở Month đảm bảo.

## M6 — Notifications + "Còn mê không?" (1 ngày) ← lõi retention loop

- [ ] `NotificationService` (flutter_local_notifications + timezone), xin quyền.
- [ ] Tính `remindAt` từ preset (`08` §4); schedule/cancel theo vòng đời card.
- [ ] Notification mặc định private; detail mode theo settings.
- [ ] Màn S5 "Còn mê không?" mở từ payload; xử lý 6 lựa chọn + cập nhật trạng thái + reschedule/cancel.
- [ ] **DoD:** đặt nhắc ngắn (vd 1 phút để test) → noti nổ → tap mở đúng card → đổi trạng thái hoạt động.

## M7 — Save Card + Settings + App lock (1 ngày)

- [ ] Màn S6 Save Card: 2–3 mẫu, render RepaintBoundary → PNG 9:16, lưu/chia sẻ. Không lộ lương gốc.
- [ ] Màn S7 Settings: sửa thu nhập, payday_day, app lock (local_auth), noti detail toggle, theme, **xóa toàn bộ dữ liệu** (2 bước).
- [ ] App lock check lúc khởi động nếu bật.
- [ ] **DoD:** xuất được card; xóa dữ liệu sạch (DB + ảnh + secure + noti); app lock chặn được.

## M8 — Polish MVP (0.5–1 ngày)

- [ ] Áp design tokens (`06`) toàn bộ; kiểm tiếng Việt không cụng dấu.
- [ ] Empty states, error states (không NaN/Infinity bao giờ).
- [ ] Hero count-up animation nhẹ.
- [ ] Smoke test toàn flow end-to-end.
- [ ] **DoD:** chạy mượt trên iOS + Android; analyze + test xanh.

---

## Phase 1.5 — Widgets (sau MVP)
- [ ] W1 Quick Check, W2 Preset Price, W3 Private Crush Reminder (iOS WidgetKit, Android Glance/App Widgets).
- [ ] Deep link từ widget vào đúng màn. Không lộ dữ liệu nhạy cảm.

## Phase 2 — Gen Z layer
- [ ] FOMO recall khi nhắc lại, Mood Check, **Anti-haul recap** (weekly/monthly), Mascot ví (optional), nhiều mẫu Save Card, reminder copy cá nhân hóa, **Salary Day Mode** (prompt quanh payday_day).

## Phase 3 — Worth Check
- [ ] Cost-per-use, uses-to-worth-it, compare 2 món, giá mục tiêu / chờ sale, ghi chú lý do.

## Phase 4 — Shopping workflow
- [ ] Share-extension nhận screenshot từ Shopee/Lazada/TikTok Shop, OCR lấy giá (ML Kit / Vision), AI nhận diện tên món, shortcut nhập nhanh.

---

## Thứ tự ưu tiên nếu phải cắt
Giữ bằng mọi giá: **M1 (calc) → M3 (hook) → M4 (card) → M6 (reminder loop)**. Đây là 4 mảnh tạo nên giá trị cốt lõi: quy đổi đúng, hook đập vào mắt, lưu được, và nhắc lại để "tỉnh". Save Card/Widget/Settings có thể tinh sau.
