import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/calc/wage_calculator.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';

void main() {
  final updatedAt = DateTime(2026, 5, 29);

  CalcException calcException(Object error) => error as CalcException;

  group('WageCalculator worked examples', () {
    test('example A - monthly income', () {
      final profile = IncomeProfile(
        mode: IncomeMode.monthly,
        monthlyNetIncome: 15000000,
        workDaysPerMonth: 22,
        workHoursPerDay: 8,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(3000000);

      expect(result.daysOfWage, closeTo(4.4, 0.05));
      expect(result.hoursOfWork, closeTo(35.2, 0.05));
      expect(result.pctOfMonthlyIncome, closeTo(20.0, 0.1));
    });

    test('example B - hourly income', () {
      final profile = IncomeProfile(
        mode: IncomeMode.hourly,
        hourlyIncome: 100000,
        workHoursPerDay: 8,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(499000);

      expect(result.daysOfWage, closeTo(0.62, 0.05));
      expect(result.hoursOfWork, closeTo(4.99, 0.05));
      expect(result.pctOfMonthlyIncome, closeTo(2.83, 0.1));
    });

    test('example C - daily income', () {
      final profile = IncomeProfile(
        mode: IncomeMode.daily,
        dailyIncome: 700000,
        workHoursPerDay: 8,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(1200000);

      expect(result.daysOfWage, closeTo(1.71, 0.05));
      expect(result.hoursOfWork, closeTo(13.7, 0.05));
      expect(result.pctOfMonthlyIncome, closeTo(7.8, 0.1));
    });

    test('example D - project income with only total hours', () {
      final profile = IncomeProfile(
        mode: IncomeMode.project,
        projectIncome: 20000000,
        projectTotalHours: 160,
        workHoursPerDay: 8,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(2000000);

      expect(result.daysOfWage, closeTo(2.0, 0.05));
      expect(result.hoursOfWork, closeTo(16.0, 0.05));
    });

    test('example E - cost per use', () {
      final profile = IncomeProfile(
        mode: IncomeMode.daily,
        dailyIncome: 700000,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(
        1200000,
        expectedUses: 104,
      );

      expect(result.costPerUse, closeTo(11538.46, 0.05));
    });
  });

  group('WageCalculator edge cases', () {
    test('throws noIncome when daily wage cannot be computed', () {
      final profile = IncomeProfile(
        mode: IncomeMode.monthly,
        monthlyNetIncome: 0,
        workDaysPerMonth: 22,
        updatedAt: updatedAt,
      );

      expect(
        () => WageCalculator(profile),
        throwsA(
          isA<CalcException>().having(
            (error) => error.error,
            'error',
            CalcError.noIncome,
          ),
        ),
      );
    });

    test('throws invalidPrice when price is zero', () {
      final calculator = WageCalculator(
        IncomeProfile(
          mode: IncomeMode.monthly,
          monthlyNetIncome: 15000000,
          updatedAt: updatedAt,
        ),
      );

      expect(
        () => calculator.check(0),
        throwsA(
          isA<CalcException>().having(
            (error) => calcException(error).error,
            'error',
            CalcError.invalidPrice,
          ),
        ),
      );
    });

    test('throws invalidPrice when price is negative', () {
      final calculator = WageCalculator(
        IncomeProfile(
          mode: IncomeMode.monthly,
          monthlyNetIncome: 15000000,
          updatedAt: updatedAt,
        ),
      );

      expect(
        () => calculator.check(-1),
        throwsA(
          isA<CalcException>().having(
            (error) => calcException(error).error,
            'error',
            CalcError.invalidPrice,
          ),
        ),
      );
    });

    test('handles very large prices without NaN or Infinity', () {
      final profile = IncomeProfile(
        mode: IncomeMode.monthly,
        monthlyNetIncome: 15000000,
        workDaysPerMonth: 22,
        workHoursPerDay: 8,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(5000000000);

      expect(result.daysOfWage, closeTo(7333.3, 0.05));
      expect(result.daysOfWage.isNaN, isFalse);
      expect(result.daysOfWage.isInfinite, isFalse);
    });

    test('hourly mode without work hours is rejected as noIncome', () {
      final profile = IncomeProfile(
        mode: IncomeMode.hourly,
        hourlyIncome: 100000,
        workHoursPerDay: 0,
        updatedAt: updatedAt,
      );

      expect(
        () => WageCalculator(profile),
        throwsA(
          isA<CalcException>().having(
            (error) => error.error,
            'error',
            CalcError.noIncome,
          ),
        ),
      );
    });

    test('missing work hours returns null hoursOfWork when daily wage exists',
        () {
      final profile = IncomeProfile(
        mode: IncomeMode.daily,
        dailyIncome: 700000,
        workHoursPerDay: 0,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(1200000);

      expect(result.hoursOfWork, isNull);
    });

    test('project with total days and hours uses each matching basis', () {
      final profile = IncomeProfile(
        mode: IncomeMode.project,
        projectIncome: 20000000,
        projectTotalDays: 20,
        projectTotalHours: 160,
        workHoursPerDay: 8,
        updatedAt: updatedAt,
      );

      final calculator = WageCalculator(profile);

      expect(calculator.basis.dailyWage, closeTo(1000000, 0.05));
      expect(calculator.basis.hourlyWage, closeTo(125000, 0.05));
    });

    test('expectedUses below one returns null costPerUse', () {
      final profile = IncomeProfile(
        mode: IncomeMode.daily,
        dailyIncome: 700000,
        updatedAt: updatedAt,
      );

      final result = WageCalculator(profile).check(
        1200000,
        expectedUses: 0.5,
      );

      expect(result.costPerUse, isNull);
    });
  });
}
