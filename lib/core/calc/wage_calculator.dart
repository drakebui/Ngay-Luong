// lib/core/calc/wage_calculator.dart
//
// SINGLE SOURCE OF TRUTH cho mọi quy đổi tiền <-> thời gian đi làm.
// Pure Dart, không phụ thuộc Flutter. Mọi nơi cần quy đổi PHẢI gọi class này.
// Logic khớp 1:1 với docs/04_CALCULATIONS.md. Sửa ở đây phải sửa cả doc + test.

import 'package:ngay_luong/features/income/domain/income_profile.dart';

/// Lỗi tính toán có ngữ nghĩa rõ ràng (UI dựa vào đây để điều hướng/ẩn dòng).
enum CalcError { noIncome, invalidPrice }

class CalcException implements Exception {
  final CalcError error;
  const CalcException(this.error);
  @override
  String toString() => 'CalcException($error)';
}

/// Giá trị nền tảng dẫn xuất từ IncomeProfile.
class WageBasis {
  final double dailyWage; // luôn > 0
  final double? hourlyWage; // null nếu không biết số giờ
  final double? monthlyIncomeEstimate; // null nếu không ước tính được

  const WageBasis({
    required this.dailyWage,
    required this.hourlyWage,
    required this.monthlyIncomeEstimate,
  });
}

/// Kết quả quy đổi một mức giá.
class CheckResult {
  final double price;
  final double daysOfWage;
  final double? hoursOfWork;
  final double? pctOfMonthlyIncome;
  final double? costPerUse;

  const CheckResult({
    required this.price,
    required this.daysOfWage,
    required this.hoursOfWork,
    required this.pctOfMonthlyIncome,
    this.costPerUse,
  });
}

class WageCalculator {
  final IncomeProfile profile;
  late final WageBasis _basis;

  WageCalculator(this.profile) {
    _basis = _computeBasis(profile);
    if (_basis.dailyWage <= 0 ||
        _basis.dailyWage.isNaN ||
        _basis.dailyWage.isInfinite) {
      throw const CalcException(CalcError.noIncome);
    }
  }

  WageBasis get basis => _basis;

  /// Quy đổi một mức giá thành ngày/giờ/% (và cost-per-use nếu có expectedUses).
  CheckResult check(double price, {double? expectedUses}) {
    if (price.isNaN || price.isInfinite || price <= 0) {
      throw const CalcException(CalcError.invalidPrice);
    }

    final days = price / _basis.dailyWage;

    final hours = (_basis.hourlyWage != null && _basis.hourlyWage! > 0)
        ? price / _basis.hourlyWage!
        : null;

    final pct = (_basis.monthlyIncomeEstimate != null &&
            _basis.monthlyIncomeEstimate! > 0)
        ? price / _basis.monthlyIncomeEstimate! * 100
        : null;

    final cpu = (expectedUses != null && expectedUses >= 1)
        ? price / expectedUses
        : null;

    return CheckResult(
      price: price,
      daysOfWage: days,
      hoursOfWork: hours,
      pctOfMonthlyIncome: pct,
      costPerUse: cpu,
    );
  }

  /// Số lần cần dùng để đạt mức "giá mỗi lần dùng chấp nhận được".
  double usesToWorthIt(double price, double acceptablePricePerUse) {
    if (acceptablePricePerUse <= 0) {
      throw const CalcException(CalcError.invalidPrice);
    }
    return price / acceptablePricePerUse;
  }

  // ---- internal ----

  static WageBasis _computeBasis(IncomeProfile p) {
    final daysPerMonth = p.workDaysPerMonth.toDouble();
    final hoursPerDay = p.workHoursPerDay;

    double? dailyWage;
    double? hourlyWage;
    double? monthly;

    switch (p.mode) {
      case IncomeMode.monthly:
        final m = p.monthlyNetIncome;
        if (m != null && daysPerMonth > 0) {
          dailyWage = m / daysPerMonth;
          monthly = m;
          if (hoursPerDay > 0) hourlyWage = m / (daysPerMonth * hoursPerDay);
        }
        break;

      case IncomeMode.daily:
        final d = p.dailyIncome;
        if (d != null) {
          dailyWage = d;
          if (hoursPerDay > 0) hourlyWage = d / hoursPerDay;
          if (daysPerMonth > 0) monthly = d * daysPerMonth;
        }
        break;

      case IncomeMode.hourly:
        final h = p.hourlyIncome;
        if (h != null && hoursPerDay > 0) {
          hourlyWage = h;
          dailyWage = h * hoursPerDay;
          if (daysPerMonth > 0) monthly = h * hoursPerDay * daysPerMonth;
        }
        break;

      case IncomeMode.project:
        final pi = p.projectIncome;
        if (pi != null) {
          if (p.projectTotalDays != null && p.projectTotalDays! > 0) {
            dailyWage = pi / p.projectTotalDays!;
            if (hoursPerDay > 0) hourlyWage = dailyWage / hoursPerDay;
          }
          if (p.projectTotalHours != null && p.projectTotalHours! > 0) {
            hourlyWage = pi / p.projectTotalHours!;
            dailyWage ??= (hoursPerDay > 0) ? hourlyWage * hoursPerDay : dailyWage;
          }
          if (dailyWage != null && daysPerMonth > 0) {
            monthly = dailyWage * daysPerMonth;
          }
        }
        break;
    }

    return WageBasis(
      dailyWage: dailyWage ?? 0,
      hourlyWage: hourlyWage,
      monthlyIncomeEstimate: monthly,
    );
  }
}
