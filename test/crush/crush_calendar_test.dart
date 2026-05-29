import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/crush/domain/crush_calendar.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';

void main() {
  CrushCard card({
    required String id,
    required DateTime remindAt,
    CrushStatus status = CrushStatus.sleepOnIt,
  }) {
    return CrushCard(
      id: id,
      name: 'Tai nghe',
      price: 1200000,
      daysOfWageSnapshot: 1.7,
      hoursOfWorkSnapshot: 13.7,
      status: status,
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime(2026, 5, 1),
      remindAt: remindAt,
    );
  }

  test('builds today, upcoming groups, and month dot days from reminders', () {
    final view = CrushCalendarBuilder.build(
      cards: [
        card(id: 'today-late', remindAt: DateTime(2026, 5, 29, 20)),
        card(id: 'today-early', remindAt: DateTime(2026, 5, 29, 9)),
        card(id: 'tomorrow', remindAt: DateTime(2026, 5, 30, 20)),
        card(id: 'next-week', remindAt: DateTime(2026, 6, 2, 20)),
      ],
      now: DateTime(2026, 5, 29, 10),
      visibleMonth: DateTime(2026, 5),
      filter: CrushCalendarStatusFilter.pending,
    );

    expect(view.todayCards.map((c) => c.id), ['today-early', 'today-late']);
    expect(view.upcomingGroups.map((g) => g.day), [
      DateTime(2026, 5, 30),
      DateTime(2026, 6, 2),
    ]);
    expect(view.upcomingGroups.first.cards.map((c) => c.id), ['tomorrow']);
    expect(view.monthReminderDays, [
      DateTime(2026, 5, 29),
      DateTime(2026, 5, 30),
    ]);
  });

  test('filters pending, bought, and saved statuses', () {
    final cards = [
      card(id: 'pending', remindAt: DateTime(2026, 5, 29, 20)),
      card(
        id: 'bought',
        remindAt: DateTime(2026, 5, 29, 20),
        status: CrushStatus.bought,
      ),
      card(
        id: 'over',
        remindAt: DateTime(2026, 5, 29, 20),
        status: CrushStatus.overIt,
      ),
      card(
        id: 'skipped',
        remindAt: DateTime(2026, 5, 29, 20),
        status: CrushStatus.skipped,
      ),
    ];

    CrushCalendarView build(CrushCalendarStatusFilter filter) {
      return CrushCalendarBuilder.build(
        cards: cards,
        now: DateTime(2026, 5, 29, 10),
        visibleMonth: DateTime(2026, 5),
        filter: filter,
      );
    }

    expect(
      build(CrushCalendarStatusFilter.pending).todayCards.map((c) => c.id),
      ['pending'],
    );
    expect(
      build(CrushCalendarStatusFilter.bought).todayCards.map((c) => c.id),
      ['bought'],
    );
    expect(
      build(CrushCalendarStatusFilter.overIt).todayCards.map((c) => c.id),
      ['over', 'skipped'],
    );
    expect(
      build(CrushCalendarStatusFilter.all).todayCards.map((c) => c.id),
      ['pending', 'bought', 'over', 'skipped'],
    );
  });

  test('month overview exposes only distinct dates', () {
    final view = CrushCalendarBuilder.build(
      cards: [
        card(id: 'a', remindAt: DateTime(2026, 5, 10, 9)),
        card(id: 'b', remindAt: DateTime(2026, 5, 10, 20)),
        card(id: 'c', remindAt: DateTime(2026, 5, 12, 20)),
      ],
      now: DateTime(2026, 5, 1),
      visibleMonth: DateTime(2026, 5),
      filter: CrushCalendarStatusFilter.pending,
    );

    expect(view.monthReminderDays, [
      DateTime(2026, 5, 10),
      DateTime(2026, 5, 12),
    ]);
  });
}
