import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngay_luong/core/calc/wage_calculator.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/core/widgets/hero_number_view.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_editor_screen.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/quick_check/domain/result_phrasing.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class ResultScreenArgs {
  const ResultScreenArgs({required this.price, this.itemName});

  final double price;
  final String? itemName;
}

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key, required this.price, this.itemName});

  final double price;
  final String? itemName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(incomeProfileNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(),
        title: null,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _ErrorBody(
          message: 'Không tải được thu nhập.',
          onRetry: () => ref.invalidate(incomeProfileNotifierProvider),
        ),
        data: (profile) {
          if (profile == null || !profile.isUsable) {
            return _NoIncomeBody(
              onSetup: () => context.push(Routes.onboarding),
            );
          }

          late final CheckResult result;
          try {
            result = WageCalculator(profile).check(price);
          } on CalcException catch (e) {
            if (e.error == CalcError.invalidPrice) {
              return _ErrorBody(
                message: 'Giá không hợp lệ.',
                onRetry: () => context.pop(),
              );
            }
            return _NoIncomeBody(
              onSetup: () => context.push(Routes.onboarding),
            );
          }

          return _ResultBody(
            price: price,
            result: result,
            itemName: itemName,
          );
        },
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody({
    required this.price,
    required this.result,
    this.itemName,
  });

  final double price;
  final CheckResult result;
  final String? itemName;

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  void _onSaveToWishlist(BuildContext context) {
    context.push(
      Routes.crushNew,
      extra: CrushEditorArgs(
        price: widget.price,
        daysOfWage: widget.result.daysOfWage,
        hoursOfWork: widget.result.hoursOfWork ?? 0,
        pctOfMonthlyIncome: widget.result.pctOfMonthlyIncome,
        initialStatus: CrushStatus.sleepOnIt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemName = widget.itemName?.trim();
    final subtitle = itemName != null && itemName.isNotEmpty
        ? l10n.resultHeroSubNamed(itemName)
        : l10n.resultHeroSubGeneric;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.base),
            const _HeroCircle(),
            const SizedBox(height: 28),
            Text(
              l10n.resultConversionLabel,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.result.daysOfWage),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, _) => HeroNumberView(
                numberText: _formatHeroNumber(value),
                unitText: l10n.resultHeroUnit,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            _BentoMetricsRow(result: widget.result),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: Text(l10n.resultSaveToWishlist),
                onPressed: () => _onSaveToWishlist(context),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.base,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.refresh_outlined, size: 18),
                label: Text(l10n.resultCheckAnother),
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.base,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  String _formatHeroNumber(double days) {
    if (days < 0.1) return '<0,1';
    if (days >= 100) {
      return days.round().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
          );
    }
    return days.toStringAsFixed(1).replaceAll('.', ',');
  }
}

class _HeroCircle extends StatelessWidget {
  const _HeroCircle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentSoft.withValues(alpha: 0.6),
            ),
          ),
          Container(
            width: 240,
            height: 240,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: AppColors.organicShadow,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentSoft,
                      AppColors.accentSoft.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoMetricsRow extends StatelessWidget {
  const _BentoMetricsRow({required this.result});

  final CheckResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _BentoCard(
            icon: Icons.schedule_outlined,
            label: l10n.resultHoursLabel,
            value: result.hoursOfWork != null
                ? AppFormatters.formatHours(result.hoursOfWork!)
                : '—',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _BentoCard(
            icon: Icons.fitness_center_outlined,
            label: l10n.resultEffortLabel,
            value: switch (ResultPhrasing.select(result)) {
              PhrasingVariant.tiny => l10n.resultEffortTiny,
              PhrasingVariant.normal => l10n.resultEffortNormal,
              PhrasingVariant.heavy => l10n.resultEffortHeavy,
            },
          ),
        ),
      ],
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.organicShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: AppColors.accent),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NoIncomeBody extends StatelessWidget {
  const _NoIncomeBody({required this.onSetup});
  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 48, color: AppColors.neutral),
            const SizedBox(height: AppSpacing.base),
            Text(
              l10n.homeNeedIncome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: onSetup,
              child: const Text('Nhập thu nhập'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: AppSpacing.base),
            OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}
