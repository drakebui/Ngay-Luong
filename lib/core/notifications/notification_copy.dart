import 'package:ngay_luong/features/crush/domain/crush_models.dart';

class NotificationCopyPool {
  static const _pool = <(String title, String body)>[
    ('Còn mê không?', 'Mở app xem lại.'),
    ('Vẫn còn nghĩ tới món đó?', 'Cho mình thêm một nhịp dừng nhé.'),
    ('Crush cũ ghé thăm.', 'Giờ còn mê không?'),
    ('Một món đang chờ bạn.', 'Mở app xem cảm giác còn như cũ không.'),
  ];

  static (String title, String body) selectFor(
    CrushCard card, {
    required bool detailMode,
    DateTime? now,
  }) {
    final daysAgo = _daysSince(card.createdAt, now ?? DateTime.now());
    final reason = card.reason?.label;
    final hasReason = reason != null && reason.isNotEmpty && daysAgo > 0;
    final name = card.name?.trim();

    if (detailMode && name != null && name.isNotEmpty) {
      return (
        'Còn mê $name không?',
        hasReason
            ? _recallBody(daysAgo, reason)
            : _detailBody(card.daysOfWageSnapshot),
      );
    }

    if (!detailMode && hasReason) {
      return ('Còn mê không?', _recallBody(daysAgo, reason));
    }

    return _pool[card.id.hashCode.abs() % _pool.length];
  }

  static String _detailBody(double days) {
    final d = days < 1 ? days.toStringAsFixed(1) : days.round().toString();
    return 'Món này từng lấy của bạn $d ngày đi làm.';
  }

  static String _recallBody(int daysAgo, String reason) {
    return '$daysAgo ngày trước bạn muốn mua vì: "$reason". Giờ còn mê không?';
  }

  static int _daysSince(DateTime createdAt, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final days = today.difference(createdDay).inDays;
    return days < 0 ? 0 : days;
  }
}
