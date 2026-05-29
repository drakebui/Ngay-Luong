# AGENTS.md — Hiến pháp dự án "Ngày Lương"

> File này là điểm vào (entry point) cho mọi AI coding agent (Claude Code / Codex).
> Đọc file này TRƯỚC TIÊN, rồi đọc `docs/` theo thứ tự số trước khi viết code.
> Nếu bạn dùng Claude Code, copy file này thành `CLAUDE.md` (nội dung giống hệt).

---

## 0. Một câu về sản phẩm

**Ngày Lương** là một mobile app (Flutter, iOS + Android) giúp người dùng quy đổi **giá món đồ → số ngày đi làm** trước khi mua, để tạo một khoảng dừng tỉnh táo. Đây **KHÔNG** phải app quản lý chi tiêu.

```
Core loop:  Price → Work Time → Pause → Decide
KHÔNG phải: Income → Budget → Spending → Report
```

---

## 1. Golden Rules (vi phạm = sai sản phẩm)

1. **KHÔNG** xây budget tracker, money manager, sổ thu chi, báo cáo dòng tiền, "còn bao nhiêu tiền", cảnh báo ngân sách. Nếu một task kéo app về hướng này → DỪNG, hỏi lại.
2. **KHÔNG** dùng từ "budget"/"ngân sách"/"số dư" ở bất kỳ đâu trong UI.
3. **Hero metric luôn là "X ngày đi làm".** Mọi màn kết quả phải để con số ngày lương là phần tử lớn nhất, đứng đầu.
4. **Local-first, no-login ở MVP.** Không gửi thu nhập thô, tên món, giá cụ thể, hay ảnh lên bất kỳ server/analytics nào.
5. **Thu nhập = dữ liệu nhạy cảm.** Lưu bằng `flutter_secure_storage` (Keychain/Keystore), KHÔNG lưu trong DB thường, KHÔNG log.
6. **Tone không phán xét.** Không bao giờ sinh ra microcopy kiểu "bạn tiêu hoang", "bạn không nên mua". Dùng đúng string trong `docs/07_COPY_VI.md`; không tự chế string tiếng Việt mới mà không thêm vào file đó.
7. **Notification/Widget mặc định private:** không hiện tên món, giá, ảnh, số ngày lương, thu nhập. Default chỉ "Còn mê không?".
8. **Tốc độ là tính năng.** Quick Check từ lúc mở tới lúc ra kết quả phải ≤ 2 thao tác. Nếu một flow làm chậm việc nhập giá → thiết kế lại.

---

## 2. Tech stack (đã chốt — không tự đổi)

| Hạng mục | Lựa chọn | Ghi chú |
|---|---|---|
| Framework | Flutter (stable ≥ 3.24), Dart ≥ 3.5 | Null-safe, không dùng package đã deprecated |
| State management | **Riverpod** (`flutter_riverpod` + `riverpod_annotation` codegen) | Provider đặt cạnh feature |
| Routing | **go_router** | Khai báo route tập trung tại `lib/core/router/` |
| DB quan hệ | **Drift** (SQLite) | Cho Crush Card, reminder, calendar query theo ngày |
| Secure storage | **flutter_secure_storage** | CHỈ cho IncomeProfile + app-lock secret |
| Settings nhẹ | **shared_preferences** | Onboarding done flag, theme, toggles không nhạy cảm |
| Notification | **flutter_local_notifications** + **timezone** | Schedule local, không cần FCM ở MVP |
| Ảnh | **image_picker** + **flutter_image_compress** + **path_provider** | Ảnh nén, lưu trong app documents dir |
| Save Card render | **RepaintBoundary** → `toImage` (không cần package ngoài) | Xuất PNG 9:16 |
| App lock | **local_auth** | Face ID / vân tay — có trong FREE tier |
| Định dạng tiền/số | **intl** (`vi_VN`) | Tách nghìn bằng ".", thập phân bằng "," |
| Localization | `flutter_localizations` + `intl`, default `vi` | EN có thể thêm sau |
| Lint | `flutter_lints` (hoặc `very_good_analysis`) | Bật strict |

Phiên bản cụ thể: xem `pubspec.yaml`. Nếu cần thêm package, ưu tiên package phổ biến, maintained, pub points cao; ghi lý do vào PR.

---

