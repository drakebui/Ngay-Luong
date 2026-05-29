# 01 — PRD: Ngày Lương

## 1. Mục tiêu sản phẩm

Giúp người dùng (Gen Z / người đi làm tại VN) **dừng lại 1 nhịp trước khi mua** bằng cách quy đổi giá món đồ thành **số ngày đi làm**. App tạo cảm giác chi phí thật của một quyết định mua, một cách riêng tư, nhanh, không phán xét.

**Một câu định vị:** "Trước khi mua, xem món này lấy của bạn bao nhiêu ngày đi làm."

## 2. Mục tiêu của MVP

Kiểm chứng 2 giả thuyết:
1. Hook "món này = X ngày lương" đủ mạnh để người dùng quay lại.
2. Loop "Để mai tính → Còn mê không?" thực sự giảm impulse buy.

MVP **không** tối ưu doanh thu. Ưu tiên: hoạt động đúng, nhanh, riêng tư, retention.

## 3. Personas (tóm tắt — chi tiết ở brief gốc)

- **P1 — Gen Z mới đi làm:** thu nhập 8–18tr, mua nhiều qua Shopee/TikTok Shop, dễ impulse, cần công cụ nhanh & vui.
- **P2 — Đi làm 2–5 năm:** thu nhập ổn hơn, dễ lifestyle inflation, muốn tiêu có ý thức nhưng không bị kiểm soát.
- **P3 — Freelancer/thu nhập biến động:** tính theo giờ/ngày/dự án, muốn quy đổi ra số giờ billable.

Hệ quả kỹ thuật: **onboarding thu nhập phải hỗ trợ 4 mode** (tháng / ngày / giờ / dự án). Xem `04_CALCULATIONS.md`.

## 4. Core value — 5 câu hỏi app trả lời

1. Món này = bao nhiêu **ngày lương**? (hero)
2. Món này = bao nhiêu **giờ làm**?
3. Món này = bao nhiêu **% thu nhập tháng**?
4. (Phase 3) Nếu dùng nhiều lần, **cost-per-use** là bao nhiêu?
5. Nên mua ngay hay **để mai tính**?

## 5. Phạm vi MVP (Phase 1)

### IN — Must have
- Onboarding thu nhập (4 mode), lưu local (secure storage), không login.
- **Quick Check**: nhập giá → ra `ngày lương / giờ làm / % thu nhập tháng`.
- **Photo Crush Card**: chụp/chọn ảnh + tên + giá + lý do/mood (optional) → lưu thành card.
- **Decision**: Mua / Để mai tính / Bỏ qua / Lưu Crush Calendar.
- **Sleep-on-it Reminder**: chọn mốc nhắc (tối nay / 24h / 3 ngày / 7 ngày / tới ngày lương / chọn ngày) → local notification.
- **Crush Calendar**: Today / Upcoming / Month view; trạng thái từng món.
- **"Còn mê không?"**: tới hạn → mở lại card → user chọn Vẫn mê / Hết mê / Chờ sale / Mua rồi / Nhắc lại.
- **Save Card** cơ bản (xuất ảnh 9:16, KHÔNG hiện lương gốc).
- **App lock** (Face ID / vân tay) — đặt trong free tier vì dữ liệu nhạy cảm.
- Xóa toàn bộ dữ liệu (settings).

### IN — Phase 1.5 (ngay sau MVP)
- Widget: Quick Check, Preset Price (99k/199k/499k/999k), Private Crush Reminder.

### LATER — Phase 2 (Gen Z layer)
- FOMO Check nâng cao, Mood Check, **Anti-haul recap cá nhân**, Mascot ví (optional/tắt được), nhiều mẫu Save Card, reminder copy cá nhân hóa, **Salary Day Mode** (chủ động prompt quanh ngày lương).

### LATER — Phase 3 (Worth Check)
- Cost-per-use, "số lần dùng để thấy đáng", compare 2 món, giá mục tiêu / chờ sale, ghi chú lý do.

### LATER — Phase 4 (Shopping workflow)
- Share screenshot từ Shopee/Lazada/TikTok Shop sang app, OCR lấy giá, AI nhận diện tên món, browser extension.

### OUT — Không bao giờ (trong định hướng hiện tại)
- Budget tracker / money manager / sổ thu chi / báo cáo dòng tiền.
- Màn "còn bao nhiêu tiền", cảnh báo ngân sách, phân bổ lương.
- Liên kết ngân hàng (MVP).
- Social feed, gửi bạn vote, couple/bestie mode, leaderboard, group no-buy challenge.
- AI phân tích tâm lý / lời khuyên trị liệu.

## 6. Decision state machine của một Crush Card

```
                 ┌──────────────┐
   Quick Check → │   crushing   │ (Đang mê)
                 └──────┬───────┘
        ┌───────────────┼───────────────┬───────────────┐
        ▼               ▼               ▼               ▼
     bought         sleepOnIt        skipped      waitingForSale
    (Đã mua)      (Để mai tính)    (Đã bỏ qua)     (Chờ sale)
                       │
              [reminder fires: "Còn mê không?"]
                       │
        ┌──────────────┼──────────────┬──────────────┐
        ▼              ▼              ▼              ▼
   stillCrushing    overIt        bought      (snooze → đặt remindAt mới)
   (Vẫn mê)       (Hết mê)      (Mua rồi)
```

- `overIt` và `skipped` cộng dồn vào **Anti-haul** ("số ngày lương không bay màu").
- Chuyển trạng thái phải cập nhật `updatedAt` và (nếu cần) hủy/đặt lại notification.

## 7. Thước đo thành công (để biết hướng phát triển, không cần code dashboard ở MVP)

- Activation: % hoàn thành onboarding; time-to-first-result; % lưu card đầu tiên.
- Engagement: số check/tuần; % dùng "Để mai tính"; % quay lại sau reminder; % mở Calendar; % dùng widget.
- Decision outcome: % "hết mê" sau reminder; tổng ngày lương đã "không bay màu".

## 8. Rủi ro sản phẩm & cách xử lý (ảnh hưởng tới implementation)

| Rủi ro | Xử lý trong code/UX |
|---|---|
| Sợ nhập thu nhập | Cho nhập theo ngày/giờ; secure storage; copy trấn an rõ ràng; không login |
| Bị hiểu là app chi tiêu | Không có từ "budget"; không màn "còn bao nhiêu tiền"; copy luôn xoay quanh "thời gian đi làm" |
| Retention thấp | Crush Calendar + reminder + widget + anti-haul recap |
| Tone gây guilt | Dùng đúng copy ở `07_COPY_VI.md`; có trạng thái "mua xứng đáng" để cân bằng |
| Ảnh nhạy cảm | Ảnh local-first; không hiện trên noti/widget mặc định; cho xóa; cho lưu card không ảnh; app lock |
