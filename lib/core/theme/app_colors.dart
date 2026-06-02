import 'package:flutter/material.dart';

/// Midnight Matcha — Organic Minimalism palette.
/// Source: docs/_stitch_export/DESIGN.md + docs/06_DESIGN_SYSTEM.md
/// Token names mirror Material3 role names for easy ColorScheme mapping.
abstract final class AppColors {
  // ── Light ────────────────────────────────────────────────────────────────

  /// Nền chính, sage-white nhẹ.
  static const Color background = Color(0xFFF4FAFD);

  /// Card / surface nổi cao nhất (surfaceContainerLowest).
  static const Color surface = Color(0xFFFFFFFF);

  /// Input field background (surfaceContainerLow).
  static const Color surfaceLow = Color(0xFFEEF5F7);

  /// Panel bên trong card (surfaceContainer).
  static const Color surfaceContainer = Color(0xFFE8EFF1);

  /// Hover state, divider cao (surfaceContainerHigh).
  static const Color surfaceHigh = Color(0xFFE2E9EC);

  /// Surface elevated / surface-variant (surfaceContainerHighest).
  static const Color surfaceHighest = Color(0xFFDDE4E6);

  /// Dim overlay.
  static const Color surfaceDim = Color(0xFFD4DBDD);

  static const Color onSurface = Color(0xFF161D1F);
  static const Color onSurfaceVariant = Color(0xFF414844);
  static const Color outline = Color(0xFF717973);
  static const Color outlineVariant = Color(0xFFC1C8C2);

  /// Deep forest green — brand, heading, icon chính.
  static const Color primary = Color(0xFF012D1D);
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Dark forest green — hero card bg, CTA bg.
  static const Color primaryContainer = Color(0xFF1B4332);
  static const Color onPrimaryContainer = Color(0xFF86AF99);

  /// Light sage — accent trong dark mode / trên dark bg.
  static const Color inversePrimary = Color(0xFFA5D0B9);

  static const Color primaryFixed = Color(0xFFC1ECD4);
  static const Color primaryFixedDim = Color(0xFFA5D0B9);
  static const Color onPrimaryFixed = Color(0xFF002114);
  static const Color onPrimaryFixedVariant = Color(0xFF274E3D);

  /// Muted sage — accent thứ cấp.
  static const Color secondary = Color(0xFF4B6454);
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// Chip/tag bg, day-count badge, decision button bg.
  static const Color secondaryContainer = Color(0xFFCBE7D2);
  static const Color onSecondaryContainer = Color(0xFF4F6858);

  static const Color secondaryFixed = Color(0xFFCDE9D5);
  static const Color secondaryFixedDim = Color(0xFFB2CDB9);
  static const Color onSecondaryFixed = Color(0xFF082013);
  static const Color onSecondaryFixedVariant = Color(0xFF344C3D);

  static const Color tertiary = Color(0xFF1F2825);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF353E3A);
  static const Color onTertiaryContainer = Color(0xFF9FA9A3);

  static const Color inverseSurface = Color(0xFF2B3234);
  static const Color inverseOnSurface = Color(0xFFEBF2F4);
  static const Color surfaceTint = Color(0xFF3F6653);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  /// "Chờ sale" warning — không dùng đỏ gắt.
  static const Color warning = Color(0xFFD9A521);

  // ── Dark ─────────────────────────────────────────────────────────────────

  static const Color backgroundDark = Color(0xFF0E1A13);
  static const Color surfaceDark = Color(0xFF161D1F);
  static const Color surfaceLowDark = Color(0xFF1A2520);
  static const Color surfaceContainerDark = Color(0xFF1E2B26);
  static const Color surfaceHighDark = Color(0xFF253229);
  static const Color surfaceHighestDark = Color(0xFF2D3B35);
  static const Color surfaceDimDark = Color(0xFF0B1410);

  static const Color onSurfaceDark = Color(0xFFE8F0EB);
  static const Color onSurfaceVariantDark = Color(0xFFB5C2BB);
  static const Color outlineDark = Color(0xFF8F9D96);
  static const Color outlineVariantDark = Color(0xFF414844);

  static const Color primaryDark = Color(0xFFA5D0B9);
  static const Color onPrimaryDark = Color(0xFF002114);
  static const Color primaryContainerDark = Color(0xFF274E3D);
  static const Color onPrimaryContainerDark = Color(0xFFC1ECD4);
  static const Color inversePrimaryDark = Color(0xFF012D1D);

  static const Color secondaryDark = Color(0xFFB2CDB9);
  static const Color onSecondaryDark = Color(0xFF082013);
  static const Color secondaryContainerDark = Color(0xFF344C3D);
  static const Color onSecondaryContainerDark = Color(0xFFCDE9D5);

  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color inverseSurfaceDark = Color(0xFFDDE4E6);
  static const Color inverseOnSurfaceDark = Color(0xFF2B3234);

  static const Color warningDark = Color(0xFFFFC247);
}
