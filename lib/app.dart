import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngay_luong/core/router/app_router.dart';
import 'package:ngay_luong/core/theme/app_theme.dart';
import 'package:ngay_luong/features/crush/presentation/providers/crush_providers.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class NgayLuongApp extends ConsumerStatefulWidget {
  const NgayLuongApp({super.key, required this.initialLocation});

  final String initialLocation;

  @override
  ConsumerState<NgayLuongApp> createState() => _NgayLuongAppState();
}

class _NgayLuongAppState extends ConsumerState<NgayLuongApp> {
  late final _router = makeAppRouter(widget.initialLocation);

  @override
  void initState() {
    super.initState();
    unawaited(_initializeNotifications());
  }

  Future<void> _initializeNotifications() async {
    await ref.read(notificationServiceProvider).initialize(
          onCardTap: _openCardFromNotification,
        );
  }

  void _openCardFromNotification(String cardId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _router.go('/crush/$cardId/still');
    });
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ngày Lương',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi')],
      locale: const Locale('vi'),
    );
  }
}
