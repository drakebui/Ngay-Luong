import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/utils/formatters.dart';

void main() {
  group('AppFormatters', () {
    test('formats days', () {
      expect(AppFormatters.formatDays(4.4), '4,4 ngày');
      expect(AppFormatters.formatDays(0.7), '0,7 ngày');
      expect(AppFormatters.formatDays(0.05), '<0,1 ngày');
      expect(AppFormatters.formatDays(120.0), '120 ngày');
    });

    test('formats hours', () {
      expect(AppFormatters.formatHours(35.2), '35,2 giờ');
      expect(AppFormatters.formatHours(4.99), '5,0 giờ');
    });

    test('formats percentages', () {
      expect(AppFormatters.formatPct(20.0), '20%');
      expect(AppFormatters.formatPct(3.4), '3,4%');
      expect(AppFormatters.formatPct(2.83), '2,8%');
    });

    test('formats money', () {
      expect(AppFormatters.formatMoney(3000000), '3.000.000đ');
      expect(AppFormatters.formatMoney(499000), '499.000đ');
    });

    test('formats cost per use', () {
      expect(AppFormatters.formatCostPerUse(11538.46), '~11.500đ/lần');
      expect(AppFormatters.formatCostPerUse(double.infinity), '—');
    });

    test('parses prices', () {
      expect(AppFormatters.parsePrice('3.000.000'), 3000000.0);
      expect(AppFormatters.parsePrice('3000000'), 3000000.0);
      expect(AppFormatters.parsePrice('3.000.000đ'), 3000000.0);
      expect(AppFormatters.parsePrice('3 000 000'), 3000000.0);
      expect(AppFormatters.parsePrice('abc'), isNull);
      expect(AppFormatters.parsePrice('0'), isNull);
      expect(AppFormatters.parsePrice('Infinity'), isNull);
    });
  });
}
