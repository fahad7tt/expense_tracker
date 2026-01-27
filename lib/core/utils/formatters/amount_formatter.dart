import 'package:intl/intl.dart';

String formatAmount(double amount) {
  final formatter = NumberFormat("#,##0.##", "en_US");
  return formatter.format(amount);
}
