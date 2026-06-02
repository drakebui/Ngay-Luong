import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/quick_check/presentation/widgets/worth_check_section.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

const _sentinel = Object();

final _profile = IncomeProfile(
  mode: IncomeMode.daily,
  dailyIncome: 500000,
  workHoursPerDay: 8,
  updatedAt: DateTime(2026),
);

Widget _wrap(Widget child, {Object? profile = _sentinel}) {
  final resolved = identical(profile, _sentinel) ? _profile : profile as IncomeProfile?;
  return ProviderScope(
    overrides: [
      incomeProfileNotifierProvider.overrideWith(
        () => _FakeIncomeNotifier(resolved),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('collapsed by default — no input fields visible', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000)));
    await tester.pump();

    expect(find.byType(TextField), findsNothing);
    expect(find.text('Tính đáng không?'), findsOneWidget);
  });

  testWidgets('tap trigger expands and shows input fields', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000)));
    await tester.pump();

    await tester.tap(find.text('Tính đáng không?'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('valid expectedUses shows cost-per-use', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000)));
    await tester.pump();

    await tester.tap(find.text('Tính đáng không?'));
    await tester.pumpAndSettle();

    final usesField = find.widgetWithText(
      TextField,
      'Bạn nghĩ sẽ dùng bao nhiêu lần?',
    );
    await tester.enterText(usesField, '10');
    await tester.pump();

    expect(find.textContaining('/lần dùng'), findsOneWidget);
  });

  testWidgets('invalid expectedUses (0) hides cost-per-use', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000)));
    await tester.pump();

    await tester.tap(find.text('Tính đáng không?'));
    await tester.pumpAndSettle();

    final usesField = find.widgetWithText(
      TextField,
      'Bạn nghĩ sẽ dùng bao nhiêu lần?',
    );
    await tester.enterText(usesField, '0');
    await tester.pump();

    expect(find.textContaining('/lần dùng'), findsNothing);
  });

  testWidgets('valid acceptablePrice shows usesToWorthIt', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000)));
    await tester.pump();

    await tester.tap(find.text('Tính đáng không?'));
    await tester.pumpAndSettle();

    final usesField = find.widgetWithText(
      TextField,
      'Bạn nghĩ sẽ dùng bao nhiêu lần?',
    );
    await tester.enterText(usesField, '5');
    await tester.pump();

    final acceptableField = find.widgetWithText(
      TextField,
      'Muốn xuống mức bao nhiêu đ/lần?',
    );
    await tester.enterText(acceptableField, '50000');
    await tester.pump();

    expect(find.textContaining('lần để xuống mức'), findsOneWidget);
  });

  testWidgets('usesToWorthIt hidden when acceptablePrice is empty', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000)));
    await tester.pump();

    await tester.tap(find.text('Tính đáng không?'));
    await tester.pumpAndSettle();

    final usesField = find.widgetWithText(
      TextField,
      'Bạn nghĩ sẽ dùng bao nhiêu lần?',
    );
    await tester.enterText(usesField, '5');
    await tester.pump();

    expect(find.textContaining('lần để xuống mức'), findsNothing);
  });

  testWidgets('shows nothing when profile is null', (tester) async {
    await tester.pumpWidget(_wrap(const WorthCheckSection(price: 1000000), profile: null));
    await tester.pump();

    expect(find.text('Tính đáng không?'), findsNothing);
  });
}

class _FakeIncomeNotifier extends AsyncNotifier<IncomeProfile?> {
  _FakeIncomeNotifier(this._fakeProfile);
  final IncomeProfile? _fakeProfile;

  @override
  Future<IncomeProfile?> build() async => _fakeProfile;
}
