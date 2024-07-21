import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme/button_theme.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/confirm_dialog/confirm_dialog.dart';
import '../../widgets/expense_list_items/expense_list_items.dart';
import '../edit_expense/edit_expense_page.dart';

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
        title: const Text('Expenses'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                    Provider.of<ExpenseProvider>(context, listen: false)
                        .sortExpensesByDate();
                  },
                  style: ButtonThemes.sortFilterButtonStyle,
                  child: Consumer<ExpenseProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Sort by Date',
                            style: ButtonThemes.elevatedButtonTextStyle,
                          ),
                          const SizedBox(
                              width: 5.0), // Space between the text and icon
                          Icon(
                            provider.isAscending
                                ? Icons.keyboard_double_arrow_up_sharp
                                : Icons.keyboard_double_arrow_down_sharp,
                            color: provider.isAscending
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondary // Green
                                : Theme.of(context).colorScheme.error, // Red
                          ),
                        ],
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
                  style: ButtonThemes.sortFilterButtonStyle,
                  child: const Text(
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Slidable(
                        key: ValueKey(expense.id),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Edit action
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditExpensePage(expense: expense),
                                  ),
                                );
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: lightColor,
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                // Delete action
                                _showDeleteDialog(expense.id);
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              foregroundColor: lightColor,
                              icon: Icons.delete,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8), bottomRight: Radius.circular(8)
                              ),
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), 
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ExpenseListItem(expense: expense),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _showDeleteDialog(int expenseId) {
    DialogService.showDeleteConfirmationDialog(_navigatorKey.currentContext!,
        () {
      Provider.of<ExpenseProvider>(_navigatorKey.currentContext!, listen: false)
          .removeExpense(expenseId);
    });
  }
}
