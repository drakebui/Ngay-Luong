# 05 — Screens

Ký hiệu: mỗi màn ghi rõ **route**, **mục tiêu**, **thành phần**, **trạng thái**, **điều hướng**.
Hero number ("X ngày đi làm") luôn là phần tử lớn nhất ở mọi màn kết quả.

---

## S0. Onboarding thu nhập — `/onboarding`

**Mục tiêu:** lấy đủ dữ liệu tính lương ngày, càng ngắn càng tốt. Trấn an privacy.

**Thành phần:**
- Bước 1: chọn mode — 4 lựa chọn dạng card lớn: Theo tháng / Theo ngày / Theo giờ / Theo dự án (freelancer).
- Bước 2: nhập số liệu tương ứng mode (xem `03_DATA_MODELS.md`):
  - monthly: thu nhập net/tháng + (workDaysPerMonth mặc định 22) + (workHoursPerDay mặc định 8), 2 cái sau có thể chỉnh trong "Tùy chỉnh".
  - daily: thu nhập/ngày + giờ/ngày (default 8).
  - hourly: thu nhập/giờ.
  - project: thu nhập dự án + chọn tổng giờ HOẶC tổng ngày.
- Banner privacy (luôn hiển thị): copy `privacy.onboarding` từ `07_COPY_VI.md`.
- Cho phép nhập **khoảng** (slider/preset) nếu user ngại gõ chính xác — optional, nhưng lưu giá trị giữa khoảng.

**Trạng thái:** nút "Xong" disabled tới khi `IncomeProfile.isUsable == true`.

**Điều hướng:** Xong → lưu secure storage, set `onboarding_done=true` → `/` (Home). Có thể "Bỏ qua, nhập sau" → vào Home nhưng Quick Check sẽ nhắc setup khi bấm Check.

---

## S1. Home / Quick Check — `/`

**Mục tiêu:** nhập giá cực nhanh, ra kết quả ngay.

**Thành phần:**
- **Price input lớn** (numeric keypad, auto-format `3.000.000`), là tâm điểm màn hình.
- Nút **Check** (primary, lớn).
- Shortcut: 📷 Chụp/chọn ảnh món đồ (→ tạo Crush Card luôn), 🗓 Mở Crush Calendar.
- (Optional) hàng "Recent Crush Cards" cuộn ngang ở dưới — chỉ hiện nếu có card.
- Nếu chưa onboarding: bấm Check → mở `/onboarding` (modal), xong quay lại tính tiếp.

**Điều hướng:** Check → `/result` (truyền price).

---

## S2. Check Result — `/result`

**Mục tiêu:** đập vào mắt con số ngày lương + cho quyết định.

**Thành phần (thứ tự từ trên xuống):**
1. **Hero:** `4,4 ngày đi làm` + dòng phụ `để mua [tên món / "món này"]`.
2. Sub-metrics (nhỏ hơn): `35,2 giờ làm` · `20% thu nhập tháng` (ẩn dòng nào null).
3. Microcopy ngữ cảnh (lấy từ `07_COPY_VI.md` qua `result_phrasing.dart`): tùy mức nặng/sale.
4. **CTA hàng ngang, KHÔNG phán xét:**
   - Mua (đánh dấu bought)
   - Để mai tính (→ chọn mốc nhắc → tạo card sleepOnIt)
   - Bỏ qua (→ skipped; nếu chưa là card thì chỉ hiện microcopy "sống sót impulse buy")
   - Lưu vào Calendar (→ Crush Card Editor)
5. Nút phụ: "Tạo Save Card".

**Trạng thái:** nếu price không hợp lệ hoặc chưa có income → màn lỗi nhẹ, điều hướng phù hợp (không hiện NaN).

---

## S3. Crush Card Editor — `/crush/new` và sửa tại `/crush/:id`

**Mục tiêu:** lưu món muốn mua kèm ảnh + lý do + mốc nhắc.

**Thành phần:**
- Ảnh: chụp / chọn thư viện / dán screenshot (Phase 4 OCR). Có thể bỏ trống.
- Tên món (optional), Giá (bắt buộc, mặc định lấy từ result), Category (optional, preset + tự do).
- Hiển thị lại snapshot: ngày lương / giờ / %.
- **FOMO Check:** "Vì sao bạn muốn mua món này?" → chips chọn `CrushReason`.
- (Phase 2) Mood lúc muốn mua.
- **Chọn mốc nhắc:** chips `ReminderPreset` (Tối nay / 24h / 3 ngày / 7 ngày / Tới ngày lương / Chọn ngày).
- Nút Lưu.

