import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? AppColors.bgDark : AppColors.bg;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final primaryContainer = isDark
        ? AppColors.primaryContainerDark
        : AppColors.primaryContainer;
    final onPrimary = isDark ? AppColors.onPrimaryDark : AppColors.onPrimary;
    final onPrimaryContainer = isDark
        ? AppColors.onPrimaryContainerDark
        : AppColors.onPrimaryContainer;
    final secondaryContainer = isDark
        ? AppColors.secondaryContainerDark
        : AppColors.secondaryContainer;
    final onSecondaryContainer = isDark
        ? AppColors.onSecondaryContainerDark
        : AppColors.onSecondaryContainer;
    final neutral = isDark ? AppColors.outlineVariantDark : AppColors.neutral;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: primary,
      onSecondary: onPrimary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      surface: surface,
      onSurface: textPrimary,
      error: isDark ? AppColors.warningDark : AppColors.warning,
      onError: textPrimary,
    );

    final baseTextTheme = TextTheme(
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(color: textSecondary, fontSize: 12, height: 1.4),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      labelMedium: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
    final gfTextTheme = GoogleFonts.beVietnamProTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: neutral,
      textTheme: gfTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimaryContainer,
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          minimumSize: const Size.fromHeight(52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: neutral),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          minimumSize: const Size(0, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.base,
        ),
        hintStyle: TextStyle(color: textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