## 3. Kiến trúc & quy ước (chi tiết: `docs/02_ARCHITECTURE.md`)

- **Feature-first**: `lib/features/<feature>/{data,domain,presentation}`.
- **Core dùng chung**: `lib/core/{calc,db,storage,router,theme,widgets,utils}`.
- **Domain models** là plain Dart immutable class (đã viết sẵn — KHÔNG sửa signature tùy tiện): xem `lib/features/income/domain/income_profile.dart` và `lib/features/crush/domain/crush_models.dart`.
- **Calculation engine** đã viết sẵn và là **single source of truth**: `lib/core/calc/wage_calculator.dart`. Mọi quy đổi tiền→ngày phải đi qua đây, KHÔNG tính rải rác trong UI.
- Mọi giá trị hiển thị (ngày, giờ, %, tiền) phải dùng formatter trong `lib/core/utils/` (sẽ tạo), không format thủ công trong widget.

---

## 4. Thứ tự đọc tài liệu

1. `docs/01_PRD.md` — sản phẩm, scope MVP, in/out.
2. `docs/02_ARCHITECTURE.md` — cấu trúc thư mục, layering, data flow.
3. `docs/03_DATA_MODELS.md` — entity, enum, field.
4. `docs/04_CALCULATIONS.md` — công thức, làm tròn, edge case, ví dụ.
5. `docs/05_SCREENS.md` — từng màn, navigation, state.
6. `docs/06_DESIGN_SYSTEM.md` — design tokens.
7. `docs/07_COPY_VI.md` — toàn bộ microcopy tiếng Việt (nguồn string chuẩn).
8. `docs/08_DATA_PERSISTENCE.md` — schema Drift + secure storage + lịch notification.
9. `docs/09_BUILD_PLAN.md` — lộ trình milestone & task; **làm theo thứ tự này**.

---

## 5. Lệnh build & kiểm tra (chạy trước khi báo "xong")

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # sinh code Riverpod + Drift
flutter analyze                                             # phải sạch, 0 error
flutter test                                                # toàn bộ test phải pass
flutter run                                                 # smoke test trên simulator/emulator
```

Quy ước: **không commit code khi `flutter analyze` còn error hoặc test fail.**

---

## 6. Định nghĩa "Done" cho mỗi task

- Code compile, `flutter analyze` sạch.
- Có ít nhất 1 test cho logic mới (bắt buộc với calc & repository).
- Tuân thủ Golden Rules ở §1.
- String tiếng Việt lấy từ `docs/07_COPY_VI.md` (hoặc đã bổ sung vào đó).
- Không phá privacy (không log dữ liệu nhạy cảm).

---

## 7. Khi không chắc

- Mâu thuẫn giữa tài liệu và yêu cầu mới → ưu tiên Golden Rules, rồi hỏi lại người dùng.
- Thiếu thông tin để quyết định UX → chọn phương án ĐƠN GIẢN & NHANH NHẤT, ghi chú TODO, không tự ý mở rộng scope.
- Tuyệt đối không tự thêm tính năng ngoài `docs/01_PRD.md` (đặc biệt: social, leaderboard, bank-link, AI tâm lý).

---

## 8. Làm việc từ xa — Codex web

Workflow khi không có máy nhà:

```
Trước khi đi:   git push origin <branch>
Trên Codex web: đọc AGENTS.md + SESSION_NOTES.md + docs liên quan → thực thi task
CI tự chạy:     GitHub Actions kiểm flutter analyze + flutter test sau mỗi commit
Về nhà:         git pull
                flutter pub get
                dart run build_runner build --delete-conflicting-outputs
                flutter test
```

**Context tối thiểu paste vào mỗi Codex prompt:**

1. Toàn bộ §1 Golden Rules (file này).
2. Task cụ thể từ `docs/09_BUILD_PLAN.md` milestone hiện tại.
3. File spec liên quan (thường `docs/03`, `docs/04`, `docs/05`).
4. Nội dung `SESSION_NOTES.md` — để Codex biết trạng thái hiện tại.
5. Ràng buộc bắt buộc: **không sửa signature 3 file lõi**, không thêm package mới nếu không ghi lý do, `flutter analyze` phải sạch trước khi kết thúc.

**Kiểm tra kết quả từ điện thoại:**
Tab **Actions** trên GitHub → xem job "Analyze & Test" xanh hay đỏ.
