import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/app.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/features/income/data/income_repository.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isOnboardingDone =
      prefs.getBool(IncomeRepository.onboardingDoneKey) ?? false;
  final initialLocation = isOnboardingDone ? Routes.home : Routes.onboarding;

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: NgayLuongApp(initialLocation: initialLocation),
    ),
  );
}
