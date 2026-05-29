import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/features/settings/presentation/providers/settings_provider.dart';

/// If app lock is enabled in settings, blocks the UI until the user
/// authenticates with biometrics. Once unlocked for this session, lets
/// the [child] render.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  bool _unlocked = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_maybeUnlock());
    });
  }

  Future<void> _maybeUnlock() async {
    final settings = ref.read(settingsControllerProvider);
    if (!settings.appLockEnabled) {
      setState(() => _unlocked = true);
      return;
    }
    await _authenticate();
  }

  Future<void> _authenticate() async {
    if (_checking) return;
    setState(() => _checking = true);
    final ok = await ref.read(appLockServiceProvider).authenticate();
    if (!mounted) return;
    setState(() {
      _checking = false;
      _unlocked = ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) return widget.child;

    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64),
                const SizedBox(height: AppSpacing.base),
                const Text(
                  'Ngày Lương đang khóa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Xác thực để mở app.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: _checking ? null : _authenticate,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Mở khóa'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
