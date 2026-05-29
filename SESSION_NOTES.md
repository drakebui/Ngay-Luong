# Session Notes — Ngày Lương

Ghi theo thứ tự mới nhất lên trên. Cập nhật sau mỗi thay đổi có ý nghĩa.

---

## 2026-05-29 — Session 1

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
