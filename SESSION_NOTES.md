# Session Notes — Ngày Lương

Ghi theo thứ tự mới nhất lên trên. Cập nhật sau mỗi thay đổi có ý nghĩa.

---

## 2026-05-30 — Session 9

### Hoàn thành: M8 — Polish MVP

**Đã làm:**
- `lib/features/quick_check/presentation/screens/result_screen.dart` — hero count-up animation dùng `TweenAnimationBuilder<double>` 0→daysOfWage, 400ms `easeOut`.
- `lib/core/utils/formatters.dart` — guard NaN/Infinity trong `formatDays`, `formatHours`, `formatPct`, `formatMoney` trả `"–"` thay vì crash.
- `lib/features/income/presentation/screens/onboarding_screen.dart` — bỏ border override thừa để theme `InputDecoration` rounded field áp dụng đúng.
- `lib/features/settings/presentation/widgets/app_lock_gate.dart` — l10n hoá toàn bộ strings (bỏ hardcode tiếng Việt).
- `lib/features/save_card/presentation/screens/save_card_screen.dart` — l10n hoá title, snackbar, chip label.
- `lib/features/settings/data/data_reset_service.dart` — bỏ unused Drift import (fix CI flutter analyze).
- `lib/features/settings/presentation/screens/settings_screen.dart` — migrate `RadioListTile` → `RadioGroup<T>` (bỏ deprecated_member_use lint).
- `test/crush/crush_repository_test.dart` — anchor `watchRemindToday` test theo `DateTime.now()` thay vì hardcode 2026-05-29 (fix CI khi ngày thật qua ngày đó).
- `lib/features/save_card/data/card_renderer.dart` — thêm `deleteAllSavedCards()`.
- `lib/features/settings/data/data_reset_service.dart` — gọi `CardRenderer.deleteAllSavedCards()` trong `wipeEverything()` để xóa cả `save_cards/`.
- `lib/features/save_card/domain/save_card_template.dart` + `save_card_screen.dart` — ẩn template `onSale` khi `percentOff <= 0`.
- `lib/l10n/app_localizations.dart` + `app_localizations_vi.dart` — sinh lại từ ARB M7.

**Tests:**
- `test/save_card/save_card_template_test.dart` — bổ sung test `availableTemplates()` filtering và renderer được gọi khi wipe.
- `test/settings/data_reset_service_test.dart` — trailing commas + test renderer invocation.

**Kết quả CI:**
- `flutter analyze`: 0 issue ✓
- `flutter test`: 60/60+ pass ✓
- `flutter build apk --debug`: OK

**Còn lại / Notes:**
- `noti_detail_mode` chưa wire vào `NotificationService` (chỉ persist + toggle UI). Có thể làm sau.
- Nút "Chia sẻ" Save Card cần `share_plus` — bỏ qua để không thêm dep ngoài kế hoạch.
- Branch `claude/sleepy-ride-GnU6m` sẵn sàng merge vào `main`.

**Bước tiếp theo:**
- Merge branch `claude/sleepy-ride-GnU6m` → `main` (hoặc tạo PR).

---

## 2026-05-29 — Session 8

### Hoàn thành: M7 — Save Card + Settings + App lock

