/// Spacing & shape tokens — Midnight Matcha / 8px base grid.
/// Source: docs/06_DESIGN_SYSTEM.md §3.
abstract final class AppSpacing {
  // ── Spacing scale ─────────────────────────────────────────────────────────

  static const double xs = 4;
  static const double base = 8;
  static const double sm = 12;
  static const double md = 24;
  static const double lg = 48;
  static const double xl = 80;

  static const double gutter = 24;
  static const double marginMobile = 16;
  static const double marginDesktop = 64;

  /// Convenience alias used throughout for screen horizontal padding.
  static const double screenPadding = marginMobile;

  // ── Explicit sizes (non-scale) ────────────────────────────────────────────

  static const double inputHeight = 64;
  static const double bottomNavHeight = 64;
  static const double bottomNavBottomInset = 24; // distance from bottom edge

  // ── Border radius ─────────────────────────────────────────────────────────

  static const double radiusSm = 8;
  static const double radiusDefault = 16;
  static const double radiusMd = 24;
  static const double radiusLg = 32;
  static const double radiusXl = 48;
  static const double radiusFull = 9999;

  /// Legacy aliases — kept so existing code compiles while being migrated.
  static const double cardRadius = radiusLg;
  static const double buttonRadius = radiusFull;
}
