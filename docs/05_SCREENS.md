# 05 — Screens

Ký hiệu: mỗi màn ghi rõ **route**, **mục tiêu**, **visual reference**, **thành phần**, **trạng thái**, **điều hướng**.
Hero number (`X ngày đi làm`) luôn là phần tử lớn nhất ở mọi màn kết quả. Phương án D dùng visual system **Midnight Matcha** trong `docs/11_VISUAL_LANGUAGE.md`.

---

## 0. Navigation map — Phương án D

**Bottom nav cố định 2 tab:**

| Tab | Route gốc | Nội dung |
|---|---|---|
| **Tính toán** | `/` | S1 Home / Quick Check và luồng S2 Result. |
| **Crush** | `/crush` | S4 Crush feed, đồng thời là nơi xem Feed / Lịch / Tháng bên trong cùng tab. |

**Routes ngoài bottom nav / entry point:**

- `/onboarding` — S0 Onboarding thu nhập, mở khi chưa có `IncomeProfile` dùng được hoặc user sửa thu nhập.
- `/result` — S2 Check Result, nhận price và optional image/name draft từ S1.
- `/crush/new` — S3 Crush Card Editor tạo mới.
- `/crush/:id` — S3 Crush Card detail/read mode + sửa.
- `/crush/:id/still` — S5 “Còn mê không?”, mở từ notification hoặc từ S4 khi `remindAt` đã qua.
- `/save-card` — S6 Save Card.
- `/settings` — S7 Settings, mở từ settings icon trong top app bar; không là bottom-nav tab.

**Điều hướng chính:**

```text
Tính toán (/)
  ├─ chưa onboarding + bấm Check → /onboarding → quay lại / hoặc /result
  └─ nhập giá + CTA "Xem mấy ngày lương" → /result
        ├─ "Lưu vào Crush" / "Để mai tính" → /crush/new
        ├─ "Tính món khác" → /
        └─ "Tạo Save Card" → /save-card

Crush (/crush)
  ├─ view Feed / Lịch / Tháng trong cùng tab
  ├─ FAB + → / (focus price input) hoặc /crush/new nếu đã có draft
  ├─ tap card → /crush/:id
  └─ card quá hạn → /crush/:id/still

Settings entry point (/settings)
  ├─ mở từ settings icon trong top app bar
  ├─ sửa thu nhập → /onboarding
  └─ xóa toàn bộ dữ liệu → confirm 2 bước trong màn
```

---

## S0. Onboarding thu nhập — `/onboarding`

**Mục tiêu:** lấy đủ dữ liệu tính ngày/giờ làm, càng ngắn càng tốt, trấn an privacy. Stitch chỉ minh họa monthly mode; app vẫn phải giữ đủ 4 mode theo `IncomeProfile`.

**Visual reference:** `docs/_stitch_export/screenshots/income_screen.png`; pattern chi tiết ở `docs/11_VISUAL_LANGUAGE.md` §11 Input Fields và §12 Live Preview Card.

**Thành phần:**

- **Top app bar:** cùng pattern avatar + wordmark + settings nếu onboarding mở trong app; nếu first-run có thể chỉ dùng wordmark để giảm nhiễu.
- **Heading lớn:** Be Vietnam Pro, `onSurface`, nói rõ mục tiêu quy đổi thời gian đi làm; helper line ngắn, không phán xét.
- **Mode selector:** 4 pill/card lựa chọn: Theo tháng / Theo ngày / Theo giờ / Theo dự án. Active mode dùng `primaryContainer`; inactive dùng `surfaceContainerHigh`.
- **Input theo mode:** pill-shaped, `surfaceContainerLow`, không border mặc định, focus border 2px `primary` + glow 5-8%.
  - `monthly`: thu nhập net/tháng + workDaysPerMonth mặc định 22 + workHoursPerDay mặc định 8; 2 field sau nằm trong khu “Tùy chỉnh”. Currency input có suffix `đ` inline.
  - `daily`: thu nhập/ngày + giờ/ngày default 8; currency input có suffix `đ`.
  - `hourly`: thu nhập/giờ; currency input có suffix `đ`.
  - `project`: thu nhập dự án + chọn tổng giờ hoặc tổng ngày; currency input có suffix `đ`.
