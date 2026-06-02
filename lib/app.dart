import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngay_luong/core/router/app_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_theme.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class NgayLuongApp extends StatefulWidget {
  const NgayLuongApp({super.key, this.initialLocation = Routes.home});

  final String initialLocation;

  @override
  State<NgayLuongApp> createState() => _NgayLuongAppState();
}

class _NgayLuongAppState extends State<NgayLuongApp> {
  late final _router = makeAppRouter(widget.initialLocation);

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
