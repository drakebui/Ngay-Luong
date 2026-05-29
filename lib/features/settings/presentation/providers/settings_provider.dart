import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/features/crush/presentation/providers/crush_providers.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/save_card/data/card_renderer.dart';
import 'package:ngay_luong/features/settings/data/app_lock_service.dart';
import 'package:ngay_luong/features/settings/data/data_reset_service.dart';
import 'package:ngay_luong/features/settings/data/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService();
});

final cardRendererProvider = Provider<CardRenderer>((ref) {
  return const CardRenderer();
});

final dataResetServiceProvider = Provider<DataResetService>((ref) {
  return DataResetService(
    database: ref.watch(appDatabaseProvider),
    imageStorage: ref.watch(imageStorageProvider),
    notificationService: ref.watch(notificationServiceProvider),
    incomeRepository: ref.watch(incomeRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    cardRenderer: ref.watch(cardRendererProvider),
  );
});

/// Reactive snapshot of all toggles. UI watches this; controller writes via
/// `SettingsController` to flush to disk + notify.
@immutable
class SettingsState {
  const SettingsState({
    required this.appLockEnabled,
    required this.notiDetailMode,
    required this.themeMode,
    required this.paydayDay,
    required this.mascotEnabled,
  });

  factory SettingsState.fromRepository(SettingsRepository repo) {
    return SettingsState(
      appLockEnabled: repo.appLockEnabled,
      notiDetailMode: repo.notiDetailMode,
      themeMode: repo.themeMode,
      paydayDay: repo.paydayDay,
      mascotEnabled: repo.mascotEnabled,
    );
  }

  final bool appLockEnabled;
  final bool notiDetailMode;
  final ThemeMode themeMode;
  final int paydayDay;
  final bool mascotEnabled;

  SettingsState copyWith({
    bool? appLockEnabled,
    bool? notiDetailMode,
    ThemeMode? themeMode,
    int? paydayDay,
    bool? mascotEnabled,
  }) {
    return SettingsState(
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      notiDetailMode: notiDetailMode ?? this.notiDetailMode,
      themeMode: themeMode ?? this.themeMode,
      paydayDay: paydayDay ?? this.paydayDay,
      mascotEnabled: mascotEnabled ?? this.mascotEnabled,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._repo) : super(SettingsState.fromRepository(_repo));

  final SettingsRepository _repo;

  Future<void> setAppLockEnabled(bool value) async {
    await _repo.setAppLockEnabled(value);
    state = state.copyWith(appLockEnabled: value);
  }

  Future<void> setNotiDetailMode(bool value) async {
    await _repo.setNotiDetailMode(value);
    state = state.copyWith(notiDetailMode: value);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    await _repo.setThemeMode(value);
    state = state.copyWith(themeMode: value);
  }

  Future<void> setPaydayDay(int value) async {
    await _repo.setPaydayDay(value);
    state = state.copyWith(paydayDay: _repo.paydayDay);
  }

  Future<void> setMascotEnabled(bool value) async {
    await _repo.setMascotEnabled(value);
    state = state.copyWith(mascotEnabled: value);
  }

  void refresh() {
    state = SettingsState.fromRepository(_repo);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController(ref.watch(settingsRepositoryProvider));
});