- **Live Preview Card:** giữ pattern Stitch: `primaryContainer` fill, rounded-2xl, label uppercase tracking-wider, headline-xl number. Ví dụ monthly: `GIÁ TRỊ 1 GIỜ CỦA BẠN: 142.045đ`. Với daily/hourly/project, preview vẫn dùng cùng layout nhưng đổi label theo giá trị tính được.
- **Privacy banner:** luôn hiển thị copy `privacy.onboarding` từ `docs/07_COPY_VI.md`; không log hoặc gửi thu nhập.
- **CTA:** pill primary “Xong”; disabled tới khi `IncomeProfile.isUsable == true`.
- **Optional:** “Bỏ qua, nhập sau” chỉ cho phép vào Home; khi bấm Check vẫn yêu cầu setup.

**Trạng thái:**

- Validate theo `IncomeProfile.isUsable`.
- Giá trị nhạy cảm chỉ lưu qua secure storage khi user bấm “Xong”.
- Không hiện NaN/Infinity; preview trống hoặc helper copy khi thiếu dữ liệu.

**Điều hướng:**

- Xong → lưu secure storage, set `onboarding_done=true` → quay về route gọi màn (`/` mặc định) và tiếp tục Quick Check nếu có draft price.
- Bỏ qua → `/`; bấm Check sau đó mở lại `/onboarding`.

---

## S1. Home / Quick Check — `/`

**Mục tiêu:** nhập giá cực nhanh, ra kết quả ngay trong tối đa 2 thao tác.

**Visual reference:** `docs/_stitch_export/screenshots/home_screen.png`; áp dụng Top App Bar, Input Fields, Primary CTA Button trong `docs/11_VISUAL_LANGUAGE.md` §2, §8, §11. Giữ Home sạch, không dùng hero banner lớn vì input phải là focal point.

**Thành phần:**

- **Top app bar:** avatar | wordmark | settings, height 72px + safe area, `surface/90` backdrop blur khi scroll.
- **Focal input area:** clean/simple; không dùng banner lớn. Có thể có 1 hint nhỏ xoay vòng phía trên input, ví dụ “Một câu hỏi tỉnh ví trước khi tap mua”. Hint dùng `body-md` muted, không chiếm hero.
- **Price input lớn:** pill-shaped, `surfaceContainerLow`, numeric keypad, auto-format `3.000.000`, suffix `đ` inline, font ≥ 28sp.
- **CTA chính:** `Xem mấy ngày lương`, rounded-full, `primaryContainer` fill, leading/trailing arrow Material Symbol, organic primary-tinted shadow.
- **Recent items strip:** horizontal strip chỉ hiện khi có Crush Card gần đây; item nhỏ gồm photo/placeholder + tên rút gọn + Days-of-Wage Chip. Không làm chậm nhập giá.
- **Photo shortcut:** optional secondary pill để chụp/chọn ảnh món đồ và đưa ảnh đó vào draft result/editor; không bắt buộc cho Quick Check.
- **Bottom nav:** 2 tabs; active tab “Tính toán”. Settings mở qua icon top app bar, không là tab riêng.

**Trạng thái:**

- Nếu chưa onboarding: bấm CTA → mở `/onboarding` modal/fullscreen; xong quay lại tính tiếp với price đã nhập.
- Nếu price invalid/empty: CTA disabled hoặc helper copy nhẹ dưới input.
- Không hiện bất kỳ thông tin thu nhập thô nào ở Home.

**Điều hướng:**

- CTA `Xem mấy ngày lương` → `/result` với price, optional image/name draft.
- Tap recent item → `/crush/:id`.
- Settings icon → `/settings` (entry point ngoài bottom nav).

---

## S2. Check Result — `/result`

**Mục tiêu:** cho user thấy ngay “món này = X ngày đi làm”, rồi chọn bước tiếp theo mà không bị phán xét.

**Visual reference:** `docs/_stitch_export/screenshots/result_screen.png`; áp dụng Hero Product Image, Hero Number Block, Bento Sub-Metrics, Primary/Secondary CTA trong `docs/11_VISUAL_LANGUAGE.md` §3, §4, §5, §8, §9.

**Thành phần theo thứ tự từ trên xuống:**

1. **Hero Product Image:** full circle 256-320px, decorative `secondaryContainer` blur-3xl scale-125 phía sau. Nếu không có ảnh, dùng sage placeholder với ngày lương centered.
2. **Hero Number Block:**
   - Label uppercase: `THỜI GIAN QUY ĐỔI`.
   - Hero number: `4,4 ngày đi làm`, primary color, 56-72sp / w800.
   - Descriptive sentence: microcopy từ `result_phrasing.dart` / `docs/07_COPY_VI.md`, ngắn và không phán xét.
3. **Bento sub-metrics:** 2x2 grid visual, nhưng MVP chỉ populate các metric có dữ liệu:
   - `Giờ làm việc` — ví dụ `35,2 giờ`.
   - `% thu nhập tháng` — ví dụ `20%` nếu profile tính được monthly equivalent.
   - Hai slot còn lại ẩn ở MVP hoặc dành cho reminder/draft context khi có dữ liệu.
