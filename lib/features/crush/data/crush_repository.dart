import 'package:drift/drift.dart';
import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/settings/data/settings_repository.dart';

class CrushRepository {
  const CrushRepository({
    required AppDatabase database,
    required ImageStorage imageStorage,
    required NotificationService notificationService,
    required SettingsRepository settingsRepository,
  })  : _database = database,
        _imageStorage = imageStorage,
        _notificationService = notificationService,
        _settingsRepository = settingsRepository;

  final AppDatabase _database;
  final ImageStorage _imageStorage;
  final NotificationService _notificationService;
  final SettingsRepository _settingsRepository;

  Stream<List<CrushCard>> watchAll() {
    final query = _database.select(_database.crushCards)
      ..orderBy([
        (table) => OrderingTerm.desc(table.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<CrushCard>> watchPending() {
    final pendingStatuses = CrushStatus.values
        .where((status) => status.isPending)
        .map((status) => status.name);
    final query = _database.select(_database.crushCards)
      ..where((table) => table.status.isIn(pendingStatuses))
      ..orderBy([
        (table) => OrderingTerm.asc(table.remindAt),
        (table) => OrderingTerm.desc(table.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<CrushCard>> watchRemindToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
    final query = _database.select(_database.crushCards)
      ..where(
        (table) =>
            table.remindAt.isBiggerOrEqualValue(startOfDay) &
            table.remindAt.isSmallerThanValue(startOfTomorrow),
      )
      ..orderBy([(table) => OrderingTerm.asc(table.remindAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<CrushCard>> watchUpcoming() {
    final now = DateTime.now();
    final query = _database.select(_database.crushCards)
      ..where((table) => table.remindAt.isBiggerThanValue(now))
      ..orderBy([(table) => OrderingTerm.asc(table.remindAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<DateTime>> watchRemindDaysByMonth(int year, int month) {
    final start = DateTime(year, month);
    final nextMonth = DateTime(year, month + 1);
    final query = _database.select(_database.crushCards)
      ..where(
        (table) =>
            table.remindAt.isBiggerOrEqualValue(start) &
            table.remindAt.isSmallerThanValue(nextMonth),
      )
      ..orderBy([(table) => OrderingTerm.asc(table.remindAt)]);

    return query.watch().map((rows) {
      final days = <DateTime>{};
      for (final row in rows) {
        final remindAt = row.remindAt;
        if (remindAt != null) {
          days.add(DateTime(remindAt.year, remindAt.month, remindAt.day));
        }
      }
      return days.toList()..sort();
    });
  }

  Future<CrushCard?> getById(String id) async {
    final query = _database.select(_database.crushCards)
      ..where((table) => table.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> insertCard(CrushCard card) async {
    await _database.into(_database.crushCards).insert(_toCompanion(card));
    if (card.status.isPending) {
      await _notificationService.scheduleCard(
        card,
        detailMode: _settingsRepository.notiDetailMode,
      );
    }
  }

  Future<void> updateCard(CrushCard card) async {
    await _notificationService.cancelCard(card.id);
    await (_database.update(_database.crushCards)
          ..where((table) => table.id.equals(card.id)))
        .write(_toCompanion(card));
    if (card.status.isPending) {
      await _notificationService.scheduleCard(
        card,
        detailMode: _settingsRepository.notiDetailMode,
      );
    }
  }

  Future<void> deleteCard(String id, {String? imagePath}) async {
    await _notificationService.cancelCard(id);
    await (_database.delete(_database.crushCards)
          ..where((table) => table.id.equals(id)))
        .go();
    if (imagePath != null) {
      await _imageStorage.deleteImage(imagePath);
    }
  }

  Future<double> sumSavedDays() async {
    final savedStatuses = CrushStatus.values
        .where((status) => status.countsAsSaved)
        .map((status) => status.name);
    final query = _database.select(_database.crushCards)
      ..where((table) => table.status.isIn(savedStatuses));
    final rows = await query.get();
    return rows.fold<double>(
      0,
      (sum, row) => sum + row.daysOfWageSnapshot,
    );
  }

  CrushCard _toDomain(CrushCardData row) {
    return CrushCard(
      id: row.id,
      name: row.name,
      price: row.price,
      category: row.category,
      imagePath: row.imagePath,
      daysOfWageSnapshot: row.daysOfWageSnapshot,
      hoursOfWorkSnapshot: row.hoursOfWorkSnapshot,
      pctOfMonthlyIncomeSnapshot: row.pctOfMonthlyIncomeSnapshot,
      reason: _reasonFromName(row.reason),
      mood: row.mood,
      note: row.note,
      status: _statusFromName(row.status),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      remindAt: row.remindAt,
      remindCount: row.remindCount,
    );
  }

  CrushCardsCompanion _toCompanion(CrushCard card) {
    return CrushCardsCompanion(
      id: Value(card.id),
      name: Value(card.name),
      price: Value(card.price),
      category: Value(card.category),
      imagePath: Value(card.imagePath),
      daysOfWageSnapshot: Value(card.daysOfWageSnapshot),
      hoursOfWorkSnapshot: Value(card.hoursOfWorkSnapshot),
      pctOfMonthlyIncomeSnapshot: Value(card.pctOfMonthlyIncomeSnapshot),
      reason: Value(card.reason?.name),
      mood: Value(card.mood),
      note: Value(card.note),
      status: Value(card.status.name),
      createdAt: Value(card.createdAt),
      updatedAt: Value(card.updatedAt),
      remindAt: Value(card.remindAt),
      remindCount: Value(card.remindCount),
    );
  }

  CrushReason? _reasonFromName(String? name) {
    if (name == null) return null;
    for (final reason in CrushReason.values) {
      if (reason.name == name) return reason;
    }
    return null;
  }

  CrushStatus _statusFromName(String name) {
    for (final status in CrushStatus.values) {
      if (status.name == name) return status;
    }
    return CrushStatus.crushing;
  }
}
