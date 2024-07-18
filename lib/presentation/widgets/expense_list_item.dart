import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('₹${expense.amount}'),
      subtitle: Text(expense.description),
      trailing: Text(DateFormat.yMMMd().format(expense.date)),
    );
  }
}