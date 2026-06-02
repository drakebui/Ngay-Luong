import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ngay_luong/app.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('shell renders Midnight Matcha app chrome', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const NgayLuongApp(),
      ),
    );
    // Two pumps: first frame renders AppLockGate lock screen,
    // post-frame callback unlocks (appLockEnabled defaults to false),
    // second frame renders HomeScreen.
    await tester.pump();
    await tester.pump();

    expect(find.text('Ngày Lương'), findsOneWidget);
    expect(find.text('Tính toán'), findsOneWidget);
    expect(find.text('Crush'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.byIcon(Symbols.calculate), findsOneWidget);
    expect(find.byIcon(Symbols.favorite), findsOneWidget);
  });
}