**Đã làm:**
- `lib/features/settings/data/settings_repository.dart` — wrap `SharedPreferences` cho `app_lock_enabled`, `noti_detail_mode`, `theme_mode`, `payday_day`, `mascot_enabled`; default `paydayDay = 5`, clamp 1..31; `resetAll()` xoá luôn `onboarding_done`.
- `lib/features/settings/data/app_lock_service.dart` — `AppLockService` + `AppLockAuthAdapter` (testable). `LocalAuthAdapter` bọc `local_auth`, swallow exception → false.
- `lib/features/settings/data/data_reset_service.dart` — orchestrator: cancel notifications → wipe DB → xoá thư mục ảnh → clear income (secure storage) → reset settings (+ onboarding flag).
- `lib/features/settings/presentation/providers/settings_provider.dart` — legacy Riverpod providers (không codegen): `settingsRepositoryProvider`, `appLockServiceProvider`, `dataResetServiceProvider`, `settingsControllerProvider` (`StateNotifierProvider<SettingsController, SettingsState>`).
- `lib/features/settings/presentation/screens/settings_screen.dart` — S7: sửa thu nhập, payday picker, app lock toggle (xin biometric trước khi bật), noti detail toggle, theme picker, xác nhận 2 bước cho "Xóa toàn bộ dữ liệu", success → go `/onboarding`.
- `lib/features/settings/presentation/widgets/app_lock_gate.dart` — sit trong `MaterialApp.router(builder: …)`, chặn UI tới khi xác thực xong nếu lock bật.
- `lib/features/save_card/domain/save_card_template.dart` — enum 3 mẫu + `SaveCardInput` (chỉ chứa `days`/`percentOff`/`itemName`, KHÔNG có thu nhập gốc).
- `lib/features/save_card/data/card_renderer.dart` — capture `RenderRepaintBoundary` → PNG → ghi vào `documents/save_cards/`.
- `lib/features/save_card/presentation/screens/save_card_screen.dart` — S6: 9:16 AspectRatio + RepaintBoundary, 3 ChoiceChip mẫu, nút "Lưu vào ảnh" → snackbar đường dẫn.
- `lib/core/router/app_router.dart` — nối `/settings` → `SettingsScreen`, `/save-card` → `SaveCardScreen` (extra: `SaveCardInput`), xoá `_PlaceholderScreen`.
- `lib/features/quick_check/presentation/screens/result_screen.dart` — thêm nút "Tạo Save Card" mở `/save-card` với `SaveCardInput.days = result.daysOfWage`.
- `lib/features/quick_check/presentation/screens/home_screen.dart` — thêm IconButton "Cài đặt" (`Icons.settings_outlined`) mở `/settings`.
- `lib/app.dart` — watch `settingsControllerProvider.themeMode`, wrap `MaterialApp.router.builder` bằng `AppLockGate`.
- `android/app/src/main/AndroidManifest.xml` — `USE_BIOMETRIC` + `USE_FINGERPRINT`.
- `android/app/src/main/kotlin/.../MainActivity.kt` — đổi `FlutterActivity` → `FlutterFragmentActivity` (yêu cầu của `local_auth`).
- `ios/Runner/Info.plist` — `NSFaceIDUsageDescription`.
- `lib/l10n/app_vi.arb` — bổ sung settings/save card/lock copy (`settingsTitle`, `themeLight/Dark/System`, `lockTitle`, `saveCardTitle`, …).

**Tests:**
- `test/settings/settings_repository_test.dart` — defaults, toggle persistence, theme round-trip, payday clamp, resetAll xóa hết.
- `test/settings/app_lock_service_test.dart` — forwards `isAvailable`, success/fail của adapter, custom reason.
- `test/settings/data_reset_service_test.dart` — wipe end-to-end với in-memory Drift + fake notification/image/income, check DB rỗng + onboarding flag tắt + cancelAll được gọi.
- `test/save_card/save_card_template_test.dart` — default template chọn `sleepOnIt` khi không sale, `onSale` khi `percentOff > 0`, 3 templates.

**Còn lại / Notes:**
- Chưa wire `noti_detail_mode` vào nội dung notification (`NotificationService.scheduleCard` vẫn dùng `defaultTitle/Body`). UI toggle đã có, persist OK; render detail sẽ làm ở M8 hoặc khi cần.
- Save Card chỉ "Lưu vào ảnh" → ghi PNG vào app documents dir (snackbar path). Không có nút "Chia sẻ" vì không add `share_plus` package (AGENTS §2: tránh thêm dep ngoài kế hoạch); có thể bổ sung sau.
- Môi trường Codex web không có Flutter SDK → KHÔNG chạy được `flutter analyze` / `flutter test` / `build_runner` local. CI GitHub Actions sẽ verify. Riverpod codegen tránh được bằng cách dùng legacy `Provider`/`StateNotifierProvider` cho providers mới của Settings.
- `MainActivity` đổi sang `FlutterFragmentActivity` để `local_auth` hoạt động trên Android.

