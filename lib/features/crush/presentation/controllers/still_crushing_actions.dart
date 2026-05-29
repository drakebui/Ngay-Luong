import 'package:ngay_luong/features/crush/data/crush_repository.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/crush/domain/remind_at_calculator.dart';

class StillCrushingActions {
  const StillCrushingActions({
    required CrushRepository repository,
    DateTime Function()? now,
  })  : _repository = repository,
        _now = now ?? DateTime.now;

  final CrushRepository _repository;
  final DateTime Function() _now;

  Future<void> stillCrushing(CrushCard card) {
    return _repository.updateCard(
      card.copyWith(
        status: CrushStatus.stillCrushing,
        updatedAt: _now(),
        clearRemindAt: true,
      ),
    );
  }

  Future<void> overIt(CrushCard card) {
    return _repository.updateCard(
      card.copyWith(
        status: CrushStatus.overIt,
        updatedAt: _now(),
        clearRemindAt: true,
      ),
    );
  }

  Future<void> waitingForSale(CrushCard card) {
    return _repository.updateCard(
      card.copyWith(
        status: CrushStatus.waitingForSale,
        updatedAt: _now(),
        clearRemindAt: true,
      ),
    );
  }

  Future<void> bought(CrushCard card) {
    return _repository.updateCard(
      card.copyWith(
        status: CrushStatus.bought,
        updatedAt: _now(),
        clearRemindAt: true,
      ),
    );
  }

  Future<void> remindAgain(
    CrushCard card, {
    required ReminderPreset preset,
    required int paydayDay,
    DateTime? customDateTime,
  }) {
    final now = _now();
    final remindAt = RemindAtCalculator.calculate(
      preset: preset,
      now: now,
      paydayDay: paydayDay,
      customDateTime: customDateTime,
    );
    return _repository.updateCard(
      card.copyWith(
        status: CrushStatus.stillCrushing,
        updatedAt: now,
        remindAt: remindAt,
        remindCount: card.remindCount + 1,
      ),
    );
  }

  Future<void> delete(CrushCard card) {
    return _repository.deleteCard(card.id, imagePath: card.imagePath);
  }
}
