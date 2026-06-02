import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ngay_luong/app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('M0 shell renders Midnight Matcha app chrome', (tester) async {
    await tester.pumpWidget(const NgayLuongApp());
    await tester.pumpAndSettle();

    expect(find.text('Ngày Lương'), findsOneWidget);
    expect(find.text('Tính toán'), findsOneWidget);
    expect(find.text('Crush'), findsOneWidget);
    expect(find.byIcon(Symbols.settings), findsOneWidget);
    expect(find.byIcon(Symbols.calculate), findsOneWidget);
    expect(find.byIcon(Symbols.favorite), findsOneWidget);
  });
}
