import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<SettingsRepository> makeRepo([Map<String, Object> initial = const {}]) async {
    SharedPreferences.setMockInitialValues(initial);
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }

  test('defaults when storage empty', () async {
    final repo = await makeRepo();
    expect(repo.appLockEnabled, false);
    expect(repo.notiDetailMode, false);
    expect(repo.themeMode, ThemeMode.system);
    expect(repo.paydayDay, SettingsRepository.defaultPaydayDay);
    expect(repo.mascotEnabled, false);
  });

  test('toggle app lock persists', () async {
    final repo = await makeRepo();
    await repo.setAppLockEnabled(true);
    expect(repo.appLockEnabled, true);
    await repo.setAppLockEnabled(false);
    expect(repo.appLockEnabled, false);
  });

  test('theme mode round-trips for every value', () async {
    final repo = await makeRepo();
    for (final mode in ThemeMode.values) {
      await repo.setThemeMode(mode);
      expect(repo.themeMode, mode);
    }
  });

  test('payday day clamps to 1..31', () async {
    final repo = await makeRepo();
    await repo.setPaydayDay(0);
    expect(repo.paydayDay, 1);
    await repo.setPaydayDay(50);
    expect(repo.paydayDay, 31);
    await repo.setPaydayDay(15);
    expect(repo.paydayDay, 15);
  });

  test('resetAll clears every key including onboarding flag', () async {
    final repo = await makeRepo({
      'app_lock_enabled': true,
      'noti_detail_mode': true,
      'theme_mode': 'dark',
      'payday_day': 20,
      'mascot_enabled': true,
      'onboarding_done': true,
    });
    expect(repo.appLockEnabled, true);
    await repo.resetAll();
    expect(repo.appLockEnabled, false);
    expect(repo.notiDetailMode, false);
    expect(repo.themeMode, ThemeMode.system);
    expect(repo.paydayDay, SettingsRepository.defaultPaydayDay);
    expect(repo.mascotEnabled, false);
  });
}
