import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
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
    double? parse(String text) {
      final value = double.tryParse(
        text.replaceAll('.', '').replaceAll(',', '.').trim(),
      );
      return value != null && value > 0 ? value : null;
    }

    int parseIntOrDefault(String text, int fallback) {
      return int.tryParse(text.trim()) ?? fallback;
    }

    final now = DateTime.now();
    switch (_mode) {
      case IncomeMode.monthly:
        final income = parse(_incomeCtrl.text);
        if (income == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          monthlyNetIncome: income,
          workDaysPerMonth: parseIntOrDefault(_workDaysCtrl.text, 22),
          workHoursPerDay: parse(_workHoursCtrl.text) ?? 8,
          updatedAt: now,
        );
      case IncomeMode.daily:
        final income = parse(_incomeCtrl.text);
        if (income == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          dailyIncome: income,
          workHoursPerDay: parse(_workHoursCtrl.text) ?? 8,
          updatedAt: now,
        );
      case IncomeMode.hourly:
        final income = parse(_incomeCtrl.text);
        if (income == null) {
          return null;
        }
        return IncomeProfile(
          mode: _mode,
          hourlyIncome: income,
          updatedAt: now,
        );
      case IncomeMode.project:
        final income = parse(_projectIncomeCtrl.text);
        final unit = parse(_projectUnitCtrl.text);
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

  Future<void> _save() async {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lưu thất bại: $e')),
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
        padding: const EdgeInsets.all(24),
        children: [
          _ModeCard(
            icon: Icons.calendar_month_outlined,
            label: l.onboardingModeMonthly,
            onTap: () => _selectMode(IncomeMode.monthly),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.today_outlined,
            label: l.onboardingModeDaily,
            onTap: () => _selectMode(IncomeMode.daily),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.schedule_outlined,
            label: l.onboardingModeHourly,
            onTap: () => _selectMode(IncomeMode.hourly),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.work_outline,
            label: l.onboardingModeProject,
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
              padding: const EdgeInsets.all(24),
              children: [
                ..._buildFields(l),
                const SizedBox(height: 24),
                _PrivacyBanner(text: l.privacyOnboarding),
              ],
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isUsable && !_isSaving ? _save : null,
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
          const SizedBox(height: 16),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l.onboardingCustomize),
            childrenPadding: const EdgeInsets.only(top: 12),
            children: [
              _numField(
                label: l.onboardingWorkDays,
                controller: _workDaysCtrl,
                suffixText: l.onboardingDaySuffix,
                isInt: true,
              ),
              const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
          const SizedBox(height: 16),
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
          isInt ? RegExp('[0-9]') : RegExp('[0-9.,]'),
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_outline,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
