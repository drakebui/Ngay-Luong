import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/core/calc/wage_calculator.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class WorthCheckSection extends ConsumerStatefulWidget {
  const WorthCheckSection({super.key, required this.price});

  final double price;

  @override
  ConsumerState<WorthCheckSection> createState() => _WorthCheckSectionState();
}

class _WorthCheckSectionState extends ConsumerState<WorthCheckSection> {
  bool _expanded = false;
  final _usesCtrl = TextEditingController();
  final _acceptableCtrl = TextEditingController();

  double? _costPerUse;
  double? _usesToWorth;

  @override
  void dispose() {
    _usesCtrl.dispose();
    _acceptableCtrl.dispose();
    super.dispose();
  }

  void _onUsesChanged(String raw, WageCalculator wc) {
    final uses = int.tryParse(raw.trim());
    if (uses != null && uses >= 1) {
      try {
        final result = wc.check(widget.price, expectedUses: uses.toDouble());
        setState(() => _costPerUse = result.costPerUse);
      } on CalcException {
        setState(() => _costPerUse = null);
      }
    } else {
      setState(() => _costPerUse = null);
    }
    _recalcUsesToWorth(wc);
  }

  void _onAcceptableChanged(String _, WageCalculator wc) {
    _recalcUsesToWorth(wc);
  }

  void _recalcUsesToWorth(WageCalculator wc) {
    final acceptable = AppFormatters.parsePrice(_acceptableCtrl.text);
    final uses = int.tryParse(_usesCtrl.text.trim());
    if (acceptable != null && uses != null && uses >= 1) {
      try {
        setState(() => _usesToWorth = wc.usesToWorthIt(widget.price, acceptable));
      } on CalcException {
        setState(() => _usesToWorth = null);
      }
    } else {
      setState(() => _usesToWorth = null);
    }
  }

  _Sentiment? _sentiment(double costPerUse, WageCalculator wc) {
    final basis = wc.basis;
    final hourly = basis.hourlyWage;
    if (hourly == null || hourly <= 0) return null;
    if (costPerUse <= hourly) return _Sentiment.good;
    if (costPerUse > basis.dailyWage) return _Sentiment.poor;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(incomeProfileNotifierProvider);

    return profileAsync.maybeWhen(
      data: (profile) {
        if (profile == null || !profile.isUsable) return const SizedBox.shrink();
        WageCalculator wc;
        try {
          wc = WageCalculator(profile);
        } on CalcException {
          return const SizedBox.shrink();
        }
        return _buildContent(context, l10n, wc);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    WageCalculator wc,
  ) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.sm,
                ),
                shape: const StadiumBorder(),
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expanded ? l10n.worthCollapseButton : l10n.worthTriggerButton,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more, size: 18),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.sm),
            _WorthCard(
              l10n: l10n,
              usesCtrl: _usesCtrl,
              acceptableCtrl: _acceptableCtrl,
              costPerUse: _costPerUse,
              usesToWorth: _usesToWorth,
              sentiment: _costPerUse != null ? _sentiment(_costPerUse!, wc) : null,
              onUsesChanged: (v) => _onUsesChanged(v, wc),
              onAcceptableChanged: (v) => _onAcceptableChanged(v, wc),
            ),
          ],
        ],
      ),
    );
  }
}

enum _Sentiment { good, poor }

class _WorthCard extends StatelessWidget {
  const _WorthCard({
    required this.l10n,
    required this.usesCtrl,
    required this.acceptableCtrl,
    required this.costPerUse,
    required this.usesToWorth,
    required this.sentiment,
    required this.onUsesChanged,
    required this.onAcceptableChanged,
  });

  final AppLocalizations l10n;
  final TextEditingController usesCtrl;
  final TextEditingController acceptableCtrl;
  final double? costPerUse;
  final double? usesToWorth;
  final _Sentiment? sentiment;
  final ValueChanged<String> onUsesChanged;
  final ValueChanged<String> onAcceptableChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final secondary = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: usesCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onUsesChanged,
            decoration: InputDecoration(
              hintText: l10n.worthExpectedUsesHint,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
          ),
          if (costPerUse != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.worthCostPerUse(AppFormatters.formatCostPerUse(costPerUse!)),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (sentiment != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                sentiment == _Sentiment.good
                    ? l10n.worthGoodValue
                    : l10n.worthPoorValue,
                style: TextStyle(fontSize: 13, color: secondary, height: 1.4),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.base),
          TextField(
            controller: acceptableCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onAcceptableChanged,
            decoration: InputDecoration(
              hintText: l10n.worthAcceptablePriceHint,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
          ),
          if (usesToWorth != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.worthUsesToWorth(
                usesToWorth!.ceil(),
                AppFormatters.formatMoney(
                  AppFormatters.parsePrice(acceptableCtrl.text) ?? 0,
                ),
              ),
              style: TextStyle(fontSize: 14, color: secondary, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
