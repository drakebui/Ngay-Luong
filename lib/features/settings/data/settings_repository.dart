import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences for non-sensitive app settings.
/// Income and app-lock secret live in secure storage, not here.
class SettingsRepository {
  const SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kAppLockEnabled = 'app_lock_enabled';
  static const _kNotiDetailMode = 'noti_detail_mode';
  static const _kThemeMode = 'theme_mode';
  static const _kPaydayDay = 'payday_day';
  static const _kMascotEnabled = 'mascot_enabled';
  static const _kOnboardingDone = 'onboarding_done';
  static const _kAntihaulMonthlyScheduledMonth =
      'antihaul_monthly_scheduled_month';
  static const _kSalaryDayNotifScheduledMonth =
      'salary_day_notif_scheduled_month';
  static const _kSalaryDayBannerDismissedMonth =
      'salary_day_banner_dismissed_month';

  static const defaultPaydayDay = 5;

  bool get appLockEnabled => _prefs.getBool(_kAppLockEnabled) ?? false;
  Future<void> setAppLockEnabled(bool value) =>
      _prefs.setBool(_kAppLockEnabled, value);

  bool get notiDetailMode => _prefs.getBool(_kNotiDetailMode) ?? false;
  Future<void> setNotiDetailMode(bool value) =>
      _prefs.setBool(_kNotiDetailMode, value);

  ThemeMode get themeMode {
    switch (_prefs.getString(_kThemeMode)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode value) {
    final raw = switch (value) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _prefs.setString(_kThemeMode, raw);
  }

  int get paydayDay {
    final v = _prefs.getInt(_kPaydayDay) ?? defaultPaydayDay;
    if (v < 1 || v > 31) return defaultPaydayDay;
    return v;
  }

  Future<void> setPaydayDay(int value) {
    final clamped = value.clamp(1, 31);
    return _prefs.setInt(_kPaydayDay, clamped);
  }

  bool get mascotEnabled => _prefs.getBool(_kMascotEnabled) ?? false;
  Future<void> setMascotEnabled(bool value) =>
      _prefs.setBool(_kMascotEnabled, value);

  int get antihaulMonthlyScheduledMonth =>
      _prefs.getInt(_kAntihaulMonthlyScheduledMonth) ?? 0;
  Future<void> setAntihaulMonthlyScheduledMonth(int value) =>
      _prefs.setInt(_kAntihaulMonthlyScheduledMonth, value);

  int get salaryDayNotifScheduledMonth =>
      _prefs.getInt(_kSalaryDayNotifScheduledMonth) ?? 0;
  Future<void> setSalaryDayNotifScheduledMonth(int value) =>
      _prefs.setInt(_kSalaryDayNotifScheduledMonth, value);

  int get salaryDayBannerDismissedMonth =>
      _prefs.getInt(_kSalaryDayBannerDismissedMonth) ?? 0;
  Future<void> setSalaryDayBannerDismissedMonth(int value) =>
      _prefs.setInt(_kSalaryDayBannerDismissedMonth, value);

  /// Reset all settings except keeps the SharedPreferences instance alive.
  /// Onboarding flag is removed too — user gets re-routed to onboarding.
  Future<void> resetAll() async {
    await _prefs.remove(_kAppLockEnabled);
    await _prefs.remove(_kNotiDetailMode);
    await _prefs.remove(_kThemeMode);
    await _prefs.remove(_kPaydayDay);
    await _prefs.remove(_kMascotEnabled);
    await _prefs.remove(_kOnboardingDone);
    await _prefs.remove(_kAntihaulMonthlyScheduledMonth);
    await _prefs.remove(_kSalaryDayNotifScheduledMonth);
    await _prefs.remove(_kSalaryDayBannerDismissedMonth);
  }
}
