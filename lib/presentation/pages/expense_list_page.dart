import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../core/utils/theme/button_theme.dart';
import '../providers/expense_provider.dart';
import '../widgets/confirm_dialog/confirm_dialog.dart';
import '../widgets/expense_list_item.dart';
import 'add_expense_page.dart';
import 'edit_expense_page.dart';

class ExpenseListPage extends StatelessWidget {
  ExpenseListPage({super.key});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Fetch expenses immediately when building the widget
    Provider.of<ExpenseProvider>(context, listen: false).fetchAllExpenses();

    return Scaffold(
      key: _navigatorKey,
      appBar: AppBar(
        title: const Text('Expense List'), 
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: IconButton(
              onPressed: () {
                Provider.of<ExpenseProvider>(context, listen: false).clearFilters();
              },
              icon: const Icon(Icons.restore_sharp),
              tooltip: 'Reset Filters',
            ),
          ),
        ],
      ),
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
                    final expense = expenses[index];
                    return Slidable(
                      key: ValueKey(expense.id),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Edit action
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditExpensePage(expense: expense),
                                ),
                              );
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              // Delete action
                              _showDeleteDialog(expense.id);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ExpenseListItem(expense: expense),
                    );
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

  void _showDeleteDialog(int expenseId) {
    DialogService.showDeleteConfirmationDialog(_navigatorKey.currentContext!, () {
      Provider.of<ExpenseProvider>(_navigatorKey.currentContext!, listen: false).removeExpense(expenseId);
    });
  }
}