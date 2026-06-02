import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/app.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/core/notifications/recap_notification_service.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/features/crush/presentation/providers/crush_providers.dart';
import 'package:ngay_luong/features/income/data/income_repository.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/settings/presentation/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isOnboardingDone =
      prefs.getBool(IncomeRepository.onboardingDoneKey) ?? false;
  final initialLocation = isOnboardingDone ? Routes.home : Routes.onboarding;

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  final recapService = RecapNotificationService(
    adapter: FlutterLocalNotificationPluginAdapter(),
    prefs: prefs,
    crushRepository: container.read(crushRepositoryProvider),
  );
  try {
    await RecapNotificationService.scheduleOnStartup(
      service: recapService,
      prefs: prefs,
      paydayDay: container.read(settingsRepositoryProvider).paydayDay,
    );
  } catch (_) {
    debugPrint('Recap notification startup scheduling skipped.');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: NgayLuongApp(initialLocation: initialLocation),
    ),
  );
}
