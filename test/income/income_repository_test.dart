import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/income/data/income_repository.dart';
import 'package:ngay_luong/features/income/data/income_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MemorySecureStringStorage implements SecureStringStorage {
  final values = <String, String>{};

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}

void main() {
  group('IncomeRepository', () {
    late SharedPreferences prefs;
    late IncomeStorage storage;
    late IncomeRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      storage = IncomeStorage(storage: _MemorySecureStringStorage());
      repository = IncomeRepository(storage: storage, prefs: prefs);
    });

    test('saveProfile persists profile and marks onboarding done', () async {
      final profiles = [
        IncomeProfile(
          mode: IncomeMode.monthly,
          monthlyNetIncome: 22000000,
          updatedAt: DateTime(2026, 6, 2),
        ),
        IncomeProfile(
          mode: IncomeMode.daily,
          dailyIncome: 900000,
          updatedAt: DateTime(2026, 6, 2),
        ),
        IncomeProfile(
          mode: IncomeMode.hourly,
          hourlyIncome: 120000,
          updatedAt: DateTime(2026, 6, 2),
        ),
        IncomeProfile(
          mode: IncomeMode.project,
          projectIncome: 12000000,
          projectTotalHours: 80,
          updatedAt: DateTime(2026, 6, 2),
        ),
      ];

      for (final profile in profiles) {
        await repository.saveProfile(profile);
        final loaded = await repository.loadProfile();

        expect(loaded?.mode, profile.mode);
        expect(loaded?.isUsable, true);
        expect(repository.isOnboardingDone(), true);
      }
    });

    test('clearProfile removes secure profile and onboarding flag', () async {
      await repository.saveProfile(
        IncomeProfile(
          mode: IncomeMode.monthly,
          monthlyNetIncome: 22000000,
          updatedAt: DateTime(2026, 6, 2),
        ),
      );

      await repository.clearProfile();

      expect(await repository.loadProfile(), isNull);
      expect(repository.isOnboardingDone(), false);
    });
  });
}
