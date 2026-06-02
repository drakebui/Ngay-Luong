import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/core/widgets/hero_number_view.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/crush/domain/crush_mood.dart';
import 'package:ngay_luong/features/crush/domain/remind_at_calculator.dart';
import 'package:ngay_luong/features/crush/presentation/controllers/still_crushing_actions.dart';
import 'package:ngay_luong/features/crush/presentation/providers/crush_providers.dart';
import 'package:ngay_luong/features/crush/presentation/widgets/mascot_overlay.dart';
import 'package:ngay_luong/features/settings/presentation/providers/settings_provider.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class StillCrushingScreen extends ConsumerWidget {
  const StillCrushingScreen({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardAsync = ref.watch(crushCardProvider(cardId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stillScreenQuestion)),
      body: cardAsync.when(
        data: (card) {
          if (card == null) {
            return Center(child: Text(l10n.crushEditorLoadError));
          }
          return _StillCrushingBody(card: card);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.crushEditorLoadError)),
      ),
    );
  }
}

class _StillCrushingBody extends ConsumerStatefulWidget {
  const _StillCrushingBody({required this.card});

  final CrushCard card;

  @override
  ConsumerState<_StillCrushingBody> createState() => _StillCrushingBodyState();
}

class _StillCrushingBodyState extends ConsumerState<_StillCrushingBody> {
  bool _isSaving = false;

  Future<void> _runAction(
    Future<void> Function(StillCrushingActions) run, {
    String? successMessage,
    bool? mascotSurvived,
  }) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;
    final actions = StillCrushingActions(
      repository: ref.read(crushRepositoryProvider),
    );

    try {
      await run(actions);
      ref.invalidate(crushCardProvider(widget.card.id));
      ref.invalidate(crushCardsProvider);
      ref.invalidate(crushPendingProvider);
      ref.invalidate(crushSavedDaysProvider);
      if (mounted) {
        if (successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
        }
        if (mascotSurvived != null &&
            ref.read(settingsControllerProvider).mascotEnabled) {
          showMascotOverlay(
            context,
            days: widget.card.daysOfWageSnapshot,
            isSurvived: mascotSurvived,
          );
        }
        context.go(Routes.calendar);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.crushEditorSaveError)),
      );
      setState(() => _isSaving = false);
    }
  }

  Future<void> _remindAgain() async {
    final selection = await _pickReminderPreset();
    if (selection == null) return;

    await _runAction(
      (actions) => actions.remindAgain(
        widget.card,
        preset: selection.preset,
        paydayDay:
            ref.read(sharedPreferencesProvider).getInt('payday_day') ?? 5,
        customDateTime: selection.customDateTime,
      ),
    );
  }

  Future<_ReminderSelection?> _pickReminderPreset() async {
    final l10n = AppLocalizations.of(context)!;
    final preset = await showModalBottomSheet<ReminderPreset>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.base,
              AppSpacing.screenPadding,
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.stillScreenBtnRemindAgain,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.base),
                for (final preset in ReminderPreset.values)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_reminderLabel(l10n, preset)),
                    onTap: () => Navigator.of(context).pop(preset),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (preset == null || !mounted) return null;

    if (preset != ReminderPreset.custom) {
      return _ReminderSelection(preset: preset);
    }

    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );
    if (time == null) return null;

    return _ReminderSelection(
      preset: preset,
      customDateTime: DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final card = widget.card;
    final name = card.name?.trim();
    final daysSinceCreated = _daysSince(card.createdAt);
    final mood = crushMoodFromName(card.mood);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (card.imagePath != null) ...[
            _ItemImage(imagePath: card.imagePath!),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (name != null && name.isNotEmpty) ...[
            Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          HeroNumberView(
            numberText: AppFormatters.formatDays(card.daysOfWageSnapshot)
                .replaceAll(' ngày', ''),
            unitText: l10n.stillScreenHeroUnit,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.stillScreenBoughtDaysAgo(daysSinceCreated),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (card.reason != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.stillScreenReasonLabel(card.reason!.label),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (mood != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${mood.icon} ${mood.label}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          Text(
            l10n.stillScreenQuestion,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          _DecisionGrid(
            isSaving: _isSaving,
            onStillCrushing: () => _runAction(
              (actions) => actions.stillCrushing(card),
            ),
            onOverIt: () => _runAction(
              (actions) => actions.overIt(card),
              successMessage: l10n.stillScreenSavedDays(
                AppFormatters.formatDays(
                  card.daysOfWageSnapshot,
                ).replaceAll(' ngày', ''),
              ),
              mascotSurvived: true,
            ),
            onWaitingForSale: () => _runAction(
              (actions) => actions.waitingForSale(card),
            ),
            onBought: () => _runAction(
              (actions) => actions.bought(card),
              mascotSurvived: false,
            ),
            onRemindAgain: _remindAgain,
            onDelete: () => _runAction((actions) => actions.delete(card)),
          ),
        ],
      ),
    );
  }

  int _daysSince(DateTime createdAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final difference = today.difference(createdDay).inDays;
    return difference < 0 ? 0 : difference;
  }
}

class _DecisionGrid extends StatelessWidget {
  const _DecisionGrid({
    required this.isSaving,
    required this.onStillCrushing,
    required this.onOverIt,
    required this.onWaitingForSale,
    required this.onBought,
    required this.onRemindAgain,
    required this.onDelete,
  });

  final bool isSaving;
  final VoidCallback onStillCrushing;
  final VoidCallback onOverIt;
  final VoidCallback onWaitingForSale;
  final VoidCallback onBought;
  final VoidCallback onRemindAgain;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.7,
      children: [
        _DecisionButton(
          label: l10n.stillScreenBtnStillCrushing,
          icon: Icons.favorite_border,
          onPressed: isSaving ? null : onStillCrushing,
        ),
        _DecisionButton(
          label: l10n.stillScreenBtnOverIt,
          icon: Icons.done_outline,
          onPressed: isSaving ? null : onOverIt,
        ),
        _DecisionButton(
          label: l10n.stillScreenBtnWaitingSale,
          icon: Icons.local_offer_outlined,
          onPressed: isSaving ? null : onWaitingForSale,
        ),
        _DecisionButton(
          label: l10n.stillScreenBtnBought,
          icon: Icons.shopping_bag_outlined,
          onPressed: isSaving ? null : onBought,
        ),
        _DecisionButton(
          label: l10n.stillScreenBtnRemindAgain,
          icon: Icons.notifications_active_outlined,
          onPressed: isSaving ? null : onRemindAgain,
        ),
        _DecisionButton(
          label: l10n.stillScreenBtnDelete,
          icon: Icons.delete_outline,
          onPressed: isSaving ? null : onDelete,
        ),
      ],
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final surfaceAlt = Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceAltDark
        : AppColors.surfaceAlt;

    return AspectRatio(
      aspectRatio: 1.4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.broken_image_outlined, size: 44),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderSelection {
  const _ReminderSelection({
    required this.preset,
    this.customDateTime,
  });

  final ReminderPreset preset;
  final DateTime? customDateTime;
}

String _reminderLabel(AppLocalizations l10n, ReminderPreset preset) {
  switch (preset) {
    case ReminderPreset.tonight:
      return l10n.remindTonight;
    case ReminderPreset.after24h:
      return l10n.remindAfter24h;
    case ReminderPreset.after3Days:
      return l10n.remindAfter3Days;
    case ReminderPreset.after7Days:
      return l10n.remindAfter7Days;
    case ReminderPreset.untilPayday:
      return l10n.remindUntilPayday;
    case ReminderPreset.custom:
      return l10n.remindCustom;
  }
}
