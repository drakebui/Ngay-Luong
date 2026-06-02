import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/crush/data/crush_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class RecapNotificationService {
  RecapNotificationService({
    required NotificationPluginAdapter adapter,
    required SharedPreferences prefs,
    required CrushRepository crushRepository,
    DateTime Function()? now,
  })  : _adapter = adapter,
        _prefs = prefs,
        _crushRepository = crushRepository,
        _now = now ?? DateTime.now;

  static const weeklyAntiHaulId = 900001;
  static const monthlyAntiHaulId = 900002;
  static const salaryDayId = 900003;
  static const _recapChannelId = 'recap_reminders';
  static const _recapChannelName = 'Recap reminders';
  static const _antihaulMonthlyKey = 'antihaul_monthly_scheduled_month';
  static const _salaryDayKey = 'salary_day_notif_scheduled_month';

  final NotificationPluginAdapter _adapter;
  final SharedPreferences _prefs;
  final CrushRepository _crushRepository;
  final DateTime Function() _now;
  bool _initialized = false;

  Future<void> scheduleWeeklyAntiHaul() async {
    await _ensureReady();
    final summary = await _crushRepository.savedCardsSummaryThisWeek(
      now: _now(),
    );
    await _adapter.zonedSchedule(
      ScheduledCardNotification(
        id: weeklyAntiHaulId,
        title: 'Anti-haul tuần này',
        body: _antiHaulBody('Tuần này', summary.$1, summary.$2),
        scheduledAt: _nextSundayAt20(),
        payload: 'antihaul_weekly',
        channelId: _recapChannelId,
        channelName: _recapChannelName,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      ),
    );
  }

  Future<void> scheduleMonthlyAntiHaul(int year, int month) async {
    await _ensureReady();
    final current = _now();
    final safeDay = current.day.clamp(1, DateTime(year, month + 1, 0).day);
    final summary = await _crushRepository.savedCardsSummaryThisMonth(
      now: DateTime(year, month, safeDay),
    );
    await _adapter.zonedSchedule(
      ScheduledCardNotification(
        id: monthlyAntiHaulId,
        title: 'Anti-haul tháng này',
        body: _antiHaulBody('Tháng này', summary.$1, summary.$2),
        scheduledAt: tz.TZDateTime.from(_lastDayAt20(year, month), tz.local),
        payload: 'antihaul_monthly',
        channelId: _recapChannelId,
        channelName: _recapChannelName,
      ),
    );
    await _prefs.setInt(_antihaulMonthlyKey, year * 100 + month);
  }

  Future<void> scheduleSalaryDay(int paydayDay, int year, int month) async {
    await _ensureReady();
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = paydayDay.clamp(1, lastDay);
    await _adapter.zonedSchedule(
      ScheduledCardNotification(
        id: salaryDayId,
        title: 'Lương về rồi.',
        body: 'Lương vừa về. Có món nào đang chờ bạn mua không?',
        scheduledAt: tz.TZDateTime.from(
          DateTime(year, month, day, 9),
          tz.local,
        ),
        payload: 'salary_day',
        channelId: _recapChannelId,
        channelName: _recapChannelName,
      ),
    );
    await _prefs.setInt(_salaryDayKey, year * 100 + month);
  }

  static Future<void> scheduleOnStartup({
    required RecapNotificationService service,
    required SharedPreferences prefs,
    required int paydayDay,
  }) async {
    final now = service._now();
    final monthKey = now.year * 100 + now.month;
    await service.scheduleWeeklyAntiHaul();
    if ((prefs.getInt(_antihaulMonthlyKey) ?? 0) != monthKey) {
      await service.scheduleMonthlyAntiHaul(now.year, now.month);
    }
    if ((prefs.getInt(_salaryDayKey) ?? 0) != monthKey) {
      await service.scheduleSalaryDay(paydayDay, now.year, now.month);
    }
  }

  static DateTime lastDayAt20(int year, int month) =>
      DateTime(year, month + 1, 0, 20);

  DateTime _lastDayAt20(int year, int month) => lastDayAt20(year, month);

  tz.TZDateTime _nextSundayAt20() {
    final now = _now();
    var scheduled = DateTime(now.year, now.month, now.day, 20);
    final daysUntilSunday = (DateTime.sunday - scheduled.weekday) % 7;
    scheduled = scheduled.add(Duration(days: daysUntilSunday));
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    return tz.TZDateTime.from(scheduled, tz.local);
  }

  String _antiHaulBody(String prefix, int count, double days) {
    final d = days < 1 ? days.toStringAsFixed(1) : days.round().toString();
    return '$prefix bạn đã hết mê $count món. +$d ngày lương còn sống.';
  }

  Future<void> _ensureReady() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    await _adapter.initialize(onCardTap: null);
    await _adapter.requestPermissions();
    _initialized = true;
  }
}
