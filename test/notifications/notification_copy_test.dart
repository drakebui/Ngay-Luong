import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/core/notifications/notification_copy.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';

void main() {
  CrushCard card({
    String id = 'card-1',
    String? name,
    CrushReason? reason,
    DateTime? createdAt,
  }) {
    return CrushCard(
      id: id,
      name: name,
      price: 1000000,
      daysOfWageSnapshot: 1.5,
      hoursOfWorkSnapshot: 12,
      reason: reason,
      status: CrushStatus.sleepOnIt,
      createdAt: createdAt ?? DateTime(2026, 5, 29),
      updatedAt: DateTime(2026, 5, 29),
    );
  }

  test('pool is deterministic for the same card id', () {
    final c = card(id: 'same');

    expect(
      NotificationCopyPool.selectFor(
        c,
        detailMode: false,
        now: DateTime(2026, 5, 29),
      ),
      NotificationCopyPool.selectFor(
        c,
        detailMode: false,
        now: DateTime(2026, 5, 29),
      ),
    );
  });

  test('all four pool slots can be reached', () {
    final bodies = <String>{};
    var seed = 0;
    while (bodies.length < 4 && seed < 10000) {
      bodies.add(
        NotificationCopyPool.selectFor(
          card(id: 'card-$seed'),
          detailMode: false,
          now: DateTime(2026, 5, 29),
        ).$2,
      );
      seed++;
    }

    expect(bodies, hasLength(4));
  });

  test('reason after at least one day uses FOMO recall', () {
    final copy = NotificationCopyPool.selectFor(
      card(reason: CrushReason.stress, createdAt: DateTime(2026, 5, 28)),
      detailMode: false,
      now: DateTime(2026, 5, 29),
    );

    expect(copy.$2, contains('1 ngày trước'));
    expect(copy.$2, contains(CrushReason.stress.label));
  });

  test('same-day reason falls back to pool', () {
    final copy = NotificationCopyPool.selectFor(
      card(reason: CrushReason.stress, createdAt: DateTime(2026, 5, 29)),
      detailMode: false,
      now: DateTime(2026, 5, 29),
    );

    expect(copy.$2, isNot(contains('ngày trước')));
  });

  test('detail mode uses item title and recall body when possible', () {
    final copy = NotificationCopyPool.selectFor(
      card(
        name: 'Tai nghe',
        reason: CrushReason.sawReview,
        createdAt: DateTime(2026, 5, 27),
      ),
      detailMode: true,
      now: DateTime(2026, 5, 29),
    );

    expect(copy.$1, 'Còn mê Tai nghe không?');
    expect(copy.$2, contains('2 ngày trước'));
  });
}
