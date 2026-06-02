import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/income/data/income_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';

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
  group('IncomeStorage', () {
    test('round-trips profile JSON through secure string storage', () async {
      final secureStore = _MemorySecureStringStorage();
      final storage = IncomeStorage(storage: secureStore);
      final profile = IncomeProfile(
        mode: IncomeMode.monthly,
        monthlyNetIncome: 22000000,
        workDaysPerMonth: 22,
        workHoursPerDay: 8,
        updatedAt: DateTime(2026, 6, 2),
      );

      await storage.write(profile);
      final loaded = await storage.read();

      expect(secureStore.values.keys, contains(IncomeStorage.key));
      expect(loaded?.mode, IncomeMode.monthly);
      expect(loaded?.monthlyNetIncome, 22000000);
      expect(loaded?.workDaysPerMonth, 22);
      expect(loaded?.workHoursPerDay, 8);
      expect(loaded?.updatedAt, DateTime(2026, 6, 2));
    });

    test('returns null instead of throwing for empty or corrupted payloads',
        () async {
      final secureStore = _MemorySecureStringStorage();
      final storage = IncomeStorage(storage: secureStore);

      expect(await storage.read(), isNull);

      secureStore.values[IncomeStorage.key] = '{not-json';
      expect(await storage.read(), isNull);

      secureStore.values[IncomeStorage.key] = '[]';
      expect(await storage.read(), isNull);
    });

    test('clear deletes the secure-storage profile payload', () async {
      final secureStore = _MemorySecureStringStorage();
      final storage = IncomeStorage(storage: secureStore);

      await storage.write(
        IncomeProfile(
          mode: IncomeMode.hourly,
          hourlyIncome: 150000,
          updatedAt: DateTime(2026, 6, 2),
        ),
      );
      await storage.clear();

      expect(secureStore.values.containsKey(IncomeStorage.key), false);
      expect(await storage.read(), isNull);
    });
  });
}
