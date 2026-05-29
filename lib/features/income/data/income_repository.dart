import 'package:ngay_luong/features/income/data/income_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeRepository {
  const IncomeRepository({
    required this.storage,
    required this.prefs,
  });

  final IncomeStorage storage;
  final SharedPreferences prefs;

  static const _onboardingKey = 'onboarding_done';

  Future<IncomeProfile?> loadProfile() => storage.read();

  /// Saves the profile and marks onboarding done as one logical operation.
  Future<void> saveProfile(IncomeProfile profile) async {
    await storage.write(profile);
    await prefs.setBool(_onboardingKey, true);
  }

  /// Used by full data reset later.
  Future<void> clearProfile() async {
    await storage.clear();
    await prefs.remove(_onboardingKey);
  }

  /// Sync because SharedPreferences is loaded before runApp().
  bool isOnboardingDone() => prefs.getBool(_onboardingKey) ?? false;
}
