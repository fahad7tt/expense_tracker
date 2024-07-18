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
    return Scaffold(
      appBar: AppBar(title: const Text('Expense List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<ExpenseProvider>(context, listen: false).sortExpensesByDate();
                  },
                  style: ButtonThemes.elevatedButtonStyle,
                  child: Consumer<ExpenseProvider>(
                    builder: (context, provider, child) {
                      return Text(
                        provider.isAscending ? 'Sort Descending' : 'Sort Ascending',
                        style: ButtonThemes.elevatedButtonTextStyle,
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      // ignore: use_build_context_synchronously
                      Provider.of<ExpenseProvider>(context, listen: false)
                          .filterExpensesByDate(picked.start, picked.end);
                    }
                  },
                  style: ButtonThemes.elevatedButtonStyle,
                  child: Text(
                    'Filter by Date',
                    style: ButtonThemes.elevatedButtonTextStyle,
                  ),
                ),
                 ElevatedButton(
                  onPressed: () {
                    Provider.of<ExpenseProvider>(context, listen: false).clearFilters();
                  },
                  style: ButtonThemes.elevatedButtonStyle,
                  child: Text(
                    'Reset Filters',
                    style: ButtonThemes.elevatedButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
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