**Bước tiếp theo — M8 (Polish MVP):**
- Áp design tokens triệt để, empty/error states, count-up animation hero, smoke test end-to-end.

---

## 2026-05-29 — Session 7

### Hoàn thành: M6 — Notifications + "Còn mê không?"

**Đã làm:**
- `lib/core/notifications/notification_service.dart` — `NotificationService` qua adapter testable, init `flutter_local_notifications` + timezone, request permission, `scheduleCard()`, `cancelCard()`, `cancelAll()`, payload = `card.id`, nội dung mặc định private.
- `lib/features/crush/data/crush_repository.dart` — inject `NotificationService`; insert schedule sau khi ghi DB, update cancel rồi schedule lại nếu còn pending, delete cancel trước khi xóa DB row/ảnh.
- `lib/features/crush/presentation/providers/crush_providers.dart` — thêm `notificationServiceProvider`, `crushCardProvider(cardId)` và sinh lại `.g.dart`.
- `lib/features/crush/presentation/controllers/still_crushing_actions.dart` — logic điều phối cho 6 lựa chọn S5.
- `lib/features/crush/presentation/screens/still_crushing_screen.dart` — màn `/crush/:id/still`: ảnh, tên, hero ngày đi làm snapshot, reason, 6 lựa chọn, nhắc lại theo `ReminderPreset`.
- `lib/core/router/app_router.dart` + `lib/app.dart` — route S5 thật và xử lý notification tap/launch payload sang `/crush/<id>/still`.
- `android/app/src/main/AndroidManifest.xml` — thêm `POST_NOTIFICATIONS` và `SCHEDULE_EXACT_ALARM`.
- `lib/l10n/app_vi.arb` + `docs/07_COPY_VI.md` — cập nhật copy noti private và S5.

**Tests:**
- `test/notifications/notification_service_test.dart` — schedule future/null/past + cancel id.
- `test/crush/still_crushing_test.dart` — 6 lựa chọn cập nhật status, cancel/schedule, delete.
- Cập nhật `test/crush/crush_repository_test.dart` để inject fake notification adapter.

**Kết quả:**
- `flutter pub get`: OK
- `dart run build_runner build --delete-conflicting-outputs`: OK
- `flutter analyze`: 0 issue ✓
- `flutter test`: 60/60 pass ✓
- `flutter build apk --debug --no-pub`: OK, sinh `build/app/outputs/flutter-apk/app-debug.apk`

**Ghi chú M6:**
- Đã thử `flutter run -d emulator-5554 --no-pub` nhưng emulator biến mất khỏi ADB trước khi launch. `flutter emulators --launch Pixel_10_Pro_XL` không làm device xuất hiện lại, nên chưa smoke được notification tap trên thiết bị thật/emulator.
- Không thêm package mới; test dùng fake adapter thuần Dart thay vì mockito/mocktail.

**Bước tiếp theo — M7:**
- Save Card + Settings + App lock.
- Reset/xóa toàn bộ dữ liệu phải gọi `NotificationService.cancelAll()`.

---

## 2026-05-29 — Session 6

### Hoàn thành: M5 — Crush Calendar

**Đã làm:**
- `lib/features/crush/domain/crush_calendar.dart` — view model thuần cho Today / Upcoming / Month, filter trạng thái, grouping theo ngày, Month chỉ expose danh sách ngày có chấm.
- `lib/features/crush/presentation/providers/crush_providers.dart` — thêm `crushCalendarProvider`, `crushCalendarFilterProvider`, `crushCalendarMonthProvider` và sinh lại `.g.dart`.
- `lib/features/crush/presentation/screens/crush_calendar_screen.dart` — màn S4 3 tab Today / Upcoming / Month, filter Đang treo / Hết mê / Đã mua / Tất cả, tap item mở `/crush/:id`.
- `lib/core/router/app_router.dart` — route `/calendar` trỏ vào `CrushCalendarScreen`.
- `lib/core/utils/formatters.dart` — thêm formatter giờ/ngày nhóm/tháng/weekday cho Calendar.
- `lib/l10n/app_vi.arb` + `docs/07_COPY_VI.md` — thêm copy chuẩn cho Calendar.

