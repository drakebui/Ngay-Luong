import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'package:ngay_luong/features/save_card/domain/save_card_template.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key, required this.price});

  final double price;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(incomeProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Kết quả'),
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

          return _ResultBody(price: price, result: result);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────

class _ResultBody extends StatelessWidget {
  const _ResultBody({required this.price, required this.result});

  final double price;
  final CheckResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final variant = ResultPhrasing.select(result);

    final microcopy = _buildMicrocopy(l10n, variant, result, price);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero with count-up animation
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: result.daysOfWage),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => HeroNumberView(
                numberText: _formatHeroNumber(value),
                unitText: l10n.resultHeroUnit,
                subText: l10n.resultHeroSubGeneric,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Sub-metrics
          _SubMetricsRow(result: result),
          const SizedBox(height: AppSpacing.xl),
          // Microcopy
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceAltDark
                  : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Text(
              microcopy,
              style: const TextStyle(fontSize: 15, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Decision row
          _DecisionRow(result: result, price: price),
          const SizedBox(height: AppSpacing.base),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Tạo Save Card'),
              onPressed: () => context.push(
                Routes.saveCard,
                extra: SaveCardInput(days: result.daysOfWage),
              ),
            ),
          ),
        ],
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
    // 1 decimal, dùng dấu phẩy
    return days.toStringAsFixed(1).replaceAll('.', ',');
  }

  String _buildMicrocopy(
    AppLocalizations l10n,
    PhrasingVariant variant,
    CheckResult result,
    double price,
  ) {
    final daysDisplay =
        AppFormatters.formatDays(result.daysOfWage).replaceAll(' ngày', '');
    switch (variant) {
      case PhrasingVariant.tiny:
        return l10n.resultMsgTiny(daysDisplay);
      case PhrasingVariant.heavy:
        return l10n.resultMsgHeavy(
          AppFormatters.formatMoney(price),
          daysDisplay,
        );
      case PhrasingVariant.normal:
        return l10n.resultMsgNormal(daysDisplay);
    }
  }
}

// ─────────────────────────────────────────────

class _SubMetricsRow extends StatelessWidget {
  const _SubMetricsRow({required this.result});

  final CheckResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final secondary = Theme.of(context).textTheme.bodyMedium?.color;

    final chips = <String>[];

    if (result.hoursOfWork != null) {
      chips.add(
        l10n.resultSubHours(AppFormatters.formatHours(result.hoursOfWork!)),
      );
    }
    if (result.pctOfMonthlyIncome != null) {
      chips.add(
        l10n.resultSubPct(AppFormatters.formatPct(result.pctOfMonthlyIncome!)),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: chips
          .expand(
            (chip) => [
              _MetricChip(text: chip),
              if (chip != chips.last)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text('·', style: TextStyle(color: secondary)),
                ),
            ],
          )
          .toList(),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodyMedium?.color;
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
    );
  }
}

// ─────────────────────────────────────────────

class _DecisionRow extends StatefulWidget {
  const _DecisionRow({required this.result, required this.price});
  final CheckResult result;
  final double price;

  @override
  State<_DecisionRow> createState() => _DecisionRowState();
}

class _DecisionRowState extends State<_DecisionRow> {
  String? _feedbackText;

  void _onBuy() {
    setState(() => _feedbackText = null);
    context.pop();
  }

  void _onSkip() {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _feedbackText = l10n.decisionSkipped);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.decisionSkipped)),
    );
  }

  void _onSleepOnIt() {
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

  void _onSaveToCalendar() {
    context.push(
      Routes.crushNew,
      extra: CrushEditorArgs(
        price: widget.price,
        daysOfWage: widget.result.daysOfWage,
        hoursOfWork: widget.result.hoursOfWork ?? 0,
        pctOfMonthlyIncome: widget.result.pctOfMonthlyIncome,
        initialStatus: CrushStatus.crushing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_feedbackText != null) ...[
          Text(
            _feedbackText!,
            style: const TextStyle(fontSize: 14, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.base),
        ],
        Row(
          children: [
            Expanded(
              child: _DecisionButton(
                label: l10n.decisionBuy,
                icon: Icons.check_circle_outline,
                onTap: _onBuy,
                isPrimary: false,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DecisionButton(
                label: l10n.decisionSleepOnIt,
                icon: Icons.bedtime_outlined,
                onTap: _onSleepOnIt,
                isPrimary: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _DecisionButton(
                label: l10n.decisionSkip,
                icon: Icons.close_outlined,
                onTap: _onSkip,
                isPrimary: false,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DecisionButton(
                label: l10n.decisionSaveToCalendar,
                icon: Icons.calendar_today_outlined,
                onTap: _onSaveToCalendar,
                isPrimary: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final surfaceAlt = Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceAltDark
        : AppColors.surfaceAlt;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Material(
      color: surfaceAlt,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: secondaryColor),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────

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
