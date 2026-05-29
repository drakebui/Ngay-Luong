import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/crush/domain/remind_at_calculator.dart';

void main() {
  group('RemindAtCalculator', () {
    test('tonight before 20:00 returns today at 20:00', () {
      final now = DateTime(2026, 5, 29, 18, 30);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.tonight,
        now: now,
      );

      expect(result, DateTime(2026, 5, 29, 20));
    });

    test('tonight after 20:00 returns now plus 2 hours', () {
      final now = DateTime(2026, 5, 29, 21, 15);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.tonight,
        now: now,
      );

      expect(
        result.difference(now.add(const Duration(hours: 2))).inSeconds.abs(),
        lessThanOrEqualTo(60),
      );
    });

    test('after24h returns now plus 24 hours', () {
      final now = DateTime(2026, 5, 29, 9, 45);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.after24h,
        now: now,
      );

      expect(
        result.difference(now.add(const Duration(hours: 24))).inSeconds.abs(),
        lessThanOrEqualTo(60),
      );
    });

    test('after3Days returns 3 days later at 20:00', () {
      final now = DateTime(2026, 5, 29, 9, 45);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.after3Days,
        now: now,
      );

      expect(result, DateTime(2026, 6, 1, 20));
    });

    test('after7Days returns 7 days later at 20:00', () {
      final now = DateTime(2026, 5, 29, 9, 45);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.after7Days,
        now: now,
      );

      expect(result, DateTime(2026, 6, 5, 20));
    });

    test('untilPayday before payday returns this month at 20:00', () {
      final now = DateTime(2026, 5, 3, 12);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.untilPayday,
        now: now,
        paydayDay: 5,
      );

      expect(result, DateTime(2026, 5, 5, 20));
    });

    test('untilPayday on or after payday returns next month at 20:00', () {
      final now = DateTime(2026, 5, 5, 12);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.untilPayday,
        now: now,
        paydayDay: 5,
      );

      expect(result, DateTime(2026, 6, 5, 20));
    });

    test('untilPayday clamps to last day when month is shorter', () {
      // paydayDay=31, tháng 6 chỉ có 30 ngày → clamp về 30
      final now = DateTime(2026, 6, 1, 10);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.untilPayday,
        now: now,
        paydayDay: 31,
      );

      expect(result, DateTime(2026, 6, 30, 20));
    });

    test('untilPayday in December wraps to January next year', () {
      final now = DateTime(2026, 12, 10, 10);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.untilPayday,
        now: now,
        paydayDay: 5,
      );

      expect(result, DateTime(2027, 1, 5, 20));
    });

    test('custom preset returns provided datetime', () {
      final now = DateTime(2026, 5, 29, 9);
      final custom = DateTime(2026, 6, 15, 19, 30);

      final result = RemindAtCalculator.calculate(
        preset: ReminderPreset.custom,
        now: now,
        customDateTime: custom,
      );

      expect(result, custom);
    });

    test('custom preset without customDateTime throws ArgumentError', () {
      final now = DateTime(2026, 5, 29, 9);

      expect(
        () => RemindAtCalculator.calculate(
          preset: ReminderPreset.custom,
          now: now,
        ),
        throwsArgumentError,
      );
    });
  });
}
