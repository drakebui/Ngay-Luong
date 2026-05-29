import 'package:ngay_luong/core/db/app_database.dart';
import 'package:ngay_luong/core/db/image_storage.dart';
import 'package:ngay_luong/core/notifications/notification_service.dart';
import 'package:ngay_luong/features/crush/domain/crush_calendar.dart';
import 'package:ngay_luong/features/crush/data/crush_repository.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crush_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}

@Riverpod(keepAlive: true)
ImageStorage imageStorage(ImageStorageRef ref) => const ImageStorage();

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

@Riverpod(keepAlive: true)
CrushRepository crushRepository(CrushRepositoryRef ref) {
  return CrushRepository(
    database: ref.watch(appDatabaseProvider),
    imageStorage: ref.watch(imageStorageProvider),
    notificationService: ref.watch(notificationServiceProvider),
  );
}

@Riverpod(keepAlive: true)
Stream<List<CrushCard>> crushCards(CrushCardsRef ref) {
  return ref.watch(crushRepositoryProvider).watchAll();
}

@riverpod
Stream<List<CrushCard>> crushPending(CrushPendingRef ref) {
  return ref.watch(crushRepositoryProvider).watchPending();
}

@riverpod
Future<double> crushSavedDays(CrushSavedDaysRef ref) {
  return ref.watch(crushRepositoryProvider).sumSavedDays();
}

@riverpod
Future<CrushCard?> crushCard(CrushCardRef ref, String cardId) {
  return ref.watch(crushRepositoryProvider).getById(cardId);
}

@riverpod
class CrushCalendarFilter extends _$CrushCalendarFilter {
  @override
  CrushCalendarStatusFilter build() => CrushCalendarStatusFilter.pending;

  void setFilter(CrushCalendarStatusFilter filter) {
    state = filter;
  }
}

@riverpod
class CrushCalendarMonth extends _$CrushCalendarMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void nextMonth() {
    state = DateTime(state.year, state.month + 1);
  }

  void resetToCurrentMonth() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month);
  }
}

@riverpod
AsyncValue<CrushCalendarView> crushCalendar(CrushCalendarRef ref) {
  final cardsAsync = ref.watch(crushCardsProvider);
  final filter = ref.watch(crushCalendarFilterProvider);
  final visibleMonth = ref.watch(crushCalendarMonthProvider);

  return cardsAsync.whenData(
    (cards) => CrushCalendarBuilder.build(
      cards: cards,
      now: DateTime.now(),
      visibleMonth: visibleMonth,
      filter: filter,
    ),
  );
}
