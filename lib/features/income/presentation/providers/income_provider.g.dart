// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'd8a123f8131dddc25218cf0b7e15eff43b58543c';

/// Override with the preloaded instance from main().
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$incomeStorageHash() => r'3f69841a89ab24760a20b2de97a60d1f28db9f48';

/// See also [incomeStorage].
@ProviderFor(incomeStorage)
final incomeStorageProvider = Provider<IncomeStorage>.internal(
  incomeStorage,
  name: r'incomeStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incomeStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IncomeStorageRef = ProviderRef<IncomeStorage>;
String _$incomeRepositoryHash() => r'4d71cb8e5c6e8c62f4706c1fc6188e03edc33d21';

/// See also [incomeRepository].
@ProviderFor(incomeRepository)
final incomeRepositoryProvider = Provider<IncomeRepository>.internal(
  incomeRepository,
  name: r'incomeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incomeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IncomeRepositoryRef = ProviderRef<IncomeRepository>;
String _$incomeProfileNotifierHash() =>
    r'26fe7b6080ba6e0e694f793d495ab75a3b4bb1ca';

/// See also [IncomeProfileNotifier].
@ProviderFor(IncomeProfileNotifier)
final incomeProfileNotifierProvider =
    AsyncNotifierProvider<IncomeProfileNotifier, IncomeProfile?>.internal(
  IncomeProfileNotifier.new,
  name: r'incomeProfileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incomeProfileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IncomeProfileNotifier = AsyncNotifier<IncomeProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
