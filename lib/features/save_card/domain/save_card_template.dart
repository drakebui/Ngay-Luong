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
    if (hasRealSalePercent) return SaveCardTemplate.onSale;
    return SaveCardTemplate.sleepOnIt;
  }

  /// True only when the user actually provided a positive discount.
  /// `onSale` template is only valid in this case — otherwise it would
  /// fabricate a "Sale 50%" badge on a shareable card.
  bool get hasRealSalePercent => percentOff != null && percentOff! > 0;

  /// Templates the user is allowed to pick for this input. Filters out
  /// `onSale` when no real percent was provided.
  List<SaveCardTemplate> availableTemplates() {
    return SaveCardTemplate.values
        .where((t) => t != SaveCardTemplate.onSale || hasRealSalePercent)
        .toList();
  }
}
