import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngay_luong/app.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('onboarding renders 4 modes and monthly live preview',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const NgayLuongApp(initialLocation: Routes.onboarding),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Theo tháng'), findsOneWidget);
    expect(find.text('Theo ngày'), findsOneWidget);
    expect(find.text('Theo giờ'), findsOneWidget);
    expect(find.text('Theo dự án'), findsOneWidget);

    await tester.tap(find.text('Theo tháng'));
    await tester.pumpAndSettle();

    expect(find.text('GIÁ TRỊ 1 GIỜ CỦA BẠN'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).first, '25.000.000');
    await tester.pumpAndSettle();

    expect(find.text('142.045đ'), findsOneWidget);
  });
}
