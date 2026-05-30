import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';

void main() {
  CrushCard card({DateTime? remindAt}) {
    return CrushCard(
      id: 'card-1',
      name: 'Tai nghe',
      price: 1200000,
      daysOfWageSnapshot: 1.7,
      hoursOfWorkSnapshot: 13.7,
      status: CrushStatus.sleepOnIt,
      createdAt: DateTime(2026, 5, 29),
      updatedAt: DateTime(2026, 5, 29),
      remindAt: remindAt,
    );
  }

  test('scheduleCard with future remindAt schedules once', () async {
    final adapter = _RecordingNotificationAdapter();
    final service = NotificationService(
      adapter: adapter,
      now: () => DateTime(2026, 5, 29, 10),
    );

    final scheduled = await service.scheduleCard(
      card(remindAt: DateTime(2026, 5, 30, 20)),
    );

    expect(scheduled, isTrue);
    expect(adapter.scheduled, hasLength(1));
    expect(
      adapter.scheduled.single.id,
      NotificationService.notificationIdForCard('card-1'),
    );
    expect(adapter.scheduled.single.title, NotificationService.defaultTitle);
    expect(adapter.scheduled.single.body, NotificationService.defaultBody);
    expect(adapter.scheduled.single.payload, 'card-1');
  });

  test('scheduleCard with null remindAt does not schedule', () async {
    final adapter = _RecordingNotificationAdapter();
    final service = NotificationService(
      adapter: adapter,
      now: () => DateTime(2026, 5, 29, 10),
    );

    final scheduled = await service.scheduleCard(card());

    expect(scheduled, isFalse);
    expect(adapter.scheduled, isEmpty);
  });

  test('scheduleCard with past remindAt does not schedule', () async {
    final adapter = _RecordingNotificationAdapter();
    final service = NotificationService(
      adapter: adapter,
      now: () => DateTime(2026, 5, 29, 10),
    );

    final scheduled = await service.scheduleCard(
      card(remindAt: DateTime(2026, 5, 28, 20)),
    );

    expect(scheduled, isFalse);
    expect(adapter.scheduled, isEmpty);
  });

  test('cancelCard cancels the card notification id', () async {
    final adapter = _RecordingNotificationAdapter();
    final service = NotificationService(adapter: adapter);

    await service.cancelCard('card-1');

    expect(adapter.cancelled, [
      NotificationService.notificationIdForCard('card-1'),
    ]);
  });

  test('scheduleCard with detailMode uses card name and days', () async {
    final adapter = _RecordingNotificationAdapter();
    final service = NotificationService(
      adapter: adapter,
      now: () => DateTime(2026, 5, 29, 10),
    );
    final c = card(remindAt: DateTime(2026, 5, 30, 20));

    final scheduled = await service.scheduleCard(c, detailMode: true);

    expect(scheduled, isTrue);
    expect(adapter.scheduled.single.title, 'Còn mê Tai nghe không?');
    expect(adapter.scheduled.single.body, contains('ngày đi làm'));
  });

  test('scheduleCard with detailMode but empty name falls back to default',
      () async {
    final adapter = _RecordingNotificationAdapter();
    final service = NotificationService(
      adapter: adapter,
      now: () => DateTime(2026, 5, 29, 10),
    );
    final c = CrushCard(
      id: 'card-2',
      name: '',
      price: 500000,
      daysOfWageSnapshot: 0.8,
      hoursOfWorkSnapshot: 6.4,
      status: CrushStatus.sleepOnIt,
      createdAt: DateTime(2026, 5, 29),
      updatedAt: DateTime(2026, 5, 29),
      remindAt: DateTime(2026, 5, 30, 20),
    );

    final scheduled = await service.scheduleCard(c, detailMode: true);

    expect(scheduled, isTrue);
    expect(adapter.scheduled.single.title, NotificationService.defaultTitle);
    expect(adapter.scheduled.single.body, NotificationService.defaultBody);
  });
}

class _RecordingNotificationAdapter implements NotificationPluginAdapter {
  final scheduled = <ScheduledCardNotification>[];
  final cancelled = <int>[];

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
