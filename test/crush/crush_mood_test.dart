import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/crush/domain/crush_mood.dart';

void main() {
  test('CrushMood name round-trips and labels are non-empty', () {
    for (final mood in CrushMood.values) {
      expect(crushMoodFromName(mood.name), mood);
      expect(mood.label, isNotEmpty);
      expect(mood.icon, isNotEmpty);
    }
  });
}
