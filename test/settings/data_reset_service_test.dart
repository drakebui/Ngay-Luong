import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/income/data/income_repository.dart';
import 'package:ngay_luong/features/income/data/income_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';
import 'package:ngay_luong/features/save_card/data/card_renderer.dart';
import 'package:ngay_luong/features/settings/data/data_reset_service.dart';
import 'package:ngay_luong/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingImageStorage extends ImageStorage {
  const _RecordingImageStorage();
  static bool deleted = false;
  @override
  Future<void> deleteAllImages() async {
    deleted = true;
  }
}

class _RecordingCardRenderer extends CardRenderer {
  const _RecordingCardRenderer();
  static bool deleted = false;
  @override
  Future<void> deleteAllSavedCards() async {
    deleted = true;
  }
}

class _InMemoryIncomeStorage extends IncomeStorage {
  const _InMemoryIncomeStorage();
  static IncomeProfile? _profile;
  @override
  Future<IncomeProfile?> read() async => _profile;
  @override
  Future<void> write(IncomeProfile profile) async => _profile = profile;
  @override
  Future<void> clear() async => _profile = null;
}

class _FakeNotificationAdapter implements NotificationPluginAdapter {
  bool cancelAllCalled = false;
  @override
  Future<bool?> initialize({required CardNotificationTap? onCardTap}) async => true;
  @override
  Future<String?> getLaunchPayload() async => null;
  @override
  Future<bool?> requestPermissions() async => true;
  @override
  Future<void> zonedSchedule(ScheduledCardNotification notification) async {}
  @override
  Future<void> cancel(int notificationId) async {}
  @override
  Future<void> cancelAll() async {
    cancelAllCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('wipeEverything clears DB, images, income, settings, notifications',
      () async {
    SharedPreferences.setMockInitialValues({
      'onboarding_done': true,
      'app_lock_enabled': true,
      'theme_mode': 'dark',
    });
    final prefs = await SharedPreferences.getInstance();

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final notiAdapter = _FakeNotificationAdapter();
    final notiService = NotificationService(adapter: notiAdapter);

    _InMemoryIncomeStorage._profile = IncomeProfile(
      mode: IncomeMode.monthly,
      monthlyNetIncome: 20000000,
      updatedAt: DateTime(2026, 1, 1),
    );

    final incomeRepo = IncomeRepository(
      storage: const _InMemoryIncomeStorage(),
      prefs: prefs,
    );
    final settingsRepo = SettingsRepository(prefs);

    await db.into(db.crushCards).insert(
          CrushCardsCompanion.insert(
            id: 'c1',
            price: 100000,
            daysOfWageSnapshot: 1.0,
            hoursOfWorkSnapshot: 8.0,
            status: 'crushing',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    _RecordingImageStorage.deleted = false;
    _RecordingCardRenderer.deleted = false;

    final service = DataResetService(
      database: db,
      imageStorage: const _RecordingImageStorage(),
      notificationService: notiService,
      incomeRepository: incomeRepo,
      settingsRepository: settingsRepo,
      cardRenderer: const _RecordingCardRenderer(),
    );

    await service.wipeEverything();

    expect(
      notiAdapter.cancelAllCalled,
      true,
      reason: 'must cancel scheduled notifications first',
    );
    expect(await db.select(db.crushCards).get(), isEmpty);
    expect(_RecordingImageStorage.deleted, true);
    expect(
      _RecordingCardRenderer.deleted,
      true,
      reason: 'derived save-card PNGs must be wiped too',
    );
    expect(await incomeRepo.loadProfile(), isNull);
    expect(incomeRepo.isOnboardingDone(), false);
    expect(settingsRepo.appLockEnabled, false);
    expect(settingsRepo.themeMode.toString(), contains('system'));
  });
}