**Tests:**
- `test/crush/crush_calendar_test.dart` — cover Today ordering, Upcoming grouping, filter status, Month distinct date-only privacy.

**Kết quả:**
- `flutter pub get`: OK
- `dart run build_runner build --delete-conflicting-outputs`: OK
- `flutter analyze`: 0 issue ✓
- `flutter test`: 50/50 pass ✓

**Ghi chú M5:**
- `flutter run -d macos --no-pub` không chạy được vì project chưa cấu hình macOS desktop. Máy hiện chỉ thấy macOS/Chrome, không có iOS/Android simulator/emulator để smoke test mobile.
- Month view chỉ render số ngày + chấm, không render tên món, giá, ảnh, trạng thái hay số ngày lương.

**Bước tiếp theo — M6:**
- NotificationService + timezone.
- Schedule/cancel notification theo `remindAt` và trạng thái card.
- Màn S5 "Còn mê không?" xử lý 6 lựa chọn + reschedule/cancel.

---

## 2026-05-29 — Session 5 (support song song)

### Support tasks (Claude Code) — chạy đồng thời với Codex làm M4

- Chạy `dart run build_runner build` → sinh `app_database.g.dart` + `crush_providers.g.dart` (Codex cũng đã chạy sau đó)
- Bổ sung 9 tests vào `test/crush/`:
  - `remind_at_calculator_test.dart`: `untilPayday` end-of-month clamp, December → January wrap, `custom` preset trả đúng / ném `ArgumentError` khi null
  - `crush_repository_test.dart`: `watchAll` ordering DESC, `watchRemindToday` boundary, `watchUpcoming` future-only sorted ASC, `watchRemindDaysByMonth` distinct dates, `sumSavedDays` chỉ `overIt`+`skipped`
- Tổng sau khi Codex xong M4 + tests support: **47 tests pass**, `flutter analyze` 0 issue ✓

---

## 2026-05-29 — Session 5

### Hoàn thành: M4 — Crush Card + Drift

**Đã làm:**
- `lib/core/db/app_database.dart` — Drift `AppDatabase`, bảng `crush_cards`, index `remind_at`/`status`, schema version 1.
- `lib/core/db/image_storage.dart` — nén/lưu ảnh vào `crush_images/<cardId>.jpg`, xóa ảnh lẻ hoặc toàn thư mục.
- `lib/features/crush/data/crush_repository.dart` — CRUD, watch queries, mapping Drift row ↔ domain `CrushCard`, `sumSavedDays()`.
- `lib/features/crush/domain/remind_at_calculator.dart` — `ReminderPreset` + pure `RemindAtCalculator`.
- `lib/features/crush/presentation/providers/crush_providers.dart` — database/image/repository + stream/future providers.
- `lib/features/crush/presentation/screens/crush_editor_screen.dart` — S3 tạo/sửa card, ảnh optional, tên, giá, snapshot, FOMO reason, reminder preset/custom.
- `lib/core/router/app_router.dart` — nối `/crush/new` và `/crush/:id` vào `CrushEditorScreen`; giữ `/crush/:id/still` placeholder.
- `lib/features/quick_check/presentation/screens/result_screen.dart` — nối "Để mai tính" và "Lưu vào Calendar" sang S3 với snapshot từ `CheckResult`.
- `lib/l10n/app_vi.arb` + `docs/07_COPY_VI.md` — thêm string UI cho Crush Editor.

**Tests:**
- `test/crush/remind_at_calculator_test.dart` — 7 test bắt buộc cho preset reminder.
- `test/crush/crush_repository_test.dart` — insert/get, watchPending, update/sumSavedDays, delete.

**Kết quả:**
- `flutter pub get`: OK
- `dart run build_runner build --delete-conflicting-outputs`: OK, sinh Drift + Riverpod `.g.dart`
- `flutter analyze`: 0 issue ✓
- `flutter test`: 38/38 pass ✓

