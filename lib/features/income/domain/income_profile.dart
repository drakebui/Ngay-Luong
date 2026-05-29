// lib/features/income/domain/income_profile.dart
//
// Domain model thu nhập. Plain immutable Dart, không phụ thuộc Flutter/Drift.
// Lưu trong SECURE STORAGE dưới dạng JSON (KHÔNG vào DB thường, KHÔNG log).

enum IncomeMode { monthly, daily, hourly, project }

class IncomeProfile {
  final IncomeMode mode;

  final double? monthlyNetIncome; // mode = monthly
  final double? dailyIncome; // mode = daily
  final double? hourlyIncome; // mode = hourly
  final double? projectIncome; // mode = project
  final double? projectTotalHours; // mode = project (1 trong 2)
  final double? projectTotalDays; // mode = project (1 trong 2)

  final int workDaysPerMonth; // default 22
  final double workHoursPerDay; // default 8
  final String currency; // default "VND"
  final DateTime updatedAt;

  const IncomeProfile({
    required this.mode,
    this.monthlyNetIncome,
    this.dailyIncome,
    this.hourlyIncome,
    this.projectIncome,
    this.projectTotalHours,
    this.projectTotalDays,
    this.workDaysPerMonth = 22,
    this.workHoursPerDay = 8,
    this.currency = 'VND',
    required this.updatedAt,
  });

  IncomeProfile copyWith({
    IncomeMode? mode,
    double? monthlyNetIncome,
    double? dailyIncome,
    double? hourlyIncome,
    double? projectIncome,
    double? projectTotalHours,
    double? projectTotalDays,
    int? workDaysPerMonth,
    double? workHoursPerDay,
    String? currency,
    DateTime? updatedAt,
  }) {
    return IncomeProfile(
      mode: mode ?? this.mode,
      monthlyNetIncome: monthlyNetIncome ?? this.monthlyNetIncome,
      dailyIncome: dailyIncome ?? this.dailyIncome,
      hourlyIncome: hourlyIncome ?? this.hourlyIncome,
      projectIncome: projectIncome ?? this.projectIncome,
      projectTotalHours: projectTotalHours ?? this.projectTotalHours,
      projectTotalDays: projectTotalDays ?? this.projectTotalDays,
      workDaysPerMonth: workDaysPerMonth ?? this.workDaysPerMonth,
      workHoursPerDay: workHoursPerDay ?? this.workHoursPerDay,
      currency: currency ?? this.currency,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'monthlyNetIncome': monthlyNetIncome,
        'dailyIncome': dailyIncome,
        'hourlyIncome': hourlyIncome,
        'projectIncome': projectIncome,
        'projectTotalHours': projectTotalHours,
        'projectTotalDays': projectTotalDays,
        'workDaysPerMonth': workDaysPerMonth,
        'workHoursPerDay': workHoursPerDay,
        'currency': currency,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory IncomeProfile.fromJson(Map<String, dynamic> json) {
    return IncomeProfile(
      mode: IncomeMode.values.byName(json['mode'] as String),
      monthlyNetIncome: (json['monthlyNetIncome'] as num?)?.toDouble(),
      dailyIncome: (json['dailyIncome'] as num?)?.toDouble(),
      hourlyIncome: (json['hourlyIncome'] as num?)?.toDouble(),
      projectIncome: (json['projectIncome'] as num?)?.toDouble(),
      projectTotalHours: (json['projectTotalHours'] as num?)?.toDouble(),
      projectTotalDays: (json['projectTotalDays'] as num?)?.toDouble(),
      workDaysPerMonth: (json['workDaysPerMonth'] as num?)?.toInt() ?? 22,
      workHoursPerDay: (json['workHoursPerDay'] as num?)?.toDouble() ?? 8,
      currency: json['currency'] as String? ?? 'VND',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Đủ dữ liệu tối thiểu để tính lương ngày chưa?
  bool get isUsable {
    switch (mode) {
      case IncomeMode.monthly:
        return (monthlyNetIncome ?? 0) > 0 && workDaysPerMonth > 0;
      case IncomeMode.daily:
        return (dailyIncome ?? 0) > 0;
      case IncomeMode.hourly:
        return (hourlyIncome ?? 0) > 0 && workHoursPerDay > 0;
      case IncomeMode.project:
        final hasUnit = (projectTotalDays ?? 0) > 0 || (projectTotalHours ?? 0) > 0;
        return (projectIncome ?? 0) > 0 && hasUnit;
    }
  }
}
