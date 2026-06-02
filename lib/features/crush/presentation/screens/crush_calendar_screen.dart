import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/features/crush/domain/crush_calendar.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/crush/presentation/providers/crush_providers.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class CrushCalendarScreen extends ConsumerWidget {
  const CrushCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final calendarAsync = ref.watch(crushCalendarProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.calendarTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.calendarToday),
              Tab(text: l10n.calendarUpcoming),
              Tab(text: l10n.calendarMonth),
            ],
          ),
        ),
        body: Column(
          children: [
            const _CalendarFilters(),
            Expanded(
              child: calendarAsync.when(
                data: (view) => TabBarView(
                  children: [
                    _TodayTab(cards: view.todayCards),
                    _UpcomingTab(groups: view.upcomingGroups),
                    _MonthTab(reminderDays: view.monthReminderDays),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    Center(child: Text(l10n.crushEditorLoadError)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarFilters extends ConsumerWidget {
  const _CalendarFilters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedFilter = ref.watch(crushCalendarFilterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.sm,
      ),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in CrushCalendarStatusFilter.values) ...[
            ChoiceChip(
              label: Text(_filterLabel(l10n, filter)),
              selected: selectedFilter == filter,
              onSelected: (_) {
                ref
                    .read(crushCalendarFilterProvider.notifier)
                    .setFilter(filter);
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  String _filterLabel(
    AppLocalizations l10n,
    CrushCalendarStatusFilter filter,
  ) {
    switch (filter) {
      case CrushCalendarStatusFilter.pending:
        return l10n.calendarFilterPending;
      case CrushCalendarStatusFilter.overIt:
        return l10n.calendarFilterOverIt;
      case CrushCalendarStatusFilter.bought:
        return l10n.calendarFilterBought;
      case CrushCalendarStatusFilter.all:
        return l10n.calendarFilterAll;
    }
  }
}

class _TodayTab extends StatelessWidget {
  const _TodayTab({required this.cards});

  final List<CrushCard> cards;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (cards.isEmpty) {
      return _EmptyState(
        message: l10n.calendarEmptyToday,
        icon: Icons.check_circle_outline,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      itemCount: cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => _CrushCalendarTile(card: cards[index]),
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab({required this.groups});

  final List<CrushCalendarDayGroup> groups;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (groups.isEmpty) {
      return _EmptyState(
        message: l10n.calendarEmptyUpcoming,
        icon: Icons.calendar_today_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == groups.length - 1 ? 0 : AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _groupLabel(l10n, group.day),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final card in group.cards) ...[
                _CrushCalendarTile(card: card),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        );
      },
    );
  }

  String _groupLabel(AppLocalizations l10n, DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final difference = normalizedDay.difference(today).inDays;

    if (difference == 0) return l10n.calendarToday;
    if (difference == 1) return l10n.calendarTomorrow;
    if (difference > 1 && difference <= 7) {
      return l10n.calendarInDays(difference);
    }
    return AppFormatters.formatCalendarGroupDate(day);
  }
}

class _MonthTab extends ConsumerWidget {
  const _MonthTab({required this.reminderDays});

  final List<DateTime> reminderDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visibleMonth = ref.watch(crushCalendarMonthProvider);
    final daysWithReminder = {
      for (final day in reminderDays) DateTime(day.year, day.month, day.day),
    };
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final leadingBlankDays = firstDay.weekday - DateTime.monday;
    final totalCells = leadingBlankDays + daysInMonth;
    final rowCount = (totalCells / DateTime.daysPerWeek).ceil();
    final cellCount = rowCount * DateTime.daysPerWeek;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(crushCalendarMonthProvider.notifier).previousMonth();
                },
                icon: const Icon(Icons.chevron_left),
                tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
              ),
              Expanded(
                child: Text(
                  AppFormatters.formatCalendarMonth(visibleMonth),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(crushCalendarMonthProvider.notifier).nextMonth();
                },
                icon: const Icon(Icons.chevron_right),
                tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: DateTime.daysPerWeek,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DateTime.daysPerWeek,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final weekday = DateTime(2026, 6, 1 + index);
              return Center(
                child: Text(
                  AppFormatters.formatCalendarWeekday(weekday),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cellCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DateTime.daysPerWeek,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leadingBlankDays + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }
              final day = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                dayNumber,
              );
              return _MonthDayCell(
                dayNumber: dayNumber,
                hasReminder: daysWithReminder.contains(day),
              );
            },
          ),
          if (reminderDays.isEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.calendarEmptyMonth,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.dayNumber,
    required this.hasReminder,
  });

  final int dayNumber;
  final bool hasReminder;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Center(
      child: SizedBox.square(
        dimension: 42,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$dayNumber', style: textStyle),
            const SizedBox(height: AppSpacing.xs),
            SizedBox.square(
              dimension: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasReminder ? accent : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrushCalendarTile extends StatelessWidget {
  const _CrushCalendarTile({required this.card});

  final CrushCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surface = Theme.of(context).colorScheme.surface;
    final displayName = card.name?.trim().isNotEmpty == true
        ? card.name!.trim()
        : l10n.calendarUnnamedItem;
    final remindAt = card.remindAt;
    final subtitle = remindAt == null
        ? card.status.label
        : '${AppFormatters.formatClockTime(remindAt)} · ${card.status.label}';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? AppColors.surfaceLowDark
        : AppColors.outlineVariant.withOpacity(0.4);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          onTap: () => context.push('/crush/${card.id}'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
            children: [
              _TileImage(imagePath: card.imagePath),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.calendarItemQuestion(displayName),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _InfoChip(
                          label: AppFormatters.formatDays(
                            card.daysOfWageSnapshot,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        _InfoChip(
                          label: card.status.label,
                          color: _statusColor(context, card.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Color _statusColor(BuildContext context, CrushStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (status.countsAsSaved) {
      return isDark ? AppColors.secondaryDark : AppColors.secondary;
    }
    if (status == CrushStatus.waitingForSale) {
      return AppColors.warning;
    }
    return Theme.of(context).colorScheme.primary;
  }
}

class _TileImage extends StatelessWidget {
  const _TileImage({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final surfaceAlt = Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceLowDark
        : AppColors.surfaceLow;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: SizedBox.square(
        dimension: 64,
        child: DecoratedBox(
          decoration: BoxDecoration(color: surfaceAlt),
          child: imagePath == null
              ? const Icon(Icons.image_outlined)
              : Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image_outlined,
                  ),
                ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, this.icon = Icons.inbox_outlined});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppColors.outlineVariant),
            const SizedBox(height: AppSpacing.base),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
