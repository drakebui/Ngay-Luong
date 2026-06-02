import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ngay_luong/core/notifications/notification_copy.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

typedef CardNotificationTap = void Function(String cardId);

class ScheduledCardNotification {
  const ScheduledCardNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.payload,
    this.channelId = 'crush_reminders',
    this.channelName = 'Crush reminders',
    this.matchDateTimeComponents,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime scheduledAt;
  final String payload;
  final String channelId;
  final String channelName;
  final DateTimeComponents? matchDateTimeComponents;
}

abstract interface class NotificationPluginAdapter {
  Future<bool?> initialize({
    required CardNotificationTap? onCardTap,
  });

  Future<String?> getLaunchPayload();

  Future<bool?> requestPermissions();

  Future<void> zonedSchedule(ScheduledCardNotification notification);

  Future<void> cancel(int notificationId);

  Future<void> cancelAll();
}

class FlutterLocalNotificationPluginAdapter
    implements NotificationPluginAdapter {
  FlutterLocalNotificationPluginAdapter({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<bool?> initialize({
    required CardNotificationTap? onCardTap,
  }) {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    return _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        onCardTap?.call(payload);
      },
    );
  }

  @override
  Future<String?> getLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    final payload = details?.notificationResponse?.payload;
    return payload == null || payload.isEmpty ? null : payload;
  }

  @override
  Future<bool?> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted = await android?.requestNotificationsPermission();
    if (androidGranted != null) return androidGranted;

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (iosGranted != null) return iosGranted;

    final macos = _plugin.resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>();
    return macos?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Future<void> zonedSchedule(ScheduledCardNotification notification) {
    return _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      notification.scheduledAt,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notification.channelId,
          notification.channelName,
          channelDescription: 'Private reminders to revisit a saved item.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: notification.payload,
      matchDateTimeComponents: notification.matchDateTimeComponents,
    );
  }

  @override
  Future<void> cancel(int notificationId) {
    return _plugin.cancel(notificationId);
  }

  @override
  Future<void> cancelAll() {
    return _plugin.cancelAll();
  }
}

class NotificationService {
  NotificationService({
    NotificationPluginAdapter? adapter,
    DateTime Function()? now,
  })  : _adapter = adapter ?? FlutterLocalNotificationPluginAdapter(),
        _now = now ?? DateTime.now;

  static const defaultTitle = 'Còn mê không?';
  static const defaultBody = 'Mở app xem lại.';

  static String detailTitle(String name) => 'Còn mê $name không?';

  static String detailBody(double days) {
    final d = days < 1 ? days.toStringAsFixed(1) : days.round().toString();
    return 'Món này từng lấy của bạn $d ngày đi làm.';
  }

  final NotificationPluginAdapter _adapter;
  final DateTime Function() _now;
  bool _timeZonesInitialized = false;
  bool _initialized = false;

  Future<bool> initialize({CardNotificationTap? onCardTap}) async {
    _ensureTimeZonesInitialized();
    try {
      final initialized = await _adapter.initialize(onCardTap: onCardTap);
      _initialized = initialized ?? true;
      final launchPayload = await _adapter.getLaunchPayload();
      if (launchPayload != null) {
        onCardTap?.call(launchPayload);
      }
      return _initialized;
    } catch (_) {
      debugPrint('Notification initialization failed; reminders stay in app.');
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final granted = await _adapter.requestPermissions();
      if (granted == false) {
        debugPrint('Notification permission denied; reminders stay in app.');
      }
      return granted ?? true;
    } catch (_) {
      debugPrint(
        'Notification permission request failed; reminders stay in app.',
      );
      return false;
    }
  }

  Future<bool> scheduleCard(CrushCard card, {bool detailMode = false}) async {
    final remindAt = card.remindAt;
    if (remindAt == null || remindAt.isBefore(_now())) {
      return false;
    }

    _ensureTimeZonesInitialized();
    if (!_initialized) {
      await initialize();
    }

    final granted = await requestPermissions();
    if (!granted) return false;

    final copy = NotificationCopyPool.selectFor(
      card,
      detailMode: detailMode,
      now: _now(),
    );
    final title = copy.$1;
    final body = copy.$2;

    try {
      await _adapter.zonedSchedule(
        ScheduledCardNotification(
          id: notificationIdForCard(card.id),
          title: title,
          body: body,
          scheduledAt: tz.TZDateTime.from(remindAt, tz.local),
          payload: card.id,
        ),
      );
      return true;
    } catch (_) {
      debugPrint('Notification scheduling failed; reminder stays in app.');
      return false;
    }
  }

  Future<void> cancelCard(String cardId) async {
    try {
      await _adapter.cancel(notificationIdForCard(cardId));
    } catch (_) {
      debugPrint('Notification cancel failed.');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _adapter.cancelAll();
    } catch (_) {
      debugPrint('Notification cancel-all failed.');
    }
  }

  void _ensureTimeZonesInitialized() {
    if (_timeZonesInitialized) return;
    tz_data.initializeTimeZones();
    _timeZonesInitialized = true;
  }

  static int notificationIdForCard(String cardId) {
    return cardId.hashCode.abs() % 0x7FFFFFFF;
  }
}
