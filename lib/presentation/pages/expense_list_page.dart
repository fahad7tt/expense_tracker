import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_list_item.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense List')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final expenses = provider.expenses;

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              return ExpenseListItem(expense: expenses[index]);
            },
          );
        },
      ),
    );
  }
}