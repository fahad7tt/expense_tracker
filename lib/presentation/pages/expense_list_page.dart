import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/theme/button_theme.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_list_item.dart';
import 'add_expense_page.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch expenses immediately when building the widget
    Provider.of<ExpenseProvider>(context, listen: false).fetchAllExpenses();

    return Scaffold(
      appBar: AppBar(title: const Text('Expense List')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ExpenseProvider>(
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
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddExpensePage(),
                    ),
                  );
                },
                style: ButtonThemes.elevatedButtonStyle,
                child: Text(
                  'Add Expense',
                  style: ButtonThemes.elevatedButtonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
