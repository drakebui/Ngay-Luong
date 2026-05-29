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
  String get notiDefaultTitle => 'Còn mê không?';

  @override
  String get notiDefaultBody => 'Có một món đang chờ bạn xem lại.';

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
}
