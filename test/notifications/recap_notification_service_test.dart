import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/core/notifications/recap_notification_service.dart';
import 'package:ngay_luong/features/crush/data/crush_repository.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late AppDatabase database;
  late CrushRepository repository;
  late _RecordingNotificationAdapter adapter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'noti_detail_mode': false});
    prefs = await SharedPreferences.getInstance();
    database = AppDatabase.forTesting(NativeDatabase.memory());
    adapter = _RecordingNotificationAdapter();
    repository = CrushRepository(
      database: database,
      imageStorage: const ImageStorage(),
      notificationService: NotificationService(adapter: adapter),
      settingsRepository: SettingsRepository(prefs),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('weekly schedules Sunday 20:00 with dayOfWeekAndTime', () async {
    final service = RecapNotificationService(
      adapter: adapter,
      prefs: prefs,
      crushRepository: repository,
      now: () => DateTime(2026, 6, 2, 12),
    );

    await service.scheduleWeeklyAntiHaul();

    final scheduled = adapter.scheduled.single;
    expect(scheduled.id, RecapNotificationService.weeklyAntiHaulId);
    expect(scheduled.scheduledAt.weekday, DateTime.sunday);
    expect(scheduled.scheduledAt.hour, 20);
    expect(
      scheduled.matchDateTimeComponents,
      DateTimeComponents.dayOfWeekAndTime,
    );
  });

  test('monthly schedules last day for common month shapes', () {
    expect(RecapNotificationService.lastDayAt20(2026, 2).day, 28);
    expect(RecapNotificationService.lastDayAt20(2028, 2).day, 29);
    expect(RecapNotificationService.lastDayAt20(2026, 4).day, 30);
    expect(RecapNotificationService.lastDayAt20(2026, 5).day, 31);
  });

  test('scheduleOnStartup is idempotent within the same month', () async {
    final service = RecapNotificationService(
      adapter: adapter,
      prefs: prefs,
      crushRepository: repository,
      now: () => DateTime(2026, 6, 2),
    );

    await RecapNotificationService.scheduleOnStartup(
      service: service,
      prefs: prefs,
      paydayDay: 5,
    );
    await RecapNotificationService.scheduleOnStartup(
      service: service,
      prefs: prefs,
      paydayDay: 5,
    );

    expect(
      adapter.scheduled
          .where((n) => n.id == RecapNotificationService.monthlyAntiHaulId),
      hasLength(1),
    );
    expect(
      adapter.scheduled
          .where((n) => n.id == RecapNotificationService.salaryDayId),
      hasLength(1),
    );
    expect(
      adapter.scheduled
          .where((n) => n.id == RecapNotificationService.weeklyAntiHaulId),
      hasLength(2),
    );
  });

  test('scheduleOnStartup re-schedules when month changes', () async {
    final june = RecapNotificationService(
      adapter: adapter,
      prefs: prefs,
      crushRepository: repository,
      now: () => DateTime(2026, 6, 30),
    );
    final july = RecapNotificationService(
      adapter: adapter,
      prefs: prefs,
      crushRepository: repository,
      now: () => DateTime(2026, 7, 1),
    );

    await RecapNotificationService.scheduleOnStartup(
      service: june,
      prefs: prefs,
      paydayDay: 5,
    );
    await RecapNotificationService.scheduleOnStartup(
      service: july,
      prefs: prefs,
      paydayDay: 5,
    );

    expect(
      adapter.scheduled
          .where((n) => n.id == RecapNotificationService.monthlyAntiHaulId),
      hasLength(2),
    );
    expect(
      adapter.scheduled
          .where((n) => n.id == RecapNotificationService.salaryDayId),
      hasLength(2),
    );
  });

  test('saved summary counts saved statuses by week and month', () async {
    await repository.insertCard(_card(
      id: 'week-saved',
      status: CrushStatus.overIt,
      days: 1.5,
      updatedAt: DateTime(2026, 6, 1),
    ),);
    await repository.insertCard(_card(
      id: 'month-saved',
      status: CrushStatus.skipped,
      days: 2,
      updatedAt: DateTime(2026, 5, 20),
    ),);
    await repository.insertCard(_card(
      id: 'pending',
      status: CrushStatus.sleepOnIt,
      days: 9,
      updatedAt: DateTime(2026, 6, 1),
    ),);

    final week = await repository.savedCardsSummaryThisWeek(
      now: DateTime(2026, 6, 2),
    );
    final month = await repository.savedCardsSummaryThisMonth(
      now: DateTime(2026, 6, 2),
    );

    expect(week.$1, 1);
    expect(week.$2, 1.5);
    expect(month.$1, 1);
    expect(month.$2, 1.5);
  });
}

CrushCard _card({
  required String id,
  required CrushStatus status,
  required double days,
  required DateTime updatedAt,
}) {
  return CrushCard(
    id: id,
    price: 1000000,
    daysOfWageSnapshot: days,
    hoursOfWorkSnapshot: days * 8,
    status: status,
    createdAt: DateTime(2026, 5, 1),
    updatedAt: updatedAt,
  );
}

class _RecordingNotificationAdapter implements NotificationPluginAdapter {
  final scheduled = <ScheduledCardNotification>[];

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
  Future<void> zonedSchedule(ScheduledCardNotification notification) async {
    scheduled.add(notification);
  }
}
