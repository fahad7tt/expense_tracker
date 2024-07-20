import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Icon(
        Icons.currency_exchange,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        expense.type!,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(
        '₹${expense.amount}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        DateFormat.yMMMd().format(expense.date),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      tileColor: Theme.of(context).cardTheme.color,
    );
  }
}
