import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/save_card/domain/save_card_template.dart';

void main() {
  test('default template is sleepOnIt when no sale info', () {
    const input = SaveCardInput(days: 3.4);
    expect(input.defaultTemplate(), SaveCardTemplate.sleepOnIt);
  });

  test('default template is onSale when percentOff > 0', () {
    const input = SaveCardInput(days: 3.4, percentOff: 30);
    expect(input.defaultTemplate(), SaveCardTemplate.onSale);
  });

  test('percentOff = 0 falls back to sleepOnIt', () {
    const input = SaveCardInput(days: 3.4, percentOff: 0);
    expect(input.defaultTemplate(), SaveCardTemplate.sleepOnIt);
  });

  test('three templates exist in the enum', () {
    expect(SaveCardTemplate.values.length, 3);
  });

  test('availableTemplates excludes onSale when no real percent', () {
    const input = SaveCardInput(days: 3.4);
    expect(input.hasRealSalePercent, false);
    expect(input.availableTemplates(), isNot(contains(SaveCardTemplate.onSale)));
    expect(input.availableTemplates(), contains(SaveCardTemplate.sleepOnIt));
    expect(input.availableTemplates(), contains(SaveCardTemplate.skipped));
  });

  test('availableTemplates includes onSale when percent provided', () {
    const input = SaveCardInput(days: 3.4, percentOff: 30);
    expect(input.availableTemplates(), contains(SaveCardTemplate.onSale));
  });
}
