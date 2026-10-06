class FixedItem {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final String? category;
  final String? currency;
  final bool isActive;

  FixedItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    this.category,
    this.currency,
    this.isActive = true,
  });

  FixedItem copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isIncome,
    String? category,
    String? currency,
    bool? isActive,
  }) {
    return FixedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
    );
  }
}
