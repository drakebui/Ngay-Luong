import 'package:intl/intl.dart';

/// Single source of truth cho mọi hiển thị số trong app.
class AppFormatters {
  AppFormatters._();

  static final NumberFormat _oneDecimal = NumberFormat('#,##0.0', 'vi_VN');
  static final NumberFormat _wholeNumber = NumberFormat('#,##0', 'vi_VN');

  /// daysOfWage: 1 chữ số thập phân, locale vi.
  /// Nếu < 0.1 -> "<0,1 ngày". Nếu >= 100 -> 0 thập phân.
  static String formatDays(double days) {
    if (!days.isFinite) return '—';
    if (days < 0.1) {
      return '<0,1 ngày';
    }

    final formatter = days >= 100 ? _wholeNumber : _oneDecimal;
    return '${formatter.format(days)} ngày';
  }

  /// hoursOfWork: luôn 1 chữ số thập phân.
  static String formatHours(double hours) {
    if (!hours.isFinite) return '—';
    return '${_oneDecimal.format(hours)} giờ';
  }

  /// pctOfMonthlyIncome: 0 thập phân nếu >= 10; 1 thập phân nếu < 10.
  static String formatPct(double pct) {
    if (!pct.isFinite) return '—';
    final formatter = pct >= 10 ? _wholeNumber : _oneDecimal;
    return '${formatter.format(pct)}%';
  }

  /// Tiền VND: tách nghìn bằng ".", hậu tố "đ", không thập phân.
  static String formatMoney(double amount) {
    if (!amount.isFinite) return '—';
    return '${_wholeNumber.format(amount)}đ';
  }

  /// costPerUse: làm tròn tới hàng trăm gần nhất, hậu tố "đ/lần".
  static String formatCostPerUse(double cost) {
    if (!cost.isFinite) return '—';
    final rounded = (cost / 100).round() * 100;
    return '~${formatMoney(rounded.toDouble())}/lần';
  }

  static String formatClockTime(DateTime dateTime) {
    return DateFormat('HH:mm', 'vi_VN').format(dateTime);
  }

  static String formatCalendarGroupDate(DateTime date) {
    return DateFormat('EEEE, d/M', 'vi_VN').format(date);
  }

  static String formatCalendarMonth(DateTime month) {
    return DateFormat('MMMM y', 'vi_VN').format(month);
  }

  static String formatCalendarWeekday(DateTime date) {
    return DateFormat.E('vi_VN').format(date);
  }

  /// Parse giá từ input của user: chấp nhận "3.000.000" hoặc "3000000".
  /// Trả null nếu không parse được hoặc <= 0.
  static double? parsePrice(String raw) {
    final normalized = raw
        .trim()
        .toLowerCase()
        .replaceAll('đ', '')
        .replaceAll('.', '')
        .replaceAll(' ', '');
    final parsed = double.tryParse(normalized);

    if (parsed == null || parsed <= 0 || !parsed.isFinite) {
      return null;
    }

    return parsed;
  }
}
