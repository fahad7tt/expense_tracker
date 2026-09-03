import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
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
          // HOME CASHFLOW HERO BANNER
          Consumer<ExpenseProvider>(
            builder: (context, provider, child) {
              final all = provider.expenses;
              double totalSpent = 0;
              double totalIncome = 0;
              String currency = currencies.first;

              for (var e in all) {
                if (e.currency != null && e.currency!.isNotEmpty) {
                  currency = e.currency!;
                }
                if (e.isProfit) {
                  totalIncome += e.amount;
                } else {
                  totalSpent += e.amount;
                }
              }
              final double netTotal = totalIncome - totalSpent;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL CASHFLOW',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.1,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$currency ${formatAmount(netTotal)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: netTotal >= 0 ? Colors.white : Colors.redAccent,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildHeroStatPill(
                          label: 'Earned',
                          amount: '$currency ${formatAmount(totalIncome)}',
                          color: profitColor,
                          icon: Icons.arrow_downward_rounded,
                        ),
                        const SizedBox(width: 8),
                        _buildHeroStatPill(
                          label: 'Spent',
                          amount: '$currency ${formatAmount(totalSpent)}',
                          color: expenseColor,
                          icon: Icons.arrow_upward_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // SEGMENTED FILTER TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / 3;
                  final double alignX = _selectedFilterIndex == 0
                      ? -1.0
                      : (_selectedFilterIndex == 1 ? 0.0 : 1.0);

                  return Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment(alignX, 0.0),
                        child: Container(
                          width: tabWidth,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: softBlue,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: softBlue.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildFilterTab(0, 'All'),
                          _buildFilterTab(1, 'Expenses'),
                          _buildFilterTab(2, 'Income'),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // ACTION BUTTONS (SORT & DATE FILTER)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<ExpenseProvider>(context, listen: false)
                          .sortExpensesByDate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.isDarkMode
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      foregroundColor: context.isDarkMode ? lightColor : deepBlue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: context.isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                    child: Consumer<ExpenseProvider>(
                      builder: (context, provider, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sort_rounded, size: 18),
                            const SizedBox(width: 6),
                            const Text(
                              'Sort Date',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              provider.isAscending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 14,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: softBlue,
                                onPrimary: lightColor,
                                surface: context.isDarkMode ? darkGray : lightColor,
                                onSurface: context.isDarkMode ? lightColor : darkColor,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.isDarkMode
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      foregroundColor: context.isDarkMode ? lightColor : deepBlue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: context.isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.date_range_rounded, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Filter Date',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TRANSACTIONS LIST
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                var expenses = provider.expenses;

                if (_selectedFilterIndex == 1) {
                  expenses = expenses.where((e) => !e.isProfit).toList();
                } else if (_selectedFilterIndex == 2) {
                  expenses = expenses.where((e) => e.isProfit).toList();
                }

                Widget content;
                if (expenses.isEmpty) {
                  content = Center(
                    key: const ValueKey('empty_state'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 56,
                          color: context.isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No transactions recorded",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? lightGrayText
                                : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap '+' to record a new transaction",
                          style: TextStyle(
                            fontSize: 13,
                            color: context.isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  content = ListView.builder(
                    key: ValueKey('list_$_selectedFilterIndex'),
                    padding: const EdgeInsets.only(top: 4, bottom: 20),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: context.isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Slidable(
                          key: ValueKey(expense.id),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.45,
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
                                backgroundColor: softBlue,
                                child: const Icon(
                                  Icons.edit_rounded,
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
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: lightColor,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                          child: ExpenseListItem(expense: expense),
                        ),
                      );
                    },
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.03),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: content,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildHeroStatPill({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
              Text(amount,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(int index, String label) {
    final bool isSelected = _selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_selectedFilterIndex != index) {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedFilterIndex = index;
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
              color: isSelected
                  ? lightColor
                  : (context.isDarkMode ? lightGrayText : darkGray),
            ),
            child: Text(label),
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
