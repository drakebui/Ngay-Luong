// lib/features/crush/domain/crush_models.dart
//
// Domain model cho Crush Card + các enum. Plain immutable Dart.
// Lưu trong Drift (SQLite). Ảnh lưu file local, DB chỉ giữ imagePath.
// String tiếng Việt khớp docs/07_COPY_VI.md.

enum CrushReason {
  reallyNeed,
  onSale,
  sawReview,
  tiktokMadeMeWeak,
  treatMyself,
  stress,
  justLikeIt,
}

extension CrushReasonLabel on CrushReason {
  String get label {
    switch (this) {
      case CrushReason.reallyNeed:
        return 'Cần thật';
      case CrushReason.onSale:
        return 'Đang sale';
      case CrushReason.sawReview:
        return 'Thấy review';
      case CrushReason.tiktokMadeMeWeak:
        return 'TikTok làm tôi yếu lòng';
      case CrushReason.treatMyself:
        return 'Tự thưởng';
      case CrushReason.stress:
        return 'Stress';
      case CrushReason.justLikeIt:
        return 'Không biết nữa, thấy thích';
    }
  }
}

enum CrushStatus {
  crushing,
  sleepOnIt,
  stillCrushing,
  overIt,
  waitingForSale,
  bought,
  skipped,
}

extension CrushStatusLabel on CrushStatus {
  String get label {
    switch (this) {
      case CrushStatus.crushing:
        return 'Đang mê';
      case CrushStatus.sleepOnIt:
        return 'Để mai tính';
      case CrushStatus.stillCrushing:
        return 'Vẫn mê';
      case CrushStatus.overIt:
        return 'Hết mê';
      case CrushStatus.waitingForSale:
        return 'Chờ sale';
      case CrushStatus.bought:
        return 'Đã mua';
      case CrushStatus.skipped:
        return 'Đã bỏ qua';
    }
  }

  /// Trạng thái này có cộng vào Anti-haul ("ngày lương không bay màu") không?
  bool get countsAsSaved =>
      this == CrushStatus.overIt || this == CrushStatus.skipped;

  /// Còn đang treo (chờ quyết định)?
  bool get isPending =>
      this == CrushStatus.crushing ||
      this == CrushStatus.sleepOnIt ||
      this == CrushStatus.stillCrushing ||
      this == CrushStatus.waitingForSale;
}

class CrushCard {
  final String id;
  final String? name;
  final double price;
  final String? category;
  final String? imagePath;

  // Snapshot tại thời điểm tạo (vì thu nhập có thể đổi sau này).
  final double daysOfWageSnapshot;
  final double hoursOfWorkSnapshot;
  final double? pctOfMonthlyIncomeSnapshot;

  final CrushReason? reason;
  final String? mood;
  final String? note;

  final CrushStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? remindAt;
  final int remindCount;

  const CrushCard({
    required this.id,
    this.name,
    required this.price,
    this.category,
    this.imagePath,
    required this.daysOfWageSnapshot,
    required this.hoursOfWorkSnapshot,
    this.pctOfMonthlyIncomeSnapshot,
    this.reason,
    this.mood,
    this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.remindAt,
    this.remindCount = 0,
  });

  CrushCard copyWith({
    String? name,
    double? price,
    String? category,
    String? imagePath,
    bool clearImage = false,
    double? daysOfWageSnapshot,
    double? hoursOfWorkSnapshot,
    double? pctOfMonthlyIncomeSnapshot,
    CrushReason? reason,
    String? mood,
    String? note,
    CrushStatus? status,
    DateTime? updatedAt,
    DateTime? remindAt,
    bool clearRemindAt = false,
    int? remindCount,
  }) {
    return CrushCard(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      daysOfWageSnapshot: daysOfWageSnapshot ?? this.daysOfWageSnapshot,
      hoursOfWorkSnapshot: hoursOfWorkSnapshot ?? this.hoursOfWorkSnapshot,
      pctOfMonthlyIncomeSnapshot:
          pctOfMonthlyIncomeSnapshot ?? this.pctOfMonthlyIncomeSnapshot,
      reason: reason ?? this.reason,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remindAt: clearRemindAt ? null : (remindAt ?? this.remindAt),
      remindCount: remindCount ?? this.remindCount,
    );
  }
}
