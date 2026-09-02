import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme/button_theme.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/confirm_dialog/confirm_dialog.dart';
import '../../widgets/expense_list_items/expense_list_items.dart';
import '../edit_expense/edit_expense_page.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedFilterIndex = 0; // 0: All, 1: Expenses, 2: Profits

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchAllExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _navigatorKey,
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildFilterTab(0, 'All'),
                  _buildFilterTab(1, 'Expenses'),
                  _buildFilterTab(2, 'Profits'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          Text('Sort by Date',
                              style: ButtonThemes.elevatedButtonTextStyle
                                  .copyWith(
                                      color: context.isDarkMode
                                          ? darkColor
                                          : deepBlue)),
                          const SizedBox(width: 5.0),
                          Icon(
                            provider.isAscending
                                ? Icons.keyboard_double_arrow_up_sharp
                                : Icons.keyboard_double_arrow_down_sharp,
                            color: context.isDarkMode ? darkColor : deepBlue,
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
                      lastDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      builder: (context, child) {
                        if (context.isDarkMode) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: buttonColor,
                                onPrimary: lightColor,
                                surface: darkGray,
                                onSurface: lightColor,
                                secondary: buttonColor,
                              ),
                              datePickerTheme: DatePickerThemeData(
                                rangeSelectionBackgroundColor: lightColor,
                                confirmButtonStyle: TextButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  foregroundColor: lightColor,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        }
                        return Theme(
                          data: Theme.of(context).copyWith(
                            datePickerTheme: const DatePickerThemeData(
                              rangeSelectionBackgroundColor: buttonColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      // ignore: use_build_context_synchronously
                      Provider.of<ExpenseProvider>(context, listen: false)
                          .filterExpensesByDate(picked.start, picked.end);
                    }
                  },
                  style: ButtonThemes.sortFilterButtonStyle,
                  child: Text('Filter by Date',
                      style: ButtonThemes.elevatedButtonTextStyle.copyWith(
                          color: context.isDarkMode ? darkColor : deepBlue)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                var expenses = provider.expenses;

                if (_selectedFilterIndex == 1) {
                  expenses = expenses.where((e) => !e.isProfit).toList();
                } else if (_selectedFilterIndex == 2) {
                  expenses = expenses.where((e) => e.isProfit).toList();
                }

                if (expenses.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tap the '+' button to add transactions",
                    ),
                  );
                }

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
                            CustomSlidableAction(
                              onPressed: (context) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditExpensePage(expense: expense),
                                  ),
                                );
                              },
                              backgroundColor: context.isDarkMode
                                  ? Colors.grey.shade700
                                  : deepBlue,
                              child: const Icon(
                                Icons.edit,
                                color: lightColor,
                                size: 22,
                              ),
                            ),
                            CustomSlidableAction(
                              onPressed: (context) {
                                _showDeleteDialog(expense.id);
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              child: const Icon(
                                Icons.delete,
                                color: lightColor,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildFilterTab(int index, String label) {
    final bool isSelected = _selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (context.isDarkMode ? darkGray : lightColor)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? (context.isDarkMode ? lightColor : deepBlue)
                  : (context.isDarkMode ? lightGrayText : darkGray),
            ),
          ),
        ),
      ),
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
