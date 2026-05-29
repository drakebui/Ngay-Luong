/// Templates available on Save Card. MVP ships 3:
/// - sleepOnIt: "Món này = X ngày đi làm. Để mai tính."
/// - onSale:    "Sale Y%, nhưng vẫn là X ngày đi làm."
/// - skipped:   "Tôi vừa không mua món này. +X ngày lương còn sống."
enum SaveCardTemplate { sleepOnIt, onSale, skipped }

/// Input the Save Card needs to render. No raw income leaks here:
/// only [days] (already derived) and optionally an on-sale percent.
class SaveCardInput {
  const SaveCardInput({
    required this.days,
    this.percentOff,
    this.itemName,
  });

  final double days;
  final double? percentOff;
  final String? itemName;

  /// Picks a sensible default template from the available signal.
  SaveCardTemplate defaultTemplate() {
    if (percentOff != null && percentOff! > 0) return SaveCardTemplate.onSale;
    return SaveCardTemplate.sleepOnIt;
  }
}
