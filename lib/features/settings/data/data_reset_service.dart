import 'package:drift/drift.dart';
import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/income/data/income_repository.dart';
import 'package:ngay_luong/features/settings/data/settings_repository.dart';

/// Wipes every piece of user data. Used by "Xóa toàn bộ dữ liệu" in Settings.
///
/// Order matters: cancel scheduled notifications first (so we don't fire a
/// reminder for a card we've just deleted), then DB rows + image files,
/// then secure storage (income), then non-sensitive settings.
class DataResetService {
  const DataResetService({
    required AppDatabase database,
    required ImageStorage imageStorage,
    required NotificationService notificationService,
    required IncomeRepository incomeRepository,
    required SettingsRepository settingsRepository,
  })  : _database = database,
        _imageStorage = imageStorage,
        _notificationService = notificationService,
        _incomeRepository = incomeRepository,
        _settingsRepository = settingsRepository;

  final AppDatabase _database;
  final ImageStorage _imageStorage;
  final NotificationService _notificationService;
  final IncomeRepository _incomeRepository;
  final SettingsRepository _settingsRepository;

  Future<void> wipeEverything() async {
    await _notificationService.cancelAll();
    await _database.delete(_database.crushCards).go();
    await _imageStorage.deleteAllImages();
    await _incomeRepository.clearProfile();
    await _settingsRepository.resetAll();
  }
}
