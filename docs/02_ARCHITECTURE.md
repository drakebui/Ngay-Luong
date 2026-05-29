# 02 — Architecture

## 1. Nguyên tắc

- **Feature-first** + clean layering nhẹ (data / domain / presentation).
- **Domain models** là plain immutable Dart, không phụ thuộc Flutter hay Drift.
- **Calculation** tập trung tại `core/calc` — single source of truth.
- **State** quản lý bằng Riverpod (codegen). UI không giữ business logic.
- **Persistence** giấu sau repository interface; UI/notifier không gọi Drift trực tiếp.

## 2. Cây thư mục mục tiêu

```
lib/
  main.dart
  app.dart                      # MaterialApp.router + theme + localization
  core/
    calc/
      wage_calculator.dart       # ĐÃ VIẾT SẴN — single source of truth
    db/
      app_database.dart          # Drift database (codegen)
      tables/                    # định nghĩa bảng Drift
    storage/
      income_storage.dart        # secure storage cho IncomeProfile
      settings_storage.dart      # shared_preferences (flags, toggles)
    router/
      app_router.dart            # go_router config
      routes.dart                # tên route hằng số
    theme/
      app_theme.dart             # ThemeData từ design tokens
      app_colors.dart
      app_typography.dart
      app_spacing.dart
    widgets/                     # widget tái dùng (PriceInput, HeroNumber, PrimaryButton...)
    utils/
      formatters.dart            # format tiền/ngày/giờ/% theo vi_VN
      result_phrasing.dart       # chọn microcopy theo ngữ cảnh kết quả
    notifications/
      notification_service.dart  # flutter_local_notifications + timezone
  features/
    onboarding/
      domain/
      presentation/
    income/
      domain/income_profile.dart # ĐÃ VIẾT SẴN
      data/income_repository.dart
      presentation/
    quick_check/
      domain/check_result.dart
      presentation/              # màn nhập giá + màn kết quả
    crush/
      domain/crush_models.dart   # ĐÃ VIẾT SẴN (enums + CrushCard)
      data/crush_repository.dart
      presentation/
        crush_card_editor/
        crush_calendar/
        still_crushing/          # màn "Còn mê không?"
    save_card/
      presentation/              # RepaintBoundary render + export
    settings/
      presentation/
  l10n/                          # arb files (vi mặc định)
```

## 3. Data flow

```
UI (ConsumerWidget)
  → đọc/ghi qua Riverpod Notifier/Provider
    → gọi Repository (interface)
      → IncomeRepository  → IncomeStorage (secure storage)
      → CrushRepository   → AppDatabase (Drift / SQLite)
  → quy đổi tiền↔thời gian LUÔN qua WageCalculator (core/calc)
  → format hiển thị LUÔN qua core/utils/formatters.dart
```

Quy tắc cứng:
- Widget **không** import Drift, không import secure_storage trực tiếp.
- Notifier **không** tự viết công thức quy đổi — gọi `WageCalculator`.
- Repository trả về domain model, không trả về Drift row ra ngoài.

## 4. Provider chính (đặt cạnh feature, codegen `@riverpod`)

- `incomeProfileProvider` — `AsyncNotifier<IncomeProfile?>` đọc/ghi secure storage.
- `wageCalculatorProvider` — derive từ `incomeProfileProvider`, expose hàm convert(price).
- `crushCardsProvider` — `AsyncNotifier<List<CrushCard>>` (stream từ Drift, lọc theo trạng thái).
- `crushCalendarProvider` — derive view Today / Upcoming / Month từ `crushCardsProvider`.
- `settingsProvider` — toggles (app lock, noti detail mode, mascot on/off).
- `antiHaulProvider` — tổng ngày lương "không bay màu" (derive từ card overI + skipped).

## 5. Navigation map (go_router)

```
/                         → Home (Quick Check input)
/result                   → Check Result (push, nhận price qua extra)
/crush/new                → Crush Card Editor (tạo card từ result hoặc từ đầu)
/crush/:id                → Crush Card Detail
/crush/:id/still          → "Còn mê không?" (mở từ notification)
/calendar                 → Crush Calendar (Today/Upcoming/Month tab)
/onboarding               → Income onboarding (lần đầu)
/settings                 → Settings (app lock, xóa dữ liệu, noti mode)
/save-card                → Save Card preview/export (push từ result/detail)
```

App lock kiểm tra ở app start (nếu bật) trước khi vào `/`.

## 6. Codegen

- Riverpod: `riverpod_annotation` + `riverpod_generator`.
- Drift: bảng + database codegen.
- Lệnh: `dart run build_runner build --delete-conflicting-outputs`.
- Commit cả file `.g.dart` (đơn giản hóa CI cho solo dev) — hoặc gitignore + chạy CI, agent tự chọn nhưng phải nhất quán; mặc định: **commit .g.dart**.

## 7. Testing

- `test/calc/` — unit test cho `WageCalculator` (xem ví dụ trong `04_CALCULATIONS.md`, bắt buộc cover hết).
- `test/crush/` — repository + state machine chuyển trạng thái.
- `test/formatters/` — format tiền/ngày/% đúng vi_VN.
- Ưu tiên unit test cho domain & calc; widget test ở mức smoke.
