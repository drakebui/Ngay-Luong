# 07 — Copy tiếng Việt (nguồn string chuẩn)

> Đây là NGUỒN string tiếng Việt duy nhất. Agent KHÔNG tự chế string mới mà không thêm vào đây.
> Nên đưa vào `lib/l10n/app_vi.arb` (key = tên dưới đây). Tone: gần gũi, vui, hơi "đau ví", KHÔNG phán xét.

---

## 1. Nguyên tắc tone

- Giống một người bạn riêng tư trong điện thoại, không phải cố vấn tài chính.
- Self-roast vui được; lecture thì không.
- Không bao giờ dùng: "bạn tiêu hoang", "bạn không nên mua", "đây là quyết định sai", "bạn đang lãng phí", "bạn không đủ khả năng".
- Luôn xoay quanh "thời gian đi làm", không nói "ngân sách/số dư".

---

## 2. Onboarding

- `onboarding.title` = "Bạn kiếm tiền thế nào?"
- `onboarding.modeMonthly` = "Theo tháng"
- `onboarding.modeDaily` = "Theo ngày"
- `onboarding.modeHourly` = "Theo giờ"
- `onboarding.modeProject` = "Theo dự án"
- `onboarding.monthlyIncome` = "Thu nhập net mỗi tháng"
- `onboarding.workDays` = "Số ngày làm / tháng"
- `onboarding.workHours` = "Số giờ làm / ngày"
- `onboarding.dailyIncome` = "Thu nhập mỗi ngày"
- `onboarding.hourlyIncome` = "Thu nhập mỗi giờ"
- `onboarding.projectIncome` = "Thu nhập dự án"
- `onboarding.projectHours` = "Tổng số giờ làm"
- `onboarding.projectDays` = "Tổng số ngày làm"
- `onboarding.customize` = "Tùy chỉnh ngày/giờ làm"
- `onboarding.done` = "Xong"
- `onboarding.skip` = "Để sau"

## 3. Privacy

- `privacy.onboarding` = "Thu nhập của bạn chỉ dùng để tính trên máy. Mình không cần biết bạn kiếm bao nhiêu."
- `privacy.images` = "Ảnh món đồ và Crush Calendar nằm trong máy bạn. Mặc định không gửi đi đâu cả."
- `privacy.deleteConfirm` = "Xóa toàn bộ dữ liệu? Không thể hoàn tác."

## 4. Quick Check / Home

- `home.priceHint` = "Món này giá bao nhiêu?"
- `home.check` = "Xem mấy ngày lương"
- `home.shortcutPhoto` = "Chụp món đồ"
- `home.shortcutCalendar` = "Crush Calendar"
- `home.needIncome` = "Cho mình biết thu nhập trước đã, để tính ngày lương nhé."

## 5. Result (hero + microcopy)

- `result.heroUnit` = "ngày đi làm"
- `result.heroSubGeneric` = "để mua món này"
- `result.heroSubNamed` = "để mua {name}"   // {name} = tên món
- `result.subHours` = "{hours} giờ làm"
- `result.subPct` = "{pct} thu nhập tháng"

Microcopy theo ngữ cảnh (chọn trong `result_phrasing.dart`):
- `result.msgNormal` = "Món này lấy của bạn {days} ngày đi làm."
- `result.msgHeavy` = "Bạn không trả {price}. Bạn trả bằng {days} ngày đi làm."   // khi % tháng cao / nhiều ngày
- `result.msgOnSale` = "Sale không làm nó miễn phí. Nó vẫn là {days} ngày lương."
- `result.msgTiny` = "Nhỏ thôi — khoảng {days} ngày đi làm."   // khi < 0,3 ngày

## 6. Decision

- `decision.buy` = "Mua"
- `decision.sleepOnIt` = "Để mai tính"
- `decision.skip` = "Bỏ qua"
- `decision.saveToCalendar` = "Lưu vào Calendar"
- `decision.savedToCalendar` = "Đã cất vào Crush Calendar. Mai xem còn mê không."
- `decision.skipped` = "Ví bạn vừa sống sót qua một cú impulse buy."
- `decision.stillWantAfterCooldown` = "Vẫn mê sau 24h? Có thể món này đáng cân nhắc."

## 7. FOMO Check (reason)

