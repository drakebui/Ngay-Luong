import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';

/// Hero view hiển thị số ngày lương lớn — tâm điểm màn Result.
class HeroNumberView extends StatelessWidget {
  const HeroNumberView({
    super.key,
    required this.numberText,
    required this.unitText,
    this.subText,
  });

  final String numberText;
  final String unitText;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final secondary = Theme.of(context).textTheme.bodyMedium?.color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          numberText,
          style: GoogleFonts.beVietnamPro(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            color: accent,
            height: 1.0,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          unitText,
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: onSurface,
            height: 1.3,
          ),
        ),
        if (subText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subText!,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: secondary ?? AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