**Ghi chú M4:**
- DB có thêm cột `image_path` dù prompt mẫu bảng thiếu dòng này, vì `docs/08_DATA_PERSISTENCE.md`, domain `CrushCard.imagePath`, và yêu cầu xóa ảnh đều cần.
- Không chạy được smoke `flutter run` trên simulator/emulator vì máy hiện chỉ thấy macOS/Chrome, không có iOS/Android device/emulator; project hiện không có target desktop/web.

**Bước tiếp theo — M5:**
- Crush Calendar S4: Today / Upcoming / Month.
- Derive calendar providers/view model.
- Tap item mở `/crush/:id`.
- Month view chỉ hiện chấm theo ngày, không lộ tên/giá/ngày lương.

---

## 2026-05-29 — Session 4

### Hoàn thành: M3 — Quick Check + Result

**Đã làm:**

**Design tokens (mới):**
- `lib/core/theme/app_colors.dart` — AppColors (light + dark)
- `lib/core/theme/app_typography.dart` — AppTypography
- `lib/core/theme/app_spacing.dart` — AppSpacing
- `lib/core/theme/app_theme.dart` — AppTheme (light/dark, Material 3)

**Logic + providers:**
- `lib/features/quick_check/domain/result_phrasing.dart` — `ResultPhrasing.select()`: tiny (<0,3 ngày) / normal / heavy (≥5 ngày hoặc ≥30%)
- `lib/features/quick_check/presentation/providers/quick_check_provider.dart` — `priceInputProvider` (StateProvider)

**Widgets lõi:**
- `lib/core/widgets/hero_number_view.dart` — HeroNumberView: hero number + unit + sub-text

**Màn hình:**
- `lib/features/quick_check/presentation/screens/home_screen.dart` — S1 Home: price input tự format, nút Check, shortcut Calendar
- `lib/features/quick_check/presentation/screens/result_screen.dart` — S2 Result: hero ngày lương, sub-metrics (giờ/%), microcopy, DecisionRow 4 nút

**Files sửa:**
- `lib/core/router/app_router.dart` — nối route Home/Result với màn thật; truyền price qua GoRouter extra
- `lib/app.dart` — thêm AppTheme light/dark/system

**Tests:**
- `test/quick_check/result_phrasing_test.dart` — 7 test cases cho ResultPhrasing.select

**Kết quả:**
- `flutter analyze`: 0 issue ✓
- `flutter test`: 27/27 pass ✓

**Ghi chú M3:**
- DecisionRow: "Để mai tính" và "Lưu vào Calendar" hiện snackbar placeholder, nối ở M4
- Price truyền sang ResultScreen qua `GoRouterState.extra as double` (không dùng query param để tránh mất precision)
- `withOpacity` deprecated → dùng `.withValues(alpha: ...)` xuyên suốt

**Bước tiếp theo — M4:**
- Drift DB + bảng `crush_cards` + codegen
- `CrushRepository` (CRUD)
- `crushCardsProvider`
- Màn S3 Crush Card Editor (ảnh optional + tên + giá + FOMO reason + mốc nhắc)
- Nối "Để mai tính"/"Lưu vào Calendar" từ S2 → tạo card

---

## 2026-05-29 — Session 3

### Hoàn thành: CI/CD + Remote workflow setup

**Đã làm:**
- Tạo `.github/workflows/ci.yml` — GitHub Actions tự chạy `flutter analyze` + `flutter test` mỗi khi push bất kỳ branch nào.
- Thêm §8 "Làm việc từ xa" vào `AGENTS.md` — hướng dẫn workflow Codex web + context tối thiểu cần paste.
- Cập nhật `README.md` — badge CI + bảng milestone + lệnh dev chuẩn.

**Việc cần làm sau khi push lên GitHub:**
- Thay `YOUR_USERNAME/YOUR_REPO` trong `README.md` bằng đường dẫn repo thật.

---

## 2026-05-29 — Session 2

### Kế hoạch: M2 — Income onboarding + storage

**Vai trò:** Kiến trúc sư (viết prompt Codex)

