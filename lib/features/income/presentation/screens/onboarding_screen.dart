import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ngay_luong/core/calc/wage_calculator.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/theme/app_typography.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  IncomeMode _mode = IncomeMode.monthly;

  final _incomeCtrl = TextEditingController();
  final _workDaysCtrl = TextEditingController(text: '22');
  final _workHoursCtrl = TextEditingController(text: '8');
  final _projectIncomeCtrl = TextEditingController();
  final _projectUnitCtrl = TextEditingController();

  bool _projectByHours = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _incomeCtrl.dispose();
    _workDaysCtrl.dispose();
    _workHoursCtrl.dispose();
    _projectIncomeCtrl.dispose();
    _projectUnitCtrl.dispose();
    super.dispose();
  }

  IncomeProfile? _buildProfile() {
    double? parseUnit(String text) {
      final normalized = text.trim().replaceAll(' ', '').replaceAll(',', '.');
      final value = double.tryParse(normalized);
      return value != null && value.isFinite && value > 0 ? value : null;
    }

    int parseIntOrDefault(String text, int fallback) {
      final parsed = int.tryParse(text.trim());
      return parsed != null && parsed > 0 ? parsed : fallback;
    }

    final now = DateTime.now();
    switch (_mode) {
      case IncomeMode.monthly:
        final income = AppFormatters.parsePrice(_incomeCtrl.text);
        if (income == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          monthlyNetIncome: income,
          workDaysPerMonth: parseIntOrDefault(_workDaysCtrl.text, 22),
          workHoursPerDay: parseUnit(_workHoursCtrl.text) ?? 8,
          updatedAt: now,
        );
      case IncomeMode.daily:
        final income = AppFormatters.parsePrice(_incomeCtrl.text);
        if (income == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          dailyIncome: income,
          workHoursPerDay: parseUnit(_workHoursCtrl.text) ?? 8,
          updatedAt: now,
        );
      case IncomeMode.hourly:
        final income = AppFormatters.parsePrice(_incomeCtrl.text);
        if (income == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          hourlyIncome: income,
          updatedAt: now,
        );
      case IncomeMode.project:
        final income = AppFormatters.parsePrice(_projectIncomeCtrl.text);
        final unit = parseUnit(_projectUnitCtrl.text);
        if (income == null || unit == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          projectIncome: income,
          projectTotalHours: _projectByHours ? unit : null,
          projectTotalDays: _projectByHours ? null : unit,
          updatedAt: now,
        );
    }
  }

  bool get _isUsable {
    final profile = _buildProfile();
    return profile != null && profile.isUsable;
  }

  String _hourlyPreview() {
    final profile = _buildProfile();
    if (profile == null || !profile.isUsable) {
      return '—';
    }

    try {
      final hourlyWage = WageCalculator(profile).basis.hourlyWage;
      return hourlyWage == null ? '—' : AppFormatters.formatMoney(hourlyWage);
    } on CalcException {
      return '—';
    }
  }

  Future<void> _save(AppLocalizations l) async {
    final profile = _buildProfile();
    if (profile == null || !profile.isUsable) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(incomeProfileNotifierProvider.notifier).save(profile);
      if (mounted) {
        context.go(Routes.home);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.onboardingSaveError)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _selectMode(IncomeMode mode) {
    setState(() {
      _mode = mode;
      _step = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.onboardingTitle),
        leading: _step == 1
            ? BackButton(onPressed: () => setState(() => _step = 0))
            : null,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : () => context.go(Routes.home),
            child: Text(l.onboardingSkip),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _step == 0 ? _buildModeStep(l) : _buildFormStep(l),
      ),
    );
  }

  Widget _buildModeStep(AppLocalizations l) {
    return KeyedSubtree(
      key: const ValueKey('mode-step'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xl,
          AppSpacing.screenPadding,
          AppSpacing.xxxl,
        ),
        children: [
          _ModeCard(
            icon: Symbols.calendar_month,
            label: l.onboardingModeMonthly,
            description: l.onboardingModeMonthlyDesc,
            onTap: () => _selectMode(IncomeMode.monthly),
          ),
          const SizedBox(height: AppSpacing.md),
          _ModeCard(
            icon: Symbols.today,
            label: l.onboardingModeDaily,
            description: l.onboardingModeDailyDesc,
            onTap: () => _selectMode(IncomeMode.daily),
          ),
          const SizedBox(height: AppSpacing.md),
          _ModeCard(
            icon: Symbols.schedule,
            label: l.onboardingModeHourly,
            description: l.onboardingModeHourlyDesc,
            onTap: () => _selectMode(IncomeMode.hourly),
          ),
          const SizedBox(height: AppSpacing.md),
          _ModeCard(
            icon: Symbols.work,
            label: l.onboardingModeProject,
            description: l.onboardingModeProjectDesc,
            onTap: () => _selectMode(IncomeMode.project),
          ),
        ],
      ),
    );
  }

  Widget _buildFormStep(AppLocalizations l) {
    return KeyedSubtree(
      key: const ValueKey('form-step'),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.xl,
                AppSpacing.screenPadding,
                AppSpacing.xl,
              ),
              children: [
                ..._buildFields(l),
                const SizedBox(height: AppSpacing.lg),
                _LivePreviewCard(
                  label: l.onboardingLivePreviewLabel,
                  value: _hourlyPreview(),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PrivacyBanner(text: l.privacyOnboarding),
              ],
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isUsable && !_isSaving ? () => _save(l) : null,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.onboardingDone),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFields(AppLocalizations l) {
    switch (_mode) {
      case IncomeMode.monthly:
        return [
          _numField(
            label: l.onboardingMonthlyIncome,
            controller: _incomeCtrl,
            suffixText: l.onboardingCurrencySuffix,
          ),
          const SizedBox(height: AppSpacing.md),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l.onboardingCustomize),
            childrenPadding: const EdgeInsets.only(top: AppSpacing.md),
            children: [
              _numField(
                label: l.onboardingWorkDays,
                controller: _workDaysCtrl,
                suffixText: l.onboardingDaySuffix,
                isInt: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _numField(
                label: l.onboardingWorkHours,
                controller: _workHoursCtrl,
                suffixText: l.onboardingHourSuffix,
              ),
            ],
          ),
        ];
      case IncomeMode.daily:
        return [
          _numField(
            label: l.onboardingDailyIncome,
            controller: _incomeCtrl,
            suffixText: l.onboardingCurrencySuffix,
          ),
          const SizedBox(height: AppSpacing.md),
          _numField(
            label: l.onboardingWorkHours,
            controller: _workHoursCtrl,
            suffixText: l.onboardingHourSuffix,
          ),
        ];
      case IncomeMode.hourly:
        return [
          _numField(
            label: l.onboardingHourlyIncome,
            controller: _incomeCtrl,
            suffixText: l.onboardingCurrencySuffix,
          ),
        ];
      case IncomeMode.project:
        return [
          _numField(
            label: l.onboardingProjectIncome,
            controller: _projectIncomeCtrl,
            suffixText: l.onboardingCurrencySuffix,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: Text(l.onboardingProjectHours),
                selected: _projectByHours,
                onSelected: (_) => setState(() {
                  _projectByHours = true;
                  _projectUnitCtrl.clear();
                }),
              ),
              ChoiceChip(
                label: Text(l.onboardingProjectDays),
                selected: !_projectByHours,
                onSelected: (_) => setState(() {
                  _projectByHours = false;
                  _projectUnitCtrl.clear();
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _numField(
            label: _projectByHours
                ? l.onboardingProjectHours
                : l.onboardingProjectDays,
            controller: _projectUnitCtrl,
            suffixText: _projectByHours
                ? l.onboardingHourSuffix
                : l.onboardingDaySuffix,
          ),
        ];
    }
  }

  Widget _numField({
    required String label,
    required TextEditingController controller,
    required String suffixText,
    bool isInt = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isInt
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          isInt ? RegExp('[0-9]') : RegExp('[0-9., ]'),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixText,
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.organicShadow,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Icon(icon, size: 26, color: colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(description, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Symbols.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LivePreviewCard extends StatelessWidget {
  const _LivePreviewCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.organicShadowPrimaryTint,
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.title.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Symbols.lock, size: 20, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
