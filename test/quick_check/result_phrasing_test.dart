import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/calc/wage_calculator.dart';
import 'package:ngay_luong/features/quick_check/domain/result_phrasing.dart';

CheckResult _result({
  required double days,
  double? hours,
  double? pct,
}) =>
    CheckResult(
      price: 1000000,
      daysOfWage: days,
      hoursOfWork: hours,
      pctOfMonthlyIncome: pct,
    );

void main() {
  group('ResultPhrasing.select', () {
    test('tiny khi < 0.3 ngày', () {
      expect(
        ResultPhrasing.select(_result(days: 0.29)),
        PhrasingVariant.tiny,
      );
      expect(
        ResultPhrasing.select(_result(days: 0.1)),
        PhrasingVariant.tiny,
      );
    });

    test('tiny ngay tại ranh giới 0.3 → không phải tiny', () {
      expect(
        ResultPhrasing.select(_result(days: 0.3)),
        PhrasingVariant.normal,
      );
    });

    test('normal khi 0.3 <= days < 5 và pct < 30', () {
      expect(
        ResultPhrasing.select(_result(days: 1.5, pct: 10)),
        PhrasingVariant.normal,
      );
      expect(
        ResultPhrasing.select(_result(days: 4.9, pct: 20)),
        PhrasingVariant.normal,
      );
    });

    test('heavy khi >= 5 ngày', () {
      expect(
        ResultPhrasing.select(_result(days: 5.0, pct: 20)),
        PhrasingVariant.heavy,
      );
      expect(
        ResultPhrasing.select(_result(days: 10.0)),
        PhrasingVariant.heavy,
      );
    });

    test('heavy khi pct >= 30 dù ngày < 5', () {
      expect(
        ResultPhrasing.select(_result(days: 3.0, pct: 30.0)),
        PhrasingVariant.heavy,
      );
      expect(
        ResultPhrasing.select(_result(days: 1.0, pct: 50.0)),
        PhrasingVariant.heavy,
      );
    });

    test('normal khi pct null (không đủ dữ liệu monthly)', () {
      expect(
        ResultPhrasing.select(_result(days: 4.0, pct: null)),
        PhrasingVariant.normal,
      );
    });

    test('heavy khi pct null nhưng ngày >= 5', () {
      expect(
        ResultPhrasing.select(_result(days: 5.0, pct: null)),
        PhrasingVariant.heavy,
      );
    });
  });
}
