import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/settings/presentation/providers/settings_provider.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: Text(l10n.settingsEditIncome),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.onboarding),
          ),
          ListTile(
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.settingsPayday),
            trailing: Text(
              '${state.paydayDay}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onTap: () => _showPaydayPicker(context, state.paydayDay, controller),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: Text(l10n.settingsAppLock),
            value: state.appLockEnabled,
            onChanged: (value) => _onToggleAppLock(context, ref, value),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l10n.settingsNotiDetail),
            value: state.notiDetailMode,
            onChanged: controller.setNotiDetailMode,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.savings_outlined),
            title: Text(l10n.settingsMascotTitle),
            value: state.mascotEnabled,
            onChanged: controller.setMascotEnabled,
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text(l10n.settingsTheme),
            trailing: Text(
              _themeLabel(state.themeMode),
              style: const TextStyle(fontSize: 15),
            ),
            onTap: () => _showThemePicker(context, state.themeMode, controller),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: Text(
              l10n.settingsDeleteAll,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _onDeleteAll(context, ref),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Sáng';
      case ThemeMode.dark:
        return 'Tối';
      case ThemeMode.system:
        return 'Theo hệ thống';
    }
  }

  Future<void> _showThemePicker(
    BuildContext context,
    ThemeMode current,
    SettingsController controller,
  ) async {
    final picked = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: RadioGroup<ThemeMode>(
            groupValue: current,
            onChanged: (value) => Navigator.of(ctx).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThemeMode.values
                  .map(
                    (mode) => RadioListTile<ThemeMode>(
                      title: Text(_themeLabel(mode)),
                      value: mode,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
    if (picked != null) {
      await controller.setThemeMode(picked);
    }
  }

  Future<void> _showPaydayPicker(
    BuildContext context,
    int current,
    SettingsController controller,
  ) async {
    int selected = current;
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setState) => SizedBox(
              height: 240,
              child: RadioGroup<int>(
                groupValue: selected,
                onChanged: (v) {
                  if (v != null) setState(() => selected = v);
                },
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.base),
                      child: Text(
                        'Ngày lương trong tháng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 31,
                        itemBuilder: (ctx, i) {
                          final day = i + 1;
                          return RadioListTile<int>(
                            title: Text('Ngày $day'),
                            value: day,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.base),
                      child: FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(selected),
                        child: const Text('Xong'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (picked != null) {
      await controller.setPaydayDay(picked);
    }
  }

  Future<void> _onToggleAppLock(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    final appLock = ref.read(appLockServiceProvider);

    if (!value) {
      await controller.setAppLockEnabled(false);
      return;
    }

    final available = await appLock.isAvailable();
    if (!available) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thiết bị chưa thiết lập Face ID / vân tay.'),
        ),
      );
      return;
    }

    final ok = await appLock.authenticate(
      reason: 'Bật khóa app để bảo vệ Ngày Lương.',
    );
    if (!ok) return;
    await controller.setAppLockEnabled(true);
  }

  Future<void> _onDeleteAll(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    final firstOk = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsDeleteAll),
        content: Text(l10n.privacyDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
    if (firstOk != true || !context.mounted) return;

    final secondOk = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bạn chắc chứ?'),
        content: const Text(
          'Sau bước này, mình không khôi phục lại được dữ liệu cho bạn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa hết'),
          ),
        ],
      ),
    );
    if (secondOk != true || !context.mounted) return;

    await ref.read(dataResetServiceProvider).wipeEverything();
    ref.invalidate(incomeProfileNotifierProvider);
    ref.read(settingsControllerProvider.notifier).refresh();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa toàn bộ dữ liệu.')),
    );
    context.go(Routes.onboarding);
  }
}
