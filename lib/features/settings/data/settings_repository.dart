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

  /// Reset all settings except keeps the SharedPreferences instance alive.
  /// Onboarding flag is removed too — user gets re-routed to onboarding.
  Future<void> resetAll() async {
    await _prefs.remove(_kAppLockEnabled);
    await _prefs.remove(_kNotiDetailMode);
    await _prefs.remove(_kThemeMode);
    await _prefs.remove(_kPaydayDay);
    await _prefs.remove(_kMascotEnabled);
    await _prefs.remove(_kOnboardingDone);
  }
}
