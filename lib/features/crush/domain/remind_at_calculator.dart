enum ReminderPreset {
  tonight,
  after24h,
  after3Days,
  after7Days,
  untilPayday,
  custom,
}

class RemindAtCalculator {
  const RemindAtCalculator._();

  static DateTime calculate({
    required ReminderPreset preset,
    required DateTime now,
    int paydayDay = 5,
    DateTime? customDateTime,
  }) {
    switch (preset) {
      case ReminderPreset.tonight:
        final tonight = DateTime(now.year, now.month, now.day, 20);
        if (now.isAfter(tonight)) {
          return now.add(const Duration(hours: 2));
        }
        return tonight;
      case ReminderPreset.after24h:
        return now.add(const Duration(hours: 24));
      case ReminderPreset.after3Days:
        final date = now.add(const Duration(days: 3));
        return DateTime(date.year, date.month, date.day, 20);
      case ReminderPreset.after7Days:
        final date = now.add(const Duration(days: 7));
        return DateTime(date.year, date.month, date.day, 20);
      case ReminderPreset.untilPayday:
        return _nextPayday(now, paydayDay);
      case ReminderPreset.custom:
        if (customDateTime == null) {
          throw ArgumentError.value(
            customDateTime,
            'customDateTime',
            'Custom reminder needs a DateTime.',
          );
        }
        return customDateTime;
    }
  }

  static DateTime _nextPayday(DateTime now, int paydayDay) {
    final clampedDay = paydayDay.clamp(1, 31);
    final thisMonthDay = _validDayInMonth(now.year, now.month, clampedDay);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    var candidate = DateTime(now.year, now.month, thisMonthDay, 20);
    if (candidate.isBefore(tomorrow)) {
      final nextMonth = DateTime(now.year, now.month + 1);
      final nextMonthDay = _validDayInMonth(
        nextMonth.year,
        nextMonth.month,
        clampedDay,
      );
      candidate = DateTime(nextMonth.year, nextMonth.month, nextMonthDay, 20);
    }

    return candidate;
  }

  static int _validDayInMonth(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return day > lastDay ? lastDay : day;
  }
}