- `fomo.question` = "Vì sao bạn muốn mua món này?"
- reason labels: xem enum `CrushReason` trong `crush_models.dart`
  (Cần thật / Đang sale / Thấy review / TikTok làm tôi yếu lòng / Tự thưởng / Stress / Không biết nữa, thấy thích)
- `fomo.recall` = "{n} ngày trước bạn muốn mua vì: \"{reason}\". Giờ còn mê không?"

## 8. Reminder presets

- `remind.tonight` = "Tối nay"
- `remind.after24h` = "Sau 24 giờ"
- `remind.after3Days` = "Sau 3 ngày"
- `remind.after7Days` = "Sau 7 ngày"
- `remind.untilPayday` = "Đợi tới ngày lương"
- `remind.custom` = "Chọn ngày khác"

## 9. Notification (mặc định private)

- `noti.defaultTitle` = "Còn mê không?"
- `noti.defaultBody` = "Có một món đang chờ bạn xem lại."
- Detail mode (chỉ khi `noti_detail_mode = true`):
  - `noti.detailNamed` = "Còn mê {name} không?"
  - `noti.detailDays` = "Món này từng lấy của bạn {days} ngày đi làm."
- Câu nhắc thay phiên (random pool):
  - "Hôm qua bạn muốn mua món này. Nay còn muốn không?"
  - "Sale có thể hết, nhưng ngày lương cũng vậy."
  - "Mở lại xem còn yêu không."
  - "Đã đến giờ tỉnh ví."

## 10. "Còn mê không?" screen

- `still.question` = "Còn mê không?"
- `still.stillCrushing` = "Vẫn mê"
- `still.overIt` = "Hết mê rồi"
- `still.waitingForSale` = "Chờ sale"
- `still.bought` = "Mua rồi"
- `still.remindAgain` = "Nhắc lại lần nữa"
- `still.delete` = "Xóa món này"
- `still.overItCheer` = "+{days} ngày lương còn sống."

## 11. Anti-haul recap (Phase 2)

- `antihaul.weekly` = "Tuần này bạn đã hết mê {count} món. Tổng cộng = {days} ngày đi làm không bay màu."
- `antihaul.monthly` = "Tháng này bạn đã không mua {count} món, để dành được {days} ngày đi làm."

## 12. Cost-per-use / Worth Check (Phase 3)

- `worth.expectedUses` = "Bạn nghĩ sẽ dùng bao nhiêu lần?"
- `worth.costPerUse` = "Khoảng {amount} / lần dùng."
- `worth.goodValue` = "Đắt lúc mua, nhưng nếu dùng đủ nhiều thì không tệ."
- `worth.poorValue` = "Nếu chỉ dùng vài lần, mỗi lần dùng hơi đau."
- `worth.usesToWorth` = "Cần dùng khoảng {n} lần để xuống mức {amount}/lần."

## 13. Save Card (mẫu nội dung)

- `card.sleepOnIt` = "Món này = {days} ngày đi làm.\nĐể mai tính."
- `card.onSale` = "Sale {percent}%\nnhưng vẫn là {days} ngày đi làm."
- `card.skipped` = "Tôi vừa không mua món này.\n+{days} ngày lương còn sống."
- `card.share` = "Chia sẻ"
- `card.save` = "Lưu vào ảnh"

## 14. Salary Day Mode (Phase 2)

- `payday.prompt` = "Lương vừa về. Có món nào đang chờ bạn mua không?"

## 15. Mascot ví (Phase 2, optional)

- `mascot.sawDaysFly` = "Tôi vừa thấy {days} ngày lương bay qua cửa sổ."
- `mascot.survived` = "Tôi sống rồi."
- Tên đề xuất: Bé Ví / Phanh Ví / Lương Lương (cho user chọn).

## 16. Settings

- `settings.editIncome` = "Sửa thu nhập"
- `settings.payday` = "Ngày lương trong tháng"
- `settings.appLock` = "Khóa app (Face ID / vân tay)"
- `settings.notiDetail` = "Hiện chi tiết trong thông báo"
- `settings.mascot` = "Bật mascot ví"
- `settings.theme` = "Giao diện"
- `settings.deleteAll` = "Xóa toàn bộ dữ liệu"
