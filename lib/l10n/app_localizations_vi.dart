// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get onboardingTitle => 'Bạn kiếm tiền thế nào?';

  @override
  String get onboardingModeMonthly => 'Theo tháng';

  @override
  String get onboardingModeDaily => 'Theo ngày';

  @override
  String get onboardingModeHourly => 'Theo giờ';

  @override
  String get onboardingModeProject => 'Theo dự án';

  @override
  String get onboardingModeMonthlyDesc => 'Nhận lương cố định hàng tháng';

  @override
  String get onboardingModeDailyDesc => 'Thanh toán theo ngày công';

  @override
  String get onboardingModeHourlyDesc => 'Tính theo giờ làm việc';

  @override
  String get onboardingModeProjectDesc => 'Thu nhập theo từng dự án';

  @override
  String get onboardingMonthlyIncome => 'Thu nhập net mỗi tháng';

  @override
  String get onboardingWorkDays => 'Số ngày làm / tháng';

  @override
  String get onboardingWorkHours => 'Số giờ làm / ngày';

  @override
  String get onboardingDailyIncome => 'Thu nhập mỗi ngày';

  @override
  String get onboardingHourlyIncome => 'Thu nhập mỗi giờ';

  @override
  String get onboardingProjectIncome => 'Thu nhập dự án';

  @override
  String get onboardingProjectHours => 'Tổng số giờ làm';

  @override
  String get onboardingProjectDays => 'Tổng số ngày làm';

  @override
  String get onboardingCustomize => 'Tùy chỉnh ngày/giờ làm';

  @override
  String get onboardingDone => 'Xong';

  @override
  String get onboardingSkip => 'Để sau';

  @override
  String get onboardingCurrencySuffix => 'đ';

  @override
  String get onboardingDaySuffix => 'ngày';

  @override
  String get onboardingHourSuffix => 'giờ';

  @override
  String get onboardingLivePreviewLabel => 'GIÁ TRỊ 1 GIỜ CỦA BẠN';

  @override
  String get onboardingSaveError => 'Chưa lưu được hồ sơ. Thử lại nhé.';

  @override
  String get privacyOnboarding =>
      'Thu nhập của bạn chỉ dùng để tính trên máy. Mình không cần biết bạn kiếm bao nhiêu.';

  @override
  String get privacyImages =>
      'Ảnh món đồ và Crush Calendar nằm trong máy bạn. Mặc định không gửi đi đâu cả.';

  @override
  String get privacyDeleteConfirm => 'Xóa toàn bộ dữ liệu? Không thể hoàn tác.';

  @override
  String get homePriceHint => 'Món này giá bao nhiêu?';

  @override
  String get homeCheck => 'Xem mấy ngày lương';

  @override
  String get homeShortcutPhoto => 'Chụp món đồ';

  @override
  String get homeShortcutCalendar => 'Crush Calendar';

  @override
  String get homeNeedIncome =>
      'Cho mình biết thu nhập trước đã, để tính ngày lương nhé.';

  @override
  String get resultHeroUnit => 'ngày đi làm';

  @override
  String get resultHeroSubGeneric => 'để mua món này';

  @override
  String resultHeroSubNamed(String name) {
    return 'để mua $name';
  }

  @override
  String resultSubHours(String hours) {
    return '$hours giờ làm';
  }

  @override
  String resultSubPct(String pct) {
    return '$pct thu nhập tháng';
  }

  @override
  String resultMsgNormal(String days) {
    return 'Món này lấy của bạn $days ngày đi làm.';
  }

  @override
  String resultMsgHeavy(String price, String days) {
    return 'Bạn không trả $price. Bạn trả bằng $days ngày đi làm.';
  }

  @override
  String resultMsgOnSale(String days) {
    return 'Sale không làm nó miễn phí. Nó vẫn là $days ngày lương.';
  }

  @override
  String resultMsgTiny(String days) {
    return 'Nhỏ thôi — khoảng $days ngày đi làm.';
  }

  @override
  String get decisionBuy => 'Mua';

  @override
  String get decisionBought => 'Chúc mừng! Bạn xứng đáng.';

  @override
  String get decisionSleepOnIt => 'Để mai tính';

  @override
  String get decisionSkip => 'Bỏ qua';

  @override
  String get decisionSaveToCalendar => 'Lưu vào Calendar';

  @override
  String get decisionSavedToCalendar =>
      'Đã cất vào Crush Calendar. Mai xem còn mê không.';

  @override
  String get decisionSkipped => 'Ví bạn vừa sống sót qua một cú impulse buy.';

  @override
  String get decisionStillWantAfterCooldown =>
      'Vẫn mê sau 24h? Có thể món này đáng cân nhắc.';

  @override
  String get fomoQuestion => 'Vì sao bạn muốn mua món này?';

  @override
  String fomoRecall(int n, String reason) {
    return '$n ngày trước bạn muốn mua vì: \"$reason\". Giờ còn mê không?';
  }

  @override
  String get crushEditorNewTitle => 'Lưu món';

  @override
  String get crushEditorEditTitle => 'Sửa món';

  @override
  String get crushEditorSave => 'Lưu';

  @override
  String get crushEditorNameLabel => 'Tên món (không bắt buộc)';

  @override
  String get crushEditorPriceLabel => 'Giá';

  @override
  String get crushEditorImageLabel => 'Ảnh món đồ';

  @override
  String get crushEditorPickGallery => 'Chọn ảnh';

  @override
  String get crushEditorPickCamera => 'Chụp ảnh';

  @override
  String get crushEditorRemoveImage => 'Xóa ảnh';

  @override
  String get crushEditorReminderLabel => 'Chọn mốc nhắc';

  @override
  String get crushEditorLoadError => 'Không tải được món này.';

  @override
  String get crushEditorMissingArgs => 'Thiếu dữ liệu để lưu món.';

  @override
  String get crushEditorSaveError => 'Chưa lưu được món. Thử lại nhé.';

  @override
  String get remindTonight => 'Tối nay';

  @override
  String get remindAfter24h => 'Sau 24 giờ';

  @override
  String get remindAfter3Days => 'Sau 3 ngày';

  @override
  String get remindAfter7Days => 'Sau 7 ngày';

  @override
  String get remindUntilPayday => 'Đợi tới ngày lương';

  @override
  String get remindCustom => 'Chọn ngày khác';

  @override
  String get calendarTitle => 'Crush Calendar';

  @override
  String get calendarToday => 'Hôm nay';

  @override
  String get calendarUpcoming => 'Sắp tới';

  @override
  String get calendarMonth => 'Tháng';

  @override
  String get calendarFilterPending => 'Đang treo';

  @override
  String get calendarFilterOverIt => 'Hết mê';

  @override
  String get calendarFilterBought => 'Đã mua';

  @override
  String get calendarFilterAll => 'Tất cả';

  @override
  String get calendarEmptyToday => 'Hôm nay chưa có món nào cần xem lại.';

  @override
  String get calendarEmptyUpcoming => 'Chưa có món nào đang chờ ngày nhắc.';

  @override
  String get calendarEmptyMonth => 'Tháng này chưa có mốc nhắc nào.';

  @override
  String get calendarUnnamedItem => 'món này';

  @override
  String calendarItemQuestion(String name) {
    return 'Còn mê $name?';
  }

  @override
  String get calendarTomorrow => 'Ngày mai';

  @override
  String calendarInDays(int count) {
    return '$count ngày nữa';
  }

  @override
  String get notiDefaultTitle => 'Còn mê không?';

  @override
  String get notiDefaultBody => 'Mở app xem lại.';

  @override
  String notiDetailNamed(String name) {
    return 'Còn mê $name không?';
  }

  @override
  String notiDetailDays(String days) {
    return 'Món này từng lấy của bạn $days ngày đi làm.';
  }

  @override
  String get stillQuestion => 'Còn mê không?';

  @override
  String get stillStillCrushing => 'Vẫn mê';

  @override
  String get stillOverIt => 'Hết mê rồi';

  @override
  String get stillWaitingForSale => 'Chờ sale';

  @override
  String get stillBought => 'Mua rồi';

  @override
  String get stillRemindAgain => 'Nhắc lại lần nữa';

  @override
  String get stillDelete => 'Xóa món này';

  @override
  String stillOverItCheer(String days) {
    return '+$days ngày lương còn sống.';
  }

  @override
  String get stillScreenHeroUnit => 'ngày đi làm';

  @override
  String get stillScreenQuestion => 'Còn mê không?';

  @override
  String stillScreenBoughtDaysAgo(int days) {
    return 'Bạn muốn mua món này $days ngày trước.';
  }

  @override
  String stillScreenReasonLabel(String reason) {
    return 'Lúc đó bạn thích vì: $reason.';
  }

  @override
  String stillScreenSavedDays(String days) {
    return '+$days ngày lương còn sống';
  }

  @override
  String get stillScreenBtnStillCrushing => 'Vẫn mê';

  @override
  String get stillScreenBtnOverIt => 'Hết mê rồi';

  @override
  String get stillScreenBtnWaitingSale => 'Chờ sale';

  @override
  String get stillScreenBtnBought => 'Mua rồi';

  @override
  String get stillScreenBtnRemindAgain => 'Nhắc lại lần nữa';

  @override
  String get stillScreenBtnDelete => 'Xóa';

  @override
  String cardSleepOnIt(String days) {
    return 'Món này = $days ngày đi làm.\nĐể mai tính.';
  }

  @override
  String cardOnSale(String percent, String days) {
    return 'Sale $percent%\nnhưng vẫn là $days ngày đi làm.';
  }

  @override
  String cardSkipped(String days) {
    return 'Tôi vừa không mua món này.\n+$days ngày lương còn sống.';
  }

  @override
  String get cardShare => 'Chia sẻ';

  @override
  String get cardSave => 'Lưu vào ảnh';

  @override
  String get settingsEditIncome => 'Sửa thu nhập';

  @override
  String get settingsPayday => 'Ngày lương trong tháng';

  @override
  String get settingsAppLock => 'Khóa app (Face ID / vân tay)';

  @override
  String get settingsNotiDetail => 'Hiện chi tiết trong thông báo';

  @override
  String get settingsMascot => 'Bật mascot ví';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsDeleteAll => 'Xóa toàn bộ dữ liệu';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get settingsBiometricsUnavailable =>
      'Thiết bị chưa thiết lập Face ID / vân tay.';

  @override
  String get settingsEnableLockReason => 'Bật khóa app để bảo vệ Ngày Lương.';

  @override
  String get settingsDeleteConfirm2Title => 'Bạn chắc chứ?';

  @override
  String get settingsDeleteConfirm2Body =>
      'Sau bước này, mình không khôi phục lại được dữ liệu cho bạn.';

  @override
  String get settingsDeleteDone => 'Đã xóa toàn bộ dữ liệu.';

  @override
  String get lockTitle => 'Ngày Lương đang khóa';

  @override
  String get lockSubtitle => 'Xác thực để mở app.';

  @override
  String get lockUnlock => 'Mở khóa';

  @override
  String get lockReason => 'Mở khóa Ngày Lương';

  @override
  String get saveCardTitle => 'Tạo Save Card';

  @override
  String saveCardSaved(String path) {
    return 'Đã lưu Save Card: $path';
  }

  @override
  String get saveCardTemplateSleepOnIt => 'Để mai tính';

  @override
  String get saveCardTemplateOnSale => 'Sale gì cũng vẫn lương';

  @override
  String get saveCardTemplateSkipped => 'Đã không mua';

  @override
  String cardPayday(String days) {
    return 'Lương về rồi.\nVẫn còn mê $days ngày đi làm này không?';
  }

  @override
  String cardAntiHaulCelebration(int count, String days) {
    return 'Tôi đã không mua $count món.\n+$days ngày lương còn sống.';
  }

  @override
  String get saveCardTemplatePayday => 'Ngày lương';

  @override
  String get saveCardTemplateAntiHaulCelebration => 'Ăn mừng anti-haul';

  @override
  String get crushEditorMoodLabel => 'Tâm trạng lúc này';

  @override
  String get moodExcited => 'Hào hứng';

  @override
  String get moodBored => 'Chán chán';

  @override
  String get moodStressed => 'Căng thẳng';

  @override
  String get moodHappy => 'Vui';

  @override
  String get moodTired => 'Mệt';

  @override
  String get moodNeutral => 'Bình thường';

  @override
  String get moodImpulsive => 'Bốc đồng';

  @override
  String fomoRecallReason(int n, String reason) {
    return '$n ngày trước bạn muốn mua vì: "${reason}". Giờ còn mê không?';
  }

  @override
  String get notiRecallPool1 => 'Mở app xem lại.';

  @override
  String get notiRecallPool2 => 'Cho mình thêm một nhịp dừng nhé.';

  @override
  String get notiRecallPool3 => 'Giờ còn mê không?';

  @override
  String get notiRecallPool4 => 'Mở app xem cảm giác còn như cũ không.';

  @override
  String antihaulWeekly(int count, String days) {
    return 'Tuần này bạn đã hết mê $count món. +$days ngày lương còn sống.';
  }

  @override
  String antihaulMonthly(int count, String days) {
    return 'Tháng này bạn đã hết mê $count món. +$days ngày lương còn sống.';
  }

  @override
  String get paydayPromptTitle =>
      'Lương vừa về. Có món nào đang chờ bạn mua không?';

  @override
  String get paydayBannerAction => 'Xem Crush';

  @override
  String mascotSawDaysFly(String days) {
    return 'Tôi vừa thấy $days ngày lương bay qua cửa sổ.';
  }

  @override
  String get mascotSurvived => 'Tôi sống rồi.';

  @override
  String get settingsMascotTitle => 'Bật mascot ví';
}