4. **Decision entry:** vì user chưa quyết định ở thời điểm này, Phương án D chọn flow sạch theo Stitch button density:
   - Primary CTA: `Lưu vào Crush` hoặc `Để mai tính` → mở S3 Crush Card Editor để chọn lý do + mốc nhắc. Đây là đường chính để tạo card `sleepOnIt/crushing`.
   - Secondary CTA: `Tính món khác` → quay Home và focus price input.
   - Optional tertiary text/pill: `Tạo Save Card` → S6, không được nổi hơn hero/primary.
5. **Decision semantics:** 4 quyết định từ spec vẫn tồn tại nhưng không ép thành hàng ngang trên S2:
   - `Mua`, `Bỏ qua`, `Để mai tính`, `Lưu` được xử lý trong S3 detail/editor khi đã có Crush Card, hoặc bằng quick actions trong editor.
   - Từ S2, primary `Lưu vào Crush` là bước gom thông tin để chọn reason/reminder trước khi quyết định.

**Trạng thái:**

- Price invalid hoặc thiếu income → empty/error calm, không hiện NaN/Infinity; CTA dẫn về Home hoặc Onboarding.
- Mọi quy đổi dùng `WageCalculator`; mọi format dùng formatter trong `lib/core/utils/`.
- Hero number luôn là phần tử lớn nhất.

**Điều hướng:**

- Primary `Lưu vào Crush` / `Để mai tính` → `/crush/new` với snapshot ngày/giờ/% và draft price/image/name.
- Secondary `Tính món khác` → `/`.
- `Tạo Save Card` → `/save-card` với snapshot hiện tại.

---

## S3. Crush Card Editor / Detail — `/crush/new`, `/crush/:id`

**Mục tiêu:** lưu món muốn mua kèm ảnh + lý do + mốc nhắc; xem lại card và cập nhật quyết định.

**Visual reference:** form/detail dùng Midnight Matcha từ `docs/_stitch_export/screenshots/result_screen.png` cho hero image + bento snapshot, và `docs/_stitch_export/screenshots/wishlist_screen.png` cho card/photo treatment.

**Thành phần:**

- **Hero image area:** circular photo hoặc sage placeholder; photo actions là pill buttons: Chụp ảnh / Chọn ảnh / Xóa ảnh.
- **Form fields:** pill-shaped inputs theo §11 Visual Language.
  - Tên món (optional).
  - Giá (bắt buộc, mặc định từ S2 nếu có), suffix `đ` inline.
  - Category optional, preset + tự do.
- **Snapshot block:** Days-of-Wage Chip + bento nhỏ cho giờ/%; snapshot lưu tại thời điểm tạo card.
- **FOMO Check:** “Vì sao bạn muốn mua món này?” → chips chọn `CrushReason`; optional text note nếu spec cho phép.
- **Reminder presets:** chips `ReminderPreset`: Tối nay / 24h / 3 ngày / 7 ngày / Tới ngày lương / Chọn ngày.
- **Decision actions trong detail/read mode:** Mua / Để mai tính / Bỏ qua / Lưu được trình bày bằng pill buttons đồng cấp hoặc primary + secondary stack tùy trạng thái, tone không phán xét.
- **CTA lưu:** rounded-full primary; disabled khi thiếu price hoặc profile không tính được.

**Trạng thái:**

- New mode nhận draft từ S2; edit mode load card từ Drift.
- Ảnh local-first; không upload ảnh/tên/giá.
- Khi lưu card, lưu `snapshotDays`, `snapshotHours`, `snapshotMonthlyPercent` từ `WageCalculator`.

**Điều hướng:**

- Lưu → ghi DB, đặt/cập nhật local notification nếu có `remindAt` → `/crush` tab Crush.
- Back từ detail → giữ view mode/filter trước đó trong S4.
- Chọn decision có reminder → schedule/cancel notification tương ứng.

---

## S4. Crush feed — `/crush`

**Mục tiêu:** một tab duy nhất để xem các món đang chờ tỉnh táo hơn: Feed / Lịch / Tháng. Đây là destination duy nhất cho feed và các view lịch; không có tab thứ tư.

**Visual reference:** `docs/_stitch_export/screenshots/wishlist_screen.png`; áp dụng Days-of-Wage Chip, Crush Feed Card, Floating Bottom Nav, FAB, Filter Chips trong `docs/11_VISUAL_LANGUAGE.md` §6, §7, §10, §13, §14.

**Header / stat area:**

