import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/crush/presentation/widgets/mascot_overlay.dart';

void main() {
  test('mascot copy matches survived variant', () {
    expect(
      mascotOverlayCopy(days: 2.5, isSurvived: true),
      'Tôi sống rồi.',
    );
  });

  test('mascot copy includes days for fly-away variant', () {
    expect(
      mascotOverlayCopy(days: 2.5, isSurvived: false),
      contains('2,5 ngày lương bay qua cửa sổ'),
    );
  });
}
