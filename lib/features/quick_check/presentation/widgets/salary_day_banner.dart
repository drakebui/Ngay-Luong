import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/features/settings/presentation/providers/settings_provider.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class SalaryDayBanner extends ConsumerWidget {
  const SalaryDayBanner({super.key, DateTime? now}) : _now = now;

  final DateTime? _now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = _now ?? DateTime.now();
    final monthKey = now.year * 100 + now.month;
    final state = ref.watch(settingsControllerProvider);
    final repo = ref.watch(settingsRepositoryProvider);
    final dismissed = repo.salaryDayBannerDismissedMonth == monthKey;

    if (now.day != state.paydayDay || dismissed) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sm,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceContainerHighDark
              : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            children: [
              const Text('💸', style: TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.paydayPromptTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await repo.setSalaryDayBannerDismissedMonth(monthKey);
                  ref.read(settingsControllerProvider.notifier).refresh();
                  if (context.mounted) context.push(Routes.crush);
                },
                child: Text(l10n.paydayBannerAction),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  await repo.setSalaryDayBannerDismissedMonth(monthKey);
                  ref.read(settingsControllerProvider.notifier).refresh();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