- Label uppercase: `TỔNG CỘNG`.
- Dynamic stat number: ví dụ `42,5 ngày`; hero-ish but smaller than S2 result.
- Descriptive line: giải thích stat theo filter đang active, ví dụ tổng ngày lương của các món “Đang mê”.
- View mode toggle nhỏ ở top-right của stat: `Feed` / `Lịch` / `Tháng`; default `Feed`.

**Filter chips row:**

- Horizontal scroll nếu overflow.
- Chips: `Đang mê` (default active) / `Sắp nhắc` / `Hết mê` / `Đã mua` / `Tất cả`.
- Active dùng `primaryContainer`; inactive dùng `surfaceContainerHigh`.
- Stat number thay đổi theo filter:
  - Đang mê/Sắp nhắc: tổng ngày lương đang chờ xem lại.
  - Hết mê: tổng ngày lương “không bay màu”.
  - Đã mua: tổng ngày lương đã quyết định mua.
  - Tất cả: tổng snapshot days trong phạm vi MVP.

**View mode: Feed (default):**

- Pinterest-style cards, 1 column, large photo `h-64`, rounded-2xl.
- Heart icon top-right trong glassmorphic `surface/60` backdrop-blur pill; `fill: 1` khi stillCrushing/favorite.
- Tên + description/reason dưới ảnh; Days-of-Wage Chip ở bottom.
- Tap toàn card → `/crush/:id` detail/read mode.
- Empty copy: “Chưa có món nào đang chờ bạn tỉnh ví.” với sage illustration placeholder.

**View mode: Lịch:**

- Chronological list grouped by reminder date: `Hôm nay` / `Mai` / `Tuần này` / `Sắp tới`.
- Same card style but smaller: thumbnail/compact photo, tên, Days-of-Wage Chip, reminder time visible.
- Nếu `remindAt` đã qua, card có affordance mở S5 “Còn mê không?” nhưng không dùng warning red.

**View mode: Tháng:**

- Lưới tháng dạng calendar-style nhưng không là destination riêng.
- Days with reminders show subtle sage dots only.
- Privacy-safe: grid level không hiện tên, giá, ảnh, ngày lương, hoặc thu nhập.
- Tap day → bottom sheet/list private enough inside app showing items for that day; tap item → detail.

**FAB:**

- Bottom-right above bottom nav, rounded-full `primaryContainer`, plus icon `Symbols.add`, organic shadow.
- Opens Quick Check flow (`/` with price input focus) by default. If user is already creating a draft, can open `/crush/new` with draft.

**Bottom nav:** active tab “Crush”.

---

## S5. “Còn mê không?” — `/crush/:id/still`

**Mục tiêu:** khoảnh khắc quyết định lại sau cooldown. Mở từ notification hoặc tự mở từ S4 khi `card.remindAt` đã qua và user tap card quá hạn.

**Visual reference:** adapt `docs/_stitch_export/screenshots/result_screen.png` hero image/number rhythm with full-screen modal treatment from `docs/11_VISUAL_LANGUAGE.md` §3, §8, §9, §15.

**Thành phần:**

- **Full-screen modal:** `bg #F4FAFD`, safe-area padding 20px, close/back pill ở top.
- **Hero product image:** circular, nhỏ hơn Result (180-240px), decorative blur nhẹ; nếu không có ảnh dùng sage placeholder.
- **Question:** `Còn mê không?` lớn, primary color, Be Vietnam Pro 32-40sp / w800.
- **Context:** tên món optional + Days-of-Wage Chip snapshot; nếu có `reason`, hiển thị “Trước đó bạn muốn mua vì: [reason]”.
- **Actions:** 5 stacked pill action buttons, generous spacing:
  - Vẫn mê.
  - Hết mê rồi.
  - Chờ sale.
  - Mua rồi.
  - Nhắc lại lần nữa.
- **Delete:** Xóa là tertiary/destructive text action thấp hơn, có confirm; không nằm trong 5 lựa chọn chính để tránh tap nhầm.

**Trạng thái / side effects:**

- Vẫn mê → status `stillCrushing`; có thể gợi ý đặt nhắc tiếp.
- Hết mê rồi → status `overIt`; microcopy anti-haul “+X ngày lương còn sống” nếu copy có trong `07_COPY_VI.md`.
- Chờ sale → status `waitingForSale`.
- Mua rồi → status `bought`.
- Nhắc lại lần nữa → chọn preset mới, `remindCount++`, đặt lại notification.
- Xóa → xóa card + ảnh local + hủy notification sau confirm.

**Điều hướng:**

