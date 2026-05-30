import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('vi')];

  /// No description provided for @onboardingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn kiếm tiền thế nào?'**
  String get onboardingTitle;

  /// No description provided for @onboardingModeMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Theo tháng'**
  String get onboardingModeMonthly;

  /// No description provided for @onboardingModeDaily.
  ///
  /// In vi, this message translates to:
  /// **'Theo ngày'**
  String get onboardingModeDaily;

  /// No description provided for @onboardingModeHourly.
  ///
  /// In vi, this message translates to:
  /// **'Theo giờ'**
  String get onboardingModeHourly;

  /// No description provided for @onboardingModeProject.
  ///
  /// In vi, this message translates to:
  /// **'Theo dự án'**
  String get onboardingModeProject;

  /// No description provided for @onboardingModeMonthlyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận lương cố định hàng tháng'**
  String get onboardingModeMonthlyDesc;

  /// No description provided for @onboardingModeDailyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán theo ngày công'**
  String get onboardingModeDailyDesc;

  /// No description provided for @onboardingModeHourlyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tính theo giờ làm việc'**
  String get onboardingModeHourlyDesc;

  /// No description provided for @onboardingModeProjectDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập theo từng dự án'**
  String get onboardingModeProjectDesc;

  /// No description provided for @onboardingMonthlyIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập net mỗi tháng'**
  String get onboardingMonthlyIncome;

  /// No description provided for @onboardingWorkDays.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày làm / tháng'**
  String get onboardingWorkDays;

  /// No description provided for @onboardingWorkHours.
  ///
  /// In vi, this message translates to:
  /// **'Số giờ làm / ngày'**
  String get onboardingWorkHours;

  /// No description provided for @onboardingDailyIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập mỗi ngày'**
  String get onboardingDailyIncome;

  /// No description provided for @onboardingHourlyIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập mỗi giờ'**
  String get onboardingHourlyIncome;

  /// No description provided for @onboardingProjectIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập dự án'**
  String get onboardingProjectIncome;

  /// No description provided for @onboardingProjectHours.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số giờ làm'**
  String get onboardingProjectHours;

  /// No description provided for @onboardingProjectDays.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số ngày làm'**
  String get onboardingProjectDays;

  /// No description provided for @onboardingCustomize.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh ngày/giờ làm'**
  String get onboardingCustomize;

  /// No description provided for @onboardingDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get onboardingDone;

  /// No description provided for @onboardingSkip.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get onboardingSkip;

  /// No description provided for @onboardingCurrencySuffix.
  ///
  /// In vi, this message translates to:
  /// **'đ'**
  String get onboardingCurrencySuffix;

  /// No description provided for @onboardingDaySuffix.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get onboardingDaySuffix;

  /// No description provided for @onboardingHourSuffix.
  ///
  /// In vi, this message translates to:
  /// **'giờ'**
  String get onboardingHourSuffix;

  /// No description provided for @privacyOnboarding.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập của bạn chỉ dùng để tính trên máy. Mình không cần biết bạn kiếm bao nhiêu.'**
  String get privacyOnboarding;

  /// No description provided for @privacyImages.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh món đồ và Crush Calendar nằm trong máy bạn. Mặc định không gửi đi đâu cả.'**
  String get privacyImages;

  /// No description provided for @privacyDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ dữ liệu? Không thể hoàn tác.'**
  String get privacyDeleteConfirm;

  /// No description provided for @homePriceHint.
  ///
  /// In vi, this message translates to:
  /// **'Món này giá bao nhiêu?'**
  String get homePriceHint;

  /// No description provided for @homeCheck.
  ///
  /// In vi, this message translates to:
  /// **'Xem mấy ngày lương'**
  String get homeCheck;

  /// No description provided for @homeShortcutPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp món đồ'**
  String get homeShortcutPhoto;

  /// No description provided for @homeShortcutCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Crush Calendar'**
  String get homeShortcutCalendar;

  /// No description provided for @homeNeedIncome.
  ///
  /// In vi, this message translates to:
  /// **'Cho mình biết thu nhập trước đã, để tính ngày lương nhé.'**
  String get homeNeedIncome;

  /// No description provided for @resultHeroUnit.
  ///
  /// In vi, this message translates to:
  /// **'ngày đi làm'**
  String get resultHeroUnit;

  /// No description provided for @resultHeroSubGeneric.
  ///
  /// In vi, this message translates to:
  /// **'để mua món này'**
  String get resultHeroSubGeneric;

  /// No description provided for @resultHeroSubNamed.
  ///
  /// In vi, this message translates to:
  /// **'để mua {name}'**
  String resultHeroSubNamed(String name);

  /// No description provided for @resultSubHours.
  ///
  /// In vi, this message translates to:
  /// **'{hours} giờ làm'**
  String resultSubHours(String hours);

  /// No description provided for @resultSubPct.
  ///
  /// In vi, this message translates to:
  /// **'{pct} thu nhập tháng'**
  String resultSubPct(String pct);

  /// No description provided for @resultMsgNormal.
  ///
  /// In vi, this message translates to:
  /// **'Món này lấy của bạn {days} ngày đi làm.'**
  String resultMsgNormal(String days);

  /// No description provided for @resultMsgHeavy.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không trả {price}. Bạn trả bằng {days} ngày đi làm.'**
  String resultMsgHeavy(String price, String days);

  /// No description provided for @resultMsgOnSale.
  ///
  /// In vi, this message translates to:
  /// **'Sale không làm nó miễn phí. Nó vẫn là {days} ngày lương.'**
  String resultMsgOnSale(String days);

  /// No description provided for @resultMsgTiny.
  ///
  /// In vi, this message translates to:
  /// **'Nhỏ thôi — khoảng {days} ngày đi làm.'**
  String resultMsgTiny(String days);

  /// No description provided for @decisionBuy.
  ///
  /// In vi, this message translates to:
  /// **'Mua'**
  String get decisionBuy;

  /// No description provided for @decisionBought.
  ///
  /// In vi, this message translates to:
  /// **'Chúc mừng! Bạn xứng đáng.'**
  String get decisionBought;

  /// No description provided for @decisionSleepOnIt.
  ///
  /// In vi, this message translates to:
  /// **'Để mai tính'**
  String get decisionSleepOnIt;

  /// No description provided for @decisionSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get decisionSkip;

  /// No description provided for @decisionSaveToCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào Calendar'**
  String get decisionSaveToCalendar;

  /// No description provided for @decisionSavedToCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cất vào Crush Calendar. Mai xem còn mê không.'**
  String get decisionSavedToCalendar;

  /// No description provided for @decisionSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Ví bạn vừa sống sót qua một cú impulse buy.'**
  String get decisionSkipped;

  /// No description provided for @decisionStillWantAfterCooldown.
  ///
  /// In vi, this message translates to:
  /// **'Vẫn mê sau 24h? Có thể món này đáng cân nhắc.'**
  String get decisionStillWantAfterCooldown;

  /// No description provided for @fomoQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Vì sao bạn muốn mua món này?'**
  String get fomoQuestion;

  /// No description provided for @fomoRecall.
  ///
  /// In vi, this message translates to:
  /// **'{n} ngày trước bạn muốn mua vì: \"{reason}\". Giờ còn mê không?'**
  String fomoRecall(int n, String reason);

  /// No description provided for @crushEditorNewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu món'**
  String get crushEditorNewTitle;

  /// No description provided for @crushEditorEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa món'**
  String get crushEditorEditTitle;

  /// No description provided for @crushEditorSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get crushEditorSave;

  /// No description provided for @crushEditorNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên món (không bắt buộc)'**
  String get crushEditorNameLabel;

  /// No description provided for @crushEditorPriceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get crushEditorPriceLabel;

  /// No description provided for @crushEditorImageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh món đồ'**
  String get crushEditorImageLabel;

  /// No description provided for @crushEditorPickGallery.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get crushEditorPickGallery;

  /// No description provided for @crushEditorPickCamera.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get crushEditorPickCamera;

  /// No description provided for @crushEditorRemoveImage.
  ///
  /// In vi, this message translates to:
  /// **'Xóa ảnh'**
  String get crushEditorRemoveImage;

  /// No description provided for @crushEditorReminderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn mốc nhắc'**
  String get crushEditorReminderLabel;

  /// No description provided for @crushEditorLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được món này.'**
  String get crushEditorLoadError;

  /// No description provided for @crushEditorMissingArgs.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu dữ liệu để lưu món.'**
  String get crushEditorMissingArgs;

  /// No description provided for @crushEditorSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Chưa lưu được món. Thử lại nhé.'**
  String get crushEditorSaveError;

  /// No description provided for @remindTonight.
  ///
  /// In vi, this message translates to:
  /// **'Tối nay'**
  String get remindTonight;

  /// No description provided for @remindAfter24h.
  ///
  /// In vi, this message translates to:
  /// **'Sau 24 giờ'**
  String get remindAfter24h;

  /// No description provided for @remindAfter3Days.
  ///
  /// In vi, this message translates to:
  /// **'Sau 3 ngày'**
  String get remindAfter3Days;

  /// No description provided for @remindAfter7Days.
  ///
  /// In vi, this message translates to:
  /// **'Sau 7 ngày'**
  String get remindAfter7Days;

  /// No description provided for @remindUntilPayday.
  ///
  /// In vi, this message translates to:
  /// **'Đợi tới ngày lương'**
  String get remindUntilPayday;

  /// No description provided for @remindCustom.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày khác'**
  String get remindCustom;

  /// No description provided for @calendarTitle.
  ///
  /// In vi, this message translates to:
  /// **'Crush Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get calendarToday;

  /// No description provided for @calendarUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Sắp tới'**
  String get calendarUpcoming;

  /// No description provided for @calendarMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get calendarMonth;

  /// No description provided for @calendarFilterPending.
  ///
  /// In vi, this message translates to:
  /// **'Đang treo'**
  String get calendarFilterPending;

  /// No description provided for @calendarFilterOverIt.
  ///
  /// In vi, this message translates to:
  /// **'Hết mê'**
  String get calendarFilterOverIt;

  /// No description provided for @calendarFilterBought.
  ///
  /// In vi, this message translates to:
  /// **'Đã mua'**
  String get calendarFilterBought;

  /// No description provided for @calendarFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get calendarFilterAll;

  /// No description provided for @calendarEmptyToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay chưa có món nào cần xem lại.'**
  String get calendarEmptyToday;

  /// No description provided for @calendarEmptyUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có món nào đang chờ ngày nhắc.'**
  String get calendarEmptyUpcoming;

  /// No description provided for @calendarEmptyMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này chưa có mốc nhắc nào.'**
  String get calendarEmptyMonth;

  /// No description provided for @calendarUnnamedItem.
  ///
  /// In vi, this message translates to:
  /// **'món này'**
  String get calendarUnnamedItem;

  /// No description provided for @calendarItemQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Còn mê {name}?'**
  String calendarItemQuestion(String name);

  /// No description provided for @calendarTomorrow.
  ///
  /// In vi, this message translates to:
  /// **'Ngày mai'**
  String get calendarTomorrow;

  /// No description provided for @calendarInDays.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày nữa'**
  String calendarInDays(int count);

  /// No description provided for @notiDefaultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Còn mê không?'**
  String get notiDefaultTitle;

  /// No description provided for @notiDefaultBody.
  ///
  /// In vi, this message translates to:
  /// **'Mở app xem lại.'**
  String get notiDefaultBody;

  /// No description provided for @notiDetailNamed.
  ///
  /// In vi, this message translates to:
  /// **'Còn mê {name} không?'**
  String notiDetailNamed(String name);

  /// No description provided for @notiDetailDays.
  ///
  /// In vi, this message translates to:
  /// **'Món này từng lấy của bạn {days} ngày đi làm.'**
  String notiDetailDays(String days);

  /// No description provided for @stillQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Còn mê không?'**
  String get stillQuestion;

  /// No description provided for @stillStillCrushing.
  ///
  /// In vi, this message translates to:
  /// **'Vẫn mê'**
  String get stillStillCrushing;

  /// No description provided for @stillOverIt.
  ///
  /// In vi, this message translates to:
  /// **'Hết mê rồi'**
  String get stillOverIt;

  /// No description provided for @stillWaitingForSale.
  ///
  /// In vi, this message translates to:
  /// **'Chờ sale'**
  String get stillWaitingForSale;

  /// No description provided for @stillBought.
  ///
  /// In vi, this message translates to:
  /// **'Mua rồi'**
  String get stillBought;

  /// No description provided for @stillRemindAgain.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lại lần nữa'**
  String get stillRemindAgain;

  /// No description provided for @stillDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa món này'**
  String get stillDelete;

  /// No description provided for @stillOverItCheer.
  ///
  /// In vi, this message translates to:
  /// **'+{days} ngày lương còn sống.'**
  String stillOverItCheer(String days);

  /// No description provided for @stillScreenHeroUnit.
  ///
  /// In vi, this message translates to:
  /// **'ngày đi làm'**
  String get stillScreenHeroUnit;

  /// No description provided for @stillScreenQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Còn mê không?'**
  String get stillScreenQuestion;

  /// No description provided for @stillScreenBoughtDaysAgo.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn mua món này {days} ngày trước.'**
  String stillScreenBoughtDaysAgo(int days);

  /// No description provided for @stillScreenReasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lúc đó bạn thích vì: {reason}.'**
  String stillScreenReasonLabel(String reason);

  /// No description provided for @stillScreenSavedDays.
  ///
  /// In vi, this message translates to:
  /// **'+{days} ngày lương còn sống'**
  String stillScreenSavedDays(String days);

  /// No description provided for @stillScreenBtnStillCrushing.
  ///
  /// In vi, this message translates to:
  /// **'Vẫn mê'**
  String get stillScreenBtnStillCrushing;

  /// No description provided for @stillScreenBtnOverIt.
  ///
  /// In vi, this message translates to:
  /// **'Hết mê rồi'**
  String get stillScreenBtnOverIt;

  /// No description provided for @stillScreenBtnWaitingSale.
  ///
  /// In vi, this message translates to:
  /// **'Chờ sale'**
  String get stillScreenBtnWaitingSale;

  /// No description provided for @stillScreenBtnBought.
  ///
  /// In vi, this message translates to:
  /// **'Mua rồi'**
  String get stillScreenBtnBought;

  /// No description provided for @stillScreenBtnRemindAgain.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lại lần nữa'**
  String get stillScreenBtnRemindAgain;

  /// No description provided for @stillScreenBtnDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get stillScreenBtnDelete;

  /// No description provided for @cardSleepOnIt.
  ///
  /// In vi, this message translates to:
  /// **'Món này = {days} ngày đi làm.\nĐể mai tính.'**
  String cardSleepOnIt(String days);

  /// No description provided for @cardOnSale.
  ///
  /// In vi, this message translates to:
  /// **'Sale {percent}%\nnhưng vẫn là {days} ngày đi làm.'**
  String cardOnSale(String percent, String days);

  /// No description provided for @cardSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Tôi vừa không mua món này.\n+{days} ngày lương còn sống.'**
  String cardSkipped(String days);

  /// No description provided for @cardShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get cardShare;

  /// No description provided for @cardSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào ảnh'**
  String get cardSave;

  /// No description provided for @settingsEditIncome.
  ///
  /// In vi, this message translates to:
  /// **'Sửa thu nhập'**
  String get settingsEditIncome;

  /// No description provided for @settingsPayday.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lương trong tháng'**
  String get settingsPayday;

  /// No description provided for @settingsAppLock.
  ///
  /// In vi, this message translates to:
  /// **'Khóa app (Face ID / vân tay)'**
  String get settingsAppLock;

  /// No description provided for @settingsNotiDetail.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chi tiết trong thông báo'**
  String get settingsNotiDetail;

  /// No description provided for @settingsMascot.
  ///
  /// In vi, this message translates to:
  /// **'Bật mascot ví'**
  String get settingsMascot;

  /// No description provided for @settingsTheme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get settingsTheme;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ dữ liệu'**
  String get settingsDeleteAll;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @themeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get themeSystem;

  /// No description provided for @settingsBiometricsUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị chưa thiết lập Face ID / vân tay.'**
  String get settingsBiometricsUnavailable;

  /// No description provided for @settingsEnableLockReason.
  ///
  /// In vi, this message translates to:
  /// **'Bật khóa app để bảo vệ Ngày Lương.'**
  String get settingsEnableLockReason;

  /// No description provided for @settingsDeleteConfirm2Title.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chắc chứ?'**
  String get settingsDeleteConfirm2Title;

  /// No description provided for @settingsDeleteConfirm2Body.
  ///
  /// In vi, this message translates to:
  /// **'Sau bước này, mình không khôi phục lại được dữ liệu cho bạn.'**
  String get settingsDeleteConfirm2Body;

  /// No description provided for @settingsDeleteDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa toàn bộ dữ liệu.'**
  String get settingsDeleteDone;

  /// No description provided for @lockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày Lương đang khóa'**
  String get lockTitle;

  /// No description provided for @lockSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực để mở app.'**
  String get lockSubtitle;

  /// No description provided for @lockUnlock.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa'**
  String get lockUnlock;

  /// No description provided for @lockReason.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa Ngày Lương'**
  String get lockReason;

  /// No description provided for @saveCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo Save Card'**
  String get saveCardTitle;

  /// No description provided for @saveCardSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu Save Card: {path}'**
  String saveCardSaved(String path);

  /// No description provided for @saveCardTemplateSleepOnIt.
  ///
  /// In vi, this message translates to:
  /// **'Để mai tính'**
  String get saveCardTemplateSleepOnIt;

  /// No description provided for @saveCardTemplateOnSale.
  ///
  /// In vi, this message translates to:
  /// **'Sale gì cũng vẫn lương'**
  String get saveCardTemplateOnSale;

  /// No description provided for @saveCardTemplateSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Đã không mua'**
  String get saveCardTemplateSkipped;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
