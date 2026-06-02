import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/theme/app_typography.dart';

class MidnightMatchaVisualSmoke extends StatelessWidget {
  const MidnightMatchaVisualSmoke({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '4,4 ngày đi làm',
                  textAlign: TextAlign.center,
                  style: AppTypography.heroNumber.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'ờ ợ ữ ũ ắ ặ ề ệ',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.calculate,
                      fill: 1,
                      size: 40,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Icon(
                      Symbols.favorite,
                      fill: 0,
                      size: 40,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
    'renders Midnight Matcha typography and Material Symbols smoke',
    (tester) async {
      await tester.pumpWidget(const MidnightMatchaVisualSmoke());

      expect(find.text('4,4 ngày đi làm'), findsOneWidget);
      expect(find.text('ờ ợ ữ ũ ắ ặ ề ệ'), findsOneWidget);
      expect(find.byIcon(Symbols.calculate), findsOneWidget);
      expect(find.byIcon(Symbols.favorite), findsOneWidget);

      final heroText = tester.widget<Text>(find.text('4,4 ngày đi làm'));
      expect(heroText.style?.fontSize, 64);
      expect(heroText.style?.fontWeight, FontWeight.w800);
      expect(heroText.style?.fontFamily, contains('BeVietnamPro'));
    },
  );
}