**Files cần tạo (5 files):**
- `lib/features/income/data/income_storage.dart` — IncomeStorage (flutter_secure_storage)
- `lib/features/income/data/income_repository.dart` — IncomeRepository (storage + shared_prefs)
- `lib/features/income/presentation/providers/income_provider.dart` — providers (Riverpod codegen)
- `lib/features/income/presentation/screens/onboarding_screen.dart` — S0 Onboarding UI

**Files cần sửa (3 files):**
- `lib/main.dart` — await SharedPreferences trước runApp để xác định initialRoute
- `lib/app.dart` — nhận initialLocation từ main
- `lib/core/router/app_router.dart` — truyền initialLocation vào GoRouter

**DoD:** nhập thu nhập → lưu → đóng app mở lại vẫn còn; analyze sạch.

**Bước tiếp theo:**
- [ ] Soạn prompt Codex M2
- [ ] Codex thực thi M2
- [ ] Verify: flutter analyze + flutter test + smoke test onboarding flow

---

## 2026-05-29 — Session 1

### Hoàn thành: M1 — Calculation Engine Tests + Formatters

**Đã làm:**
- Thêm `test/calc/wage_calculator_test.dart` cover 5 worked examples A-E và edge cases cho `WageCalculator`.
- Thêm `lib/core/utils/formatters.dart` làm single source cho format ngày/giờ/%/tiền/cost-per-use và parse giá bằng `intl`.
- Thêm `test/formatters/formatters_test.dart` cover toàn bộ expected string bắt buộc.
- Không sửa `wage_calculator.dart`, `income_profile.dart`, `crush_models.dart`.

**Kết quả:**
- `flutter analyze`: 0 issue ✓
- `flutter test`: pass, 20/20 tests ✓

**Ghi chú:**
- Edge case `mode hourly + workHoursPerDay=0` hiện ném `CalcError.noIncome` ở constructor vì không tính được `dailyWage`; test M1 ghi nhận behavior hiện tại. Nhánh `hoursOfWork == null` được cover bằng profile daily có `workHoursPerDay=0`.

### Hoàn thành: M0 — Project Setup

**Đã làm:**
- Đọc và nắm toàn bộ 15 file spec (AGENTS.md, CLAUDE.md, 01→09, 3 Dart lõi, pubspec.yaml)
- `flutter create` với org `com.ngayluong`, package `ngay_luong`, iOS 13+, Android 24+
- Thay `pubspec.yaml` bằng bộ dependencies đã chốt (nâng intl lên 0.20.2 cho khớp SDK)
- Set Android `minSdk = 24` trong `build.gradle.kts`
- Tạo cây thư mục đầy đủ theo `02_ARCHITECTURE.md`
- Copy 3 file lõi vào đúng vị trí (wage_calculator, income_profile, crush_models)
- Tạo `lib/l10n/app_vi.arb` (~50 strings từ `07_COPY_VI.md`); chạy `flutter gen-l10n`
- Cấu hình `analysis_options.yaml` (strict-casts, strict-inference, strict-raw-types)
- Viết `lib/main.dart`, `lib/app.dart`, `lib/core/router/app_router.dart`, `routes.dart`
- Copy toàn bộ spec docs vào `docs/`

**Kết quả:**
- `flutter analyze`: 0 issue ✓
- `flutter test`: pass ✓

---

### Hoàn thành: Prompt M1 cho Codex

**Đã làm:**
- Soạn prompt chi tiết cho Codex thực hiện M1:
  - Unit tests WageCalculator (5 worked examples A–E + 7 edge cases, sai số ±0.05)
  - `lib/core/utils/formatters.dart` (format ngày/giờ/%/tiền vi_VN bằng `intl`)
  - Unit tests formatters (16 test case với expected string chính xác)
- Ràng buộc ghi rõ: không sửa 3 file lõi, không thêm package, chỉ dùng package: imports

**Vai trò:** Kiến trúc sư (viết prompt, không dev trực tiếp)

---

### Bước tiếp theo

- [ ] **M1** — Codex thực thi 3 file: `test/calc/wage_calculator_test.dart`, `lib/core/utils/formatters.dart`, `test/formatters/formatters_test.dart`
- [ ] **M2** — Sau M1: IncomeStorage + IncomeRepository + incomeProfileProvider + màn S0 Onboarding
