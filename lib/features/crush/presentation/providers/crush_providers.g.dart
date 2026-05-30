// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crush_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'8ab73ef1293e27f6de024928c2e888eefcb35e1d';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$imageStorageHash() => r'698d9339258fa9734ba82f248c18be989225f493';

/// See also [imageStorage].
@ProviderFor(imageStorage)
final imageStorageProvider = Provider<ImageStorage>.internal(
  imageStorage,
  name: r'imageStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$imageStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImageStorageRef = ProviderRef<ImageStorage>;
String _$notificationServiceHash() =>
    r'015117d47fe71bf44664bf802ad1290b1e2492d4';

/// See also [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider = Provider<NotificationService>.internal(
  notificationService,
  name: r'notificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationServiceRef = ProviderRef<NotificationService>;
String _$crushRepositoryHash() => r'26f92fa55e28ac2c9f466f8fe7fe40d4d30d37dc';

/// See also [crushRepository].
@ProviderFor(crushRepository)
final crushRepositoryProvider = Provider<CrushRepository>.internal(
  crushRepository,
  name: r'crushRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crushRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrushRepositoryRef = ProviderRef<CrushRepository>;
String _$crushCardsHash() => r'8391900a153caf4ca1ebfcf9f9a53a119acec985';

/// See also [crushCards].
@ProviderFor(crushCards)
final crushCardsProvider = StreamProvider<List<CrushCard>>.internal(
  crushCards,
  name: r'crushCardsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$crushCardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrushCardsRef = StreamProviderRef<List<CrushCard>>;
String _$crushPendingHash() => r'37b96983f96b7faf5a111eea411aff696ec4c253';

/// See also [crushPending].
@ProviderFor(crushPending)
final crushPendingProvider =
    AutoDisposeStreamProvider<List<CrushCard>>.internal(
  crushPending,
  name: r'crushPendingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$crushPendingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrushPendingRef = AutoDisposeStreamProviderRef<List<CrushCard>>;
String _$crushSavedDaysHash() => r'0c6fd36e61aa695c3c0a155e6462532dd5f7ce68';

/// See also [crushSavedDays].
@ProviderFor(crushSavedDays)
final crushSavedDaysProvider = AutoDisposeFutureProvider<double>.internal(
  crushSavedDays,
  name: r'crushSavedDaysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crushSavedDaysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrushSavedDaysRef = AutoDisposeFutureProviderRef<double>;
String _$crushCardHash() => r'bc82d6f7a758ed47e9b3f3c7b44b78ca637cfc13';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [crushCard].
@ProviderFor(crushCard)
const crushCardProvider = CrushCardFamily();

/// See also [crushCard].
class CrushCardFamily extends Family<AsyncValue<CrushCard?>> {
  /// See also [crushCard].
  const CrushCardFamily();

  /// See also [crushCard].
  CrushCardProvider call(
    String cardId,
  ) {
    return CrushCardProvider(
      cardId,
    );
  }

  @override
  CrushCardProvider getProviderOverride(
    covariant CrushCardProvider provider,
  ) {
    return call(
      provider.cardId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'crushCardProvider';
}

/// See also [crushCard].
class CrushCardProvider extends AutoDisposeFutureProvider<CrushCard?> {
  /// See also [crushCard].
  CrushCardProvider(
    String cardId,
  ) : this._internal(
          (ref) => crushCard(
            ref as CrushCardRef,
            cardId,
          ),
          from: crushCardProvider,
          name: r'crushCardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$crushCardHash,
          dependencies: CrushCardFamily._dependencies,
          allTransitiveDependencies: CrushCardFamily._allTransitiveDependencies,
          cardId: cardId,
        );

  CrushCardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardId,
  }) : super.internal();

  final String cardId;

  @override
  Override overrideWith(
    FutureOr<CrushCard?> Function(CrushCardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CrushCardProvider._internal(
        (ref) => create(ref as CrushCardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardId: cardId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CrushCard?> createElement() {
    return _CrushCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CrushCardProvider && other.cardId == cardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CrushCardRef on AutoDisposeFutureProviderRef<CrushCard?> {
  /// The parameter `cardId` of this provider.
  String get cardId;
}

class _CrushCardProviderElement
    extends AutoDisposeFutureProviderElement<CrushCard?> with CrushCardRef {
  _CrushCardProviderElement(super.provider);

  @override
  String get cardId => (origin as CrushCardProvider).cardId;
}

String _$crushCalendarHash() => r'f873b4ea4feacd055f382394b9b19627b23349b7';

/// See also [crushCalendar].
@ProviderFor(crushCalendar)
final crushCalendarProvider =
    AutoDisposeProvider<AsyncValue<CrushCalendarView>>.internal(
  crushCalendar,
  name: r'crushCalendarProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crushCalendarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrushCalendarRef
    = AutoDisposeProviderRef<AsyncValue<CrushCalendarView>>;
String _$crushCalendarFilterHash() =>
    r'fd8625cf4ef9275bddbe4ebbf1fd9c902f092764';

/// See also [CrushCalendarFilter].
@ProviderFor(CrushCalendarFilter)
final crushCalendarFilterProvider = AutoDisposeNotifierProvider<
    CrushCalendarFilter, CrushCalendarStatusFilter>.internal(
  CrushCalendarFilter.new,
  name: r'crushCalendarFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crushCalendarFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CrushCalendarFilter = AutoDisposeNotifier<CrushCalendarStatusFilter>;
String _$crushCalendarMonthHash() =>
    r'bd934bfbcb73d0dae0f8e751d215909562b25caf';

/// See also [CrushCalendarMonth].
@ProviderFor(CrushCalendarMonth)
final crushCalendarMonthProvider =
    AutoDisposeNotifierProvider<CrushCalendarMonth, DateTime>.internal(
  CrushCalendarMonth.new,
  name: r'crushCalendarMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crushCalendarMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CrushCalendarMonth = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
