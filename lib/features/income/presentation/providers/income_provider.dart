import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngay_luong/features/income/data/income_repository.dart';
import 'package:ngay_luong/features/income/data/income_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'income_provider.g.dart';

/// Override with the preloaded instance from main().
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
}

@Riverpod(keepAlive: true)
IncomeStorage incomeStorage(Ref ref) => const IncomeStorage();

@Riverpod(keepAlive: true)
IncomeRepository incomeRepository(Ref ref) {
  return IncomeRepository(
    storage: ref.watch(incomeStorageProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
}

@Riverpod(keepAlive: true)
class IncomeProfileNotifier extends _$IncomeProfileNotifier {
  @override
  Future<IncomeProfile?> build() {
    return ref.read(incomeRepositoryProvider).loadProfile();
  }

  Future<void> save(IncomeProfile profile) async {
    await ref.read(incomeRepositoryProvider).saveProfile(profile);
    state = AsyncData(profile);
  }

  Future<void> clear() async {
    await ref.read(incomeRepositoryProvider).clearProfile();
    state = const AsyncData(null);
  }
}
