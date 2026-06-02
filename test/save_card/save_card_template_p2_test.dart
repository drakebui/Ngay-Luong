import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/save_card/domain/save_card_template.dart';

void main() {
  test('payday is always available and default template is unchanged', () {
    const input = SaveCardInput(days: 2.5);

    expect(input.defaultTemplate(), SaveCardTemplate.sleepOnIt);
    expect(input.availableTemplates(), contains(SaveCardTemplate.payday));
    expect(input.availableTemplates(), isNot(contains(SaveCardTemplate.onSale)));
  });

  test('anti-haul celebration requires a positive saved count', () {
    expect(
      const SaveCardInput(days: 2.5).availableTemplates(),
      isNot(contains(SaveCardTemplate.antiHaulCelebration)),
    );
    expect(
      const SaveCardInput(days: 2.5, savedCount: 0).availableTemplates(),
      isNot(contains(SaveCardTemplate.antiHaulCelebration)),
    );
    expect(
      const SaveCardInput(days: 2.5, savedCount: 2).availableTemplates(),
      contains(SaveCardTemplate.antiHaulCelebration),
    );
  });

  test('sale still drives default template when real percent exists', () {
    const input = SaveCardInput(days: 2.5, percentOff: 10);

    expect(input.defaultTemplate(), SaveCardTemplate.onSale);
    expect(input.availableTemplates(), contains(SaveCardTemplate.onSale));
    expect(input.availableTemplates(), contains(SaveCardTemplate.payday));
  });
}
