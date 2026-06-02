import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/quick_check/presentation/widgets/salary_day_banner.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SalaryDayBanner renders and dismisses for this payday',
      (tester) async {
    SharedPreferences.setMockInitialValues({'payday_day': 2});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SalaryDayBanner(now: DateTime(2026, 6, 2)),
          ),
        ),
      ),
    );

    expect(find.text('Lương vừa về. Có món nào đang chờ bạn mua không?'),
        findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(prefs.getInt('salary_day_banner_dismissed_month'), 202606);
  });
}
