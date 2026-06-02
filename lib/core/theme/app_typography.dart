import 'package:flutter/material.dart';

/// Typography scale — Be Vietnam Pro, Midnight Matcha.
/// Source: docs/06_DESIGN_SYSTEM.md §2.
/// Colors NOT included — apply via DefaultTextStyle or TextStyle.copyWith at call site.
abstract final class AppTypography {
  // ── Hero (product-specific, override Stitch scale) ───────────────────────

  /// Con số ngày lương — phần tử TO NHẤT màn hình. 64sp/w800.
  static const TextStyle heroNumber = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 68 / 64,
    letterSpacing: -2,
  );

  /// "ngày đi làm" kề bên hero. 20sp/w600.
  static const TextStyle heroUnit = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: 0,
  );

  // ── Display / Headline ────────────────────────────────────────────────────

  /// Tiêu đề màn kết quả lớn. 40sp/w700. (Stitch: headline-xl)
  static const TextStyle displayLg = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -0.8,
  );

  /// Tiêu đề section (desktop). 32sp/w700. (Stitch: headline-lg)
  static const TextStyle headlineLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.32,
  );

  /// Brand name AppBar, onboarding header. 28sp/w700. (Stitch: headline-lg-mobile)
  static const TextStyle headlineLgMobile = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    letterSpacing: 0,
  );

  /// Tiêu đề card, tên màn. 24sp/w600. (Stitch: headline-md)
  static const TextStyle headlineMd = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: 0,
  );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// Input giá, sub-kết quả, label bên trong card lớn. 18sp/w400. (Stitch: body-lg)
  static const TextStyle bodyLg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    letterSpacing: 0,
  );

  /// Nội dung chính, mô tả. 16sp/w400. (Stitch: body-md)
  static const TextStyle bodyMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
  );

  // ── Label ─────────────────────────────────────────────────────────────────

  /// Button, tab label, input label. 14sp/w600/+0.02em. (Stitch: label-md)
  static const TextStyle labelMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.28,
  );

  /// Caption, privacy banner, chip nhỏ. 12sp/w500/+0.05em. (Stitch: label-sm)
  static const TextStyle labelSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.6,
  );

  // ── Special ───────────────────────────────────────────────────────────────

  /// Text field nhập giá lớn (input surface, không phải hero). 32sp/w600.
  static const TextStyle priceInput = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 38 / 32,
    letterSpacing: -0.32,
  );

  // ── Aliases (backward compat) ─────────────────────────────────────────────

  static const TextStyle title = headlineMd;
  static const TextStyle body = bodyMd;
  static const TextStyle label = labelMd;
  static const TextStyle caption = labelSm;
}
