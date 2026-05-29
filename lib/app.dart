import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';
import 'package:ngay_luong/core/router/app_router.dart';

class NgayLuongApp extends StatelessWidget {
  const NgayLuongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ngày Lương',
      routerConfig: appRouter,
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