**Điều hướng:** Lưu → ghi DB, đặt local notification theo `remindAt` → `/calendar` hoặc back.

---

## S4. Crush Calendar — `/calendar` (3 tab)

**Mục tiêu:** nhìn lại các món đang chờ quyết định, ở thời điểm tỉnh hơn. KHÔNG phải lịch chi tiêu.

**Tab Today:** các món `remindAt` hôm nay — hiển thị giờ + "Còn mê [tên]?" (hoặc private nếu noti_detail tắt thì trong app vẫn hiện được).

**Tab Upcoming:** nhóm theo "Ngày mai", "3 ngày nữa"... liệt kê tên món.

**Tab Month:** lịch tháng, chỉ chấm nhỏ ở ngày có món cần nhắc. **Không** hiện tên/giá/ngày lương ở overview (privacy).

**Thành phần phụ:** filter theo trạng thái (Đang treo / Hết mê / Đã mua / Tất cả). Mỗi item → tap mở `/crush/:id`.

---

## S5. "Còn mê không?" — `/crush/:id/still`

**Mục tiêu:** khoảnh khắc quyết định lại sau cooldown. Thường mở từ notification.

**Thành phần:**
- Ảnh món (nếu có) + tên + **số ngày lương snapshot** lại lớn.
- Nếu có `reason`: "X ngày trước bạn muốn mua vì: [reason]."
- Câu hỏi: **"Còn mê không?"**
- Lựa chọn: Vẫn mê / Hết mê rồi / Chờ sale / Mua rồi / Nhắc lại lần nữa / Xóa.

**Điều hướng theo lựa chọn:**
- Vẫn mê → status `stillCrushing` (có thể gợi ý đặt nhắc tiếp).
- Hết mê → status `overIt` → microcopy anti-haul "+X ngày lương còn sống".
- Chờ sale → `waitingForSale`.
- Mua rồi → `bought`.
- Nhắc lại → chọn mốc mới, `remindCount++`, đặt lại noti.
- Xóa → xóa card + ảnh + hủy noti.

---

## S6. Save Card — `/save-card`

**Mục tiêu:** xuất ảnh chia sẻ được, KHÔNG lộ lương gốc.

**Thành phần:**
- Preview card tỉ lệ **9:16** (tối ưu story/TikTok).
- Nội dung mẫu: "Món này = 4,4 ngày đi làm — Để mai tính." / "Sale 50% nhưng vẫn là 2,1 ngày lương." / "Tôi vừa không mua món này. +3,4 ngày lương còn sống."
- Chọn vài mẫu (MVP: 2–3 mẫu). Render bằng RepaintBoundary → PNG.
- Nút: Lưu vào ảnh / Chia sẻ.
- **Không** hiển thị thu nhập gốc trên card.

---

## S7. Settings — `/settings`

**Thành phần:**
- Sửa thu nhập (mở lại onboarding mode).
- Ngày lương trong tháng (payday_day, mặc định 5).
- App lock (Face ID / vân tay) — toggle.
- Notification detail mode (mặc định tắt = private).
- Mascot ví on/off (Phase 2).
- Theme (light/dark/system).
- **Xóa toàn bộ dữ liệu** (xác nhận 2 bước) — xóa DB, ảnh, secure storage.
- Link chính sách privacy (text tĩnh).

---

## Widget (Phase 1.5) — không phải route, là home-screen widget

- **W1 Quick Price Check:** "Món này tốn mấy ngày lương?" → tap mở thẳng S1 (price input focus).
- **W2 Preset Price:** 99k / 199k / 499k / 999k / Khác → tap hiện ngay số ngày lương (deep link tới S2).
- **W3 Private Crush Reminder:** mặc định "Có 1 món đang chờ bạn xem lại." (detail mode mới hiện tên/ngày lương).
- **W4 Reminder Quote (Phase 2):** câu nhắc đổi mỗi ngày.

Widget tuyệt đối không hiện: thu nhập, lương ngày/giờ, "tiền còn lại", ảnh món (ở chế độ mặc định).