- Sau action thành công → back về `/crush` với filter phù hợp hoặc card detail.
- Notification tap → route thẳng `/crush/:id/still`.

---

## S6. Save Card — `/save-card`

**Mục tiêu:** xuất ảnh 9:16 chia sẻ được, không lộ thu nhập gốc.

**Visual reference:** use Midnight Matcha palette and card styling from `docs/_stitch_export/screenshots/result_screen.png`; rendered-card shadow follows `docs/11_VISUAL_LANGUAGE.md` §4, §8, §15.

**Thành phần:**

- Preview card tỉ lệ **9:16** tối ưu story/TikTok.
- Rendered card dùng `surfaceContainerLowest` hoặc `primaryContainer` tùy template, rounded-2xl, organic sage/primary shadow.
- Nội dung mẫu:
  - “Món này = 4,4 ngày đi làm — Để mai tính.”
  - “Sale 50% nhưng vẫn là 2,1 ngày lương.”
  - “Tôi vừa không mua món này. +3,4 ngày lương còn sống.”
- Hero number vẫn lớn nhất trong card.
- Chọn mẫu MVP: 2-3 mẫu, horizontal cards/chips.
- Buttons: Lưu vào ảnh / Chia sẻ, rounded-full.
- Không hiển thị thu nhập gốc, raw price nếu template không cần, hoặc bất kỳ dữ liệu nhạy cảm nào.

**Trạng thái:**

- Render bằng RepaintBoundary → PNG.
- Nếu chưa có snapshot, mở S1/S2 để tính trước.
- Nếu share/save lỗi, hiện snackbar calm; không mất preview.

**Điều hướng:**

- Back → route gọi màn.
- Save/share thành công → giữ user ở preview để có thể lưu mẫu khác.

---

## S7. Settings — `/settings`

**Mục tiêu:** quản lý thiết lập cá nhân và privacy qua settings entry point, không biến app thành công cụ quản lý dòng tiền.

**Visual reference:** `docs/_stitch_export/screenshots/home_screen.png` cho top app bar; list styling theo Midnight Matcha (`docs/11_VISUAL_LANGUAGE.md` §2, §11, §17).

**Thành phần:**

- **Top app bar:** avatar | wordmark | settings/profile affordance. Bottom nav vẫn chỉ có Tính toán / Crush; Settings không là tab riêng.
- **List sections:** generous padding 20-24px, list items rounded-xl hoặc full-width rows với divider `outlineVariant/30` rất nhẹ.
- **Sửa thu nhập:** mở lại `/onboarding` với mode hiện tại; nhắc privacy.
- **Ngày lương trong tháng:** `payday_day`, mặc định 5; dùng cho reminder preset “Tới ngày lương”.
- **App lock:** Face ID / vân tay toggle (`local_auth`).
- **Notification detail mode:** mặc định tắt/private; khi tắt, notification/widget không hiện tên món, giá, ảnh, số ngày lương, thu nhập.
- **Theme:** light/dark/system.
- **Mascot ví:** Phase 2, nếu chưa build thì ẩn hoặc disabled rõ là “sau MVP”; không làm nhiễu MVP.
- **Privacy policy:** text tĩnh.
- **Xóa toàn bộ dữ liệu:** giữ confirm 2 bước; copy rõ xóa DB, ảnh local, secure storage, shared preferences liên quan, notification.

**Trạng thái:**

- Toggle lưu bằng repository/settings tương ứng.
- Income vẫn lưu secure storage; không log raw value.
- Reset data phải cancel notifications và xóa ảnh local.

**Điều hướng:**

- Sửa thu nhập → `/onboarding`.
- Reset thành công → clear stack về `/onboarding` hoặc `/` chưa setup.

---

## Widget (Phase 1.5) — không phải route

**Visual reference:** widgets follow the same privacy and Midnight Matcha rules from `docs/11_VISUAL_LANGUAGE.md` §10, §17; no dedicated Stitch widget screenshot yet.

- **W1 Quick Price Check:** “Món này tốn mấy ngày lương?” → tap mở thẳng S1, focus price input.
- **W2 Preset Price:** 99k / 199k / 499k / 999k / Khác → tap deep link tới S2 nếu có đủ income, hoặc S0 nếu chưa setup.
- **W3 Private Crush Reminder:** mặc định “Có 1 món đang chờ bạn xem lại.” Detail mode mới hiện thêm thông tin, và chỉ khi user bật.
- **W4 Reminder Quote (Phase 2):** câu nhắc đổi mỗi ngày.

Widget mặc định tuyệt đối không hiện: thu nhập, lương ngày/giờ, tên món, giá món, ảnh món, hoặc số ngày lương.
