import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/crush/data/crush_repository.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/crush/domain/remind_at_calculator.dart';
import 'package:ngay_luong/features/crush/presentation/controllers/still_crushing_actions.dart';

void main() {
  late AppDatabase database;
  late _RecordingNotificationAdapter notificationAdapter;
  late CrushRepository repository;
  late StillCrushingActions actions;
  final fixedNow = DateTime(2026, 5, 29, 10);

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    notificationAdapter = _RecordingNotificationAdapter();
    repository = CrushRepository(
      database: database,
      imageStorage: const ImageStorage(),
      notificationService: NotificationService(
        adapter: notificationAdapter,
        now: () => fixedNow,
      ),
    );
    actions = StillCrushingActions(
      repository: repository,
      now: () => fixedNow,
    );
  });

  tearDown(() async {
    await database.close();
  });

  CrushCard card({String id = 'card-1'}) {
    return CrushCard(
      id: id,
      name: 'Tai nghe',
      price: 1200000,
      daysOfWageSnapshot: 1.7,
      hoursOfWorkSnapshot: 13.7,
      status: CrushStatus.sleepOnIt,
      createdAt: DateTime(2026, 5, 27),
      updatedAt: DateTime(2026, 5, 27),
      remindAt: DateTime(2026, 5, 29, 20),
    );
  }

  Future<CrushCard> insert(CrushCard card) async {
    await repository.insertCard(card);
    notificationAdapter.clear();
    return (await repository.getById(card.id))!;
  }

  test('Vẫn mê updates status and cancels existing notification', () async {
    final saved = await insert(card());

    await actions.stillCrushing(saved);

    final updated = await repository.getById(saved.id);
    expect(updated!.status, CrushStatus.stillCrushing);
    expect(updated.remindAt, isNull);
    expect(notificationAdapter.cancelled, [
      NotificationService.notificationIdForCard(saved.id),
    ]);
    expect(notificationAdapter.scheduled, isEmpty);
  });

  test('Hết mê rồi updates status and cancels notification', () async {
    final saved = await insert(card());

    await actions.overIt(saved);

    final updated = await repository.getById(saved.id);
    expect(updated!.status, CrushStatus.overIt);
    expect(updated.remindAt, isNull);
    expect(notificationAdapter.cancelled, [
      NotificationService.notificationIdForCard(saved.id),
    ]);
    expect(notificationAdapter.scheduled, isEmpty);
  });

  test('Chờ sale updates status without scheduling a new notification',
      () async {
    final saved = await insert(card());

    await actions.waitingForSale(saved);

    final updated = await repository.getById(saved.id);
    expect(updated!.status, CrushStatus.waitingForSale);
    expect(updated.remindAt, isNull);
    expect(notificationAdapter.cancelled, [
      NotificationService.notificationIdForCard(saved.id),
    ]);
    expect(notificationAdapter.scheduled, isEmpty);
  });

  test('Mua rồi updates status and cancels notification', () async {
    final saved = await insert(card());

    await actions.bought(saved);

    final updated = await repository.getById(saved.id);
    expect(updated!.status, CrushStatus.bought);
    expect(updated.remindAt, isNull);
    expect(notificationAdapter.cancelled, [
      NotificationService.notificationIdForCard(saved.id),
    ]);
    expect(notificationAdapter.scheduled, isEmpty);
  });

  test('Nhắc lại lần nữa sets after24h remindAt and reschedules', () async {
    final saved = await insert(card());

    await actions.remindAgain(
      saved,
      preset: ReminderPreset.after24h,
      paydayDay: 5,
    );

    final updated = await repository.getById(saved.id);
    expect(updated!.status, CrushStatus.stillCrushing);
    expect(updated.remindCount, 1);
    expect(
      updated.remindAt!
          .difference(fixedNow.add(const Duration(hours: 24)))
          .abs(),
      lessThanOrEqualTo(const Duration(seconds: 5)),
    );
    expect(notificationAdapter.cancelled, [
      NotificationService.notificationIdForCard(saved.id),
    ]);
    expect(notificationAdapter.scheduled, hasLength(1));
    expect(notificationAdapter.scheduled.single.payload, saved.id);
  });

  test('Xóa removes card and cancels notification', () async {
    final saved = await insert(card());

    await actions.delete(saved);

    expect(await repository.getById(saved.id), isNull);
    expect(notificationAdapter.cancelled, [
      NotificationService.notificationIdForCard(saved.id),
    ]);
  });
}

class _RecordingNotificationAdapter implements NotificationPluginAdapter {
  final scheduled = <ScheduledCardNotification>[];
  final cancelled = <int>[];

  void clear() {
    scheduled.clear();
    cancelled.clear();
  }

  @override
  Future<void> cancel(int notificationId) async {
    cancelled.add(notificationId);
  }

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
  Future<void> zonedSchedule(ScheduledCardNotification notification) async {
    scheduled.add(notification);
  }
}
