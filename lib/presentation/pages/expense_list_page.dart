import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      builder: (_) => AddExpensePage(), // Navigate to AddExpensePage
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Make corners sharp
                  ),
                ),
                child: Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.grey[800]), // Dark grey text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}