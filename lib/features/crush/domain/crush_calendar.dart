import 'package:ngay_luong/features/crush/domain/crush_models.dart';

enum CrushCalendarStatusFilter {
  pending,
  overIt,
  bought,
  all,
}

class CrushCalendarDayGroup {
  const CrushCalendarDayGroup({
    required this.day,
    required this.cards,
  });

  final DateTime day;
  final List<CrushCard> cards;
}

class CrushCalendarView {
  const CrushCalendarView({
    required this.todayCards,
    required this.upcomingGroups,
    required this.monthReminderDays,
  });

  final List<CrushCard> todayCards;
  final List<CrushCalendarDayGroup> upcomingGroups;

  /// Distinct reminder days for the selected month.
  ///
  /// Keep this intentionally date-only so Month overview cannot expose names,
  /// price, images, or wage snapshots.
  final List<DateTime> monthReminderDays;
}

abstract final class CrushCalendarBuilder {
  static CrushCalendarView build({
    required List<CrushCard> cards,
    required DateTime now,
    required DateTime visibleMonth,
    required CrushCalendarStatusFilter filter,
  }) {
    final filteredCards = cards.where((card) => _matchesFilter(card, filter));
    final today = _dateOnly(now);
    final startOfTomorrow = today.add(const Duration(days: 1));
    final monthStart = DateTime(visibleMonth.year, visibleMonth.month);
    final nextMonth = DateTime(visibleMonth.year, visibleMonth.month + 1);

    final todayCards = <CrushCard>[];
    final upcomingByDay = <DateTime, List<CrushCard>>{};
    final monthDays = <DateTime>{};

    for (final card in filteredCards) {
      final remindAt = card.remindAt;
      if (remindAt == null) continue;

      final remindDay = _dateOnly(remindAt);
      if (remindDay == today) {
        todayCards.add(card);
      }

      if (!remindDay.isBefore(startOfTomorrow)) {
        upcomingByDay.putIfAbsent(remindDay, () => <CrushCard>[]).add(card);
      }

      if (!remindDay.isBefore(monthStart) && remindDay.isBefore(nextMonth)) {
        monthDays.add(remindDay);
      }
    }

    todayCards.sort(_byReminderThenCreatedAt);
    final upcomingGroups = upcomingByDay.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return CrushCalendarView(
      todayCards: todayCards,
      upcomingGroups: [
        for (final entry in upcomingGroups)
          CrushCalendarDayGroup(
            day: entry.key,
            cards: entry.value..sort(_byReminderThenCreatedAt),
          ),
      ],
      monthReminderDays: monthDays.toList()..sort(),
    );
  }

  static bool _matchesFilter(
    CrushCard card,
    CrushCalendarStatusFilter filter,
  ) {
    switch (filter) {
      case CrushCalendarStatusFilter.pending:
        return card.status.isPending;
      case CrushCalendarStatusFilter.overIt:
        return card.status == CrushStatus.overIt ||
            card.status == CrushStatus.skipped;
      case CrushCalendarStatusFilter.bought:
        return card.status == CrushStatus.bought;
      case CrushCalendarStatusFilter.all:
        return true;
    }
  }

  static int _byReminderThenCreatedAt(CrushCard a, CrushCard b) {
    final aRemindAt = a.remindAt;
    final bRemindAt = b.remindAt;
    if (aRemindAt != null && bRemindAt != null) {
      final remindCompare = aRemindAt.compareTo(bRemindAt);
      if (remindCompare != 0) return remindCompare;
    }
    if (aRemindAt == null && bRemindAt != null) return 1;
    if (aRemindAt != null && bRemindAt == null) return -1;
    return b.createdAt.compareTo(a.createdAt);
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
