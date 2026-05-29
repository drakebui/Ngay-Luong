import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/crush/data/crush_repository.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';

void main() {
  late AppDatabase database;
  late CrushRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CrushRepository(
      database: database,
      imageStorage: const ImageStorage(),
      notificationService:
          NotificationService(adapter: _FakeNotificationAdapter()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  CrushCard card({
    String id = 'card-1',
    CrushStatus status = CrushStatus.sleepOnIt,
    DateTime? remindAt,
  }) {
    final now = DateTime(2026, 5, 29, 10);
    return CrushCard(
      id: id,
      name: 'Tai nghe',
      price: 1200000,
      daysOfWageSnapshot: 1.7,
      hoursOfWorkSnapshot: 13.7,
      pctOfMonthlyIncomeSnapshot: 7.8,
      reason: CrushReason.sawReview,
      status: status,
      createdAt: now,
      updatedAt: now,
      remindAt: remindAt,
    );
  }

  test('insertCard and getById round-trip domain model', () async {
    await repository.insertCard(card());

    final saved = await repository.getById('card-1');

    expect(saved, isNotNull);
    expect(saved!.name, 'Tai nghe');
    expect(saved.reason, CrushReason.sawReview);
    expect(saved.status, CrushStatus.sleepOnIt);
  });

  test('watchPending returns only pending statuses', () async {
    await repository.insertCard(card(id: 'pending'));
    await repository.insertCard(
      card(id: 'saved', status: CrushStatus.overIt),
    );

    final pending = await repository.watchPending().first;

    expect(pending.map((item) => item.id), ['pending']);
  });

  test('updateCard changes status and sumSavedDays counts saved statuses',
      () async {
    final initial = card();
    await repository.insertCard(initial);
    await repository.updateCard(
      initial.copyWith(
        status: CrushStatus.overIt,
        updatedAt: DateTime(2026, 5, 30, 10),
      ),
    );

    final saved = await repository.getById('card-1');
    final savedDays = await repository.sumSavedDays();

    expect(saved!.status, CrushStatus.overIt);
    expect(savedDays, 1.7);
  });

  test('deleteCard removes row', () async {
    await repository.insertCard(card());

    await repository.deleteCard('card-1');

    expect(await repository.getById('card-1'), isNull);
  });

  test('watchAll returns cards ordered newest first', () async {
    final earlyCard = CrushCard(
      id: 'early',
      name: 'Sớm hơn',
      price: 500000,
      daysOfWageSnapshot: 0.7,
      hoursOfWorkSnapshot: 5.6,
      status: CrushStatus.crushing,
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime(2026, 5, 1),
    );
    final lateCard = CrushCard(
      id: 'late',
      name: 'Mới hơn',
      price: 800000,
      daysOfWageSnapshot: 1.1,
      hoursOfWorkSnapshot: 8.9,
      status: CrushStatus.crushing,
      createdAt: DateTime(2026, 5, 29),
      updatedAt: DateTime(2026, 5, 29),
    );

    await repository.insertCard(earlyCard);
    await repository.insertCard(lateCard);

    final cards = await repository.watchAll().first;
    expect(cards.map((c) => c.id).toList(), ['late', 'early']);
  });

  test('watchRemindToday excludes cards outside today', () async {
    final today = DateTime(2026, 5, 29, 14);
    final tomorrow = DateTime(2026, 5, 30, 9);
    final yesterday = DateTime(2026, 5, 28, 20);

    await repository.insertCard(
      card(id: 'today', remindAt: today),
    );
    await repository.insertCard(
      card(id: 'tomorrow', remindAt: tomorrow),
    );
    await repository.insertCard(
      card(id: 'yesterday', remindAt: yesterday),
    );

    final results = await repository.watchRemindToday().first;
    expect(results.map((c) => c.id).toList(), ['today']);
  });

  test('watchUpcoming returns cards with remindAt after now, sorted asc',
      () async {
    final soon = DateTime(2026, 5, 30, 20);
    final later = DateTime(2026, 6, 5, 20);
    final past = DateTime(2026, 5, 28, 20);

    await repository.insertCard(card(id: 'soon', remindAt: soon));
    await repository.insertCard(card(id: 'later', remindAt: later));
    await repository.insertCard(card(id: 'past', remindAt: past));
    await repository.insertCard(card(id: 'no-remind'));

    final results = await repository
        .watchUpcoming()
        .first
        .timeout(const Duration(seconds: 2));

    // past và no-remind không xuất hiện; soon trước later
    expect(results.map((c) => c.id).toList(), ['soon', 'later']);
  });

  test('watchRemindDaysByMonth returns distinct dates in the month', () async {
    await repository.insertCard(
      card(id: 'a', remindAt: DateTime(2026, 5, 10, 20)),
    );
    await repository.insertCard(
      card(id: 'b', remindAt: DateTime(2026, 5, 10, 21)),
    );
    await repository.insertCard(
      card(id: 'c', remindAt: DateTime(2026, 5, 15, 20)),
    );
    await repository.insertCard(
      card(id: 'd', remindAt: DateTime(2026, 6, 1, 20)),
    );

    final days = await repository.watchRemindDaysByMonth(2026, 5).first;

    expect(days, [DateTime(2026, 5, 10), DateTime(2026, 5, 15)]);
  });

  test('sumSavedDays sums only overIt and skipped', () async {
    await repository.insertCard(
      card(id: 'over', status: CrushStatus.overIt),
    );
    await repository.insertCard(
      card(id: 'skip', status: CrushStatus.skipped),
    );
    await repository.insertCard(
      card(id: 'bought', status: CrushStatus.bought),
    );
    await repository.insertCard(
      card(id: 'crush', status: CrushStatus.crushing),
    );

    final total = await repository.sumSavedDays();

    // daysOfWageSnapshot = 1.7 per card; over + skip = 3.4
    expect(total, closeTo(3.4, 0.001));
  });
}

class _FakeNotificationAdapter implements NotificationPluginAdapter {
  @override
  Future<void> cancel(int notificationId) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<String?> getLaunchPayload() async => null;

  @override
  Future<bool?> initialize({required CardNotificationTap? onCardTap}) async {
    return true;
  }

  @override
  Future<bool?> requestPermissions() async => true;

  @override
  Future<void> zonedSchedule(ScheduledCardNotification notification) async {}
}
