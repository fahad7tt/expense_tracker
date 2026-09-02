class ExpenseSummary {
  final String type;
  final double totalAmount;
  final int count;
  final String currency;
  final bool isProfit;

  ExpenseSummary({
    required this.type,
    required this.totalAmount,
    required this.count,
    required this.currency,
    this.isProfit = false,
  });
}
