import 'package:ngay_luong/core/calc/wage_calculator.dart';

enum PhrasingVariant { normal, heavy, tiny }
// onSale: dùng khi user đánh dấu giá sale (M4+)

abstract final class ResultPhrasing {
  /// Chọn variant dựa trên ngưỡng ngày lương và % thu nhập tháng.
  /// heavy khi >= 5 ngày HOẶC >= 30% thu nhập tháng.
  /// tiny khi < 0.3 ngày.
  static PhrasingVariant select(CheckResult result) {
    if (result.daysOfWage < 0.3) return PhrasingVariant.tiny;
    final pct = result.pctOfMonthlyIncome;
    if (result.daysOfWage >= 5 || (pct != null && pct >= 30)) {
      return PhrasingVariant.heavy;
    }
    return PhrasingVariant.normal;
  }
}
