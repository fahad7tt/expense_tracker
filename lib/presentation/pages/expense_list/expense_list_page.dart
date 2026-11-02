import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/expense_summary_provider.dart';
import '../../widgets/confirm_dialog/confirm_dialog.dart';
import '../../widgets/expense_list_items/expense_list_items.dart';
import '../edit_expense/edit_expense_page.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final int _selectedFilterIndex = 0; // 0: All, 1: Expenses, 2: Income
  String _selectedChipId = 'today'; // Default selected chip: 'today'

  DateTime get _now => DateTime.now();

  DateTime get _todayStart => DateTime(_now.year, _now.month, _now.day);
  DateTime get _todayEnd =>
      DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

  DateTime get _startOfWeek {
    final today = _todayStart;
    return today.subtract(Duration(days: today.weekday - 1)); // Monday 00:00
  }

  DateTime get _endOfWeek {
    final start = _startOfWeek;
    return DateTime(
      start.year,
      start.month,
      start.day,
      23,
      59,
      59,
    ).add(const Duration(days: 6)); // Sunday 23:59:59
  }

  bool _isToday(DateTime date) {
    return !date.isBefore(_todayStart) && !date.isAfter(_todayEnd);
  }

  bool _isThisWeek(DateTime date) {
    return !date.isBefore(_startOfWeek) && !date.isAfter(_endOfWeek);
  }

  bool _matchesCategory(String? type, String key) {
    if (type == null) return key == 'living';
    final lower = type.toLowerCase();
    if (key == 'investment') return lower.contains('investment');
    if (key == 'savings') {
      return lower.contains('savings') ||
          lower.contains('insurance') ||
          lower.contains('tax');
    }
    if (key == 'donation') {
      return lower.contains('donation') ||
          lower.contains('charity') ||
          lower.contains('gift');
    }
    if (key == 'personal development') {
      return lower.contains('personal development') ||
          lower.contains('education') ||
          lower.contains('book');
    }
    // living & utilities
    return !lower.contains('investment') &&
        !lower.contains('savings') &&
        !lower.contains('insurance') &&
        !lower.contains('tax') &&
        !lower.contains('donation') &&
        !lower.contains('charity') &&
        !lower.contains('gift') &&
        !lower.contains('personal development') &&
        !lower.contains('education') &&
        !lower.contains('book');
  }

  Color _getSelectedCategoryColor(String chipId) {
    if (chipId == 'living') return const Color(0xFFF59E0B);
    if (chipId == 'investment') return const Color(0xFF8B5CF6);
    if (chipId == 'savings') return softBlue;
    if (chipId == 'donation') return profitColor;
    if (chipId == 'personal_dev') return const Color(0xFFEC4899);
    return softBlue;
  }

  int _getChipTxnCount(List<Expense> all, String chipId) {
    if (chipId == 'today') {
      return all.where((e) => _isToday(e.date)).length;
    } else if (chipId == 'this_week') {
      return all.where((e) => _isThisWeek(e.date)).length;
    } else if (chipId == 'living') {
      return all.where((e) => _matchesCategory(e.type, 'living')).length;
    } else if (chipId == 'investment') {
      return all.where((e) => _matchesCategory(e.type, 'investment')).length;
    } else if (chipId == 'savings') {
      return all.where((e) => _matchesCategory(e.type, 'savings')).length;
    } else if (chipId == 'donation') {
      return all.where((e) => _matchesCategory(e.type, 'donation')).length;
    } else if (chipId == 'personal_dev') {
      return all
          .where((e) => _matchesCategory(e.type, 'personal development'))
          .length;
    }
    return all.length;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchAllExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions'), centerTitle: true),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final all = provider.currentCycleExpenses;
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

          // Filter expenses based on selected Chip
          List<Expense> filteredExpenses;
          if (_selectedChipId == 'today') {
            filteredExpenses = all.where((e) => _isToday(e.date)).toList();
          } else if (_selectedChipId == 'this_week') {
            filteredExpenses = all.where((e) => _isThisWeek(e.date)).toList();
          } else if (_selectedChipId == 'living') {
            filteredExpenses = all
                .where((e) => _matchesCategory(e.type, 'living'))
                .toList();
          } else if (_selectedChipId == 'investment') {
            filteredExpenses = all
                .where((e) => _matchesCategory(e.type, 'investment'))
                .toList();
          } else if (_selectedChipId == 'savings') {
            filteredExpenses = all
                .where((e) => _matchesCategory(e.type, 'savings'))
                .toList();
          } else if (_selectedChipId == 'donation') {
            filteredExpenses = all
                .where((e) => _matchesCategory(e.type, 'donation'))
                .toList();
          } else if (_selectedChipId == 'personal_dev') {
            filteredExpenses = all
                .where((e) => _matchesCategory(e.type, 'personal development'))
                .toList();
          } else {
            filteredExpenses = List.from(all);
          }

          // Filter by Expense vs Income segmented tab
          if (_selectedFilterIndex == 1) {
            filteredExpenses = filteredExpenses
                .where((e) => !e.isProfit)
                .toList();
          } else if (_selectedFilterIndex == 2) {
            filteredExpenses = filteredExpenses
                .where((e) => e.isProfit)
                .toList();
          }

          // Calculate net total amount (+/-) for current filtered category chip
          double chipNetTotal = 0;
          for (var e in filteredExpenses) {
            if (e.isProfit) {
              chipNetTotal += e.amount;
            } else {
              chipNetTotal -= e.amount;
            }
          }

          // Sort in chronological order
          if (provider.isAscending) {
            filteredExpenses.sort((a, b) => a.date.compareTo(b.date));
          } else {
            filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
          }

          // Dynamic Title & Subtitle for Section
          String sectionTitle = "TRANSACTIONS";
          String sectionSubtitle = "";

          if (_selectedChipId == 'today') {
            sectionTitle = "TODAY'S TRANSACTIONS";
            sectionSubtitle = DateFormat('dd MMMM yyyy').format(_now);
          } else if (_selectedChipId == 'this_week') {
            sectionTitle = "THIS WEEK'S TRANSACTIONS";
            sectionSubtitle =
                '${DateFormat('dd MMM').format(_startOfWeek)} – ${DateFormat('dd MMM yyyy').format(_endOfWeek)}';
          } else if (_selectedChipId == 'living') {
            sectionTitle = "LIVING & UTILITIES TRANSACTIONS";
            sectionSubtitle = "Essential & daily expenses";
          } else if (_selectedChipId == 'investment') {
            sectionTitle = "INVESTMENT TRANSACTIONS";
            sectionSubtitle = "Wealth building investments";
          } else if (_selectedChipId == 'savings') {
            sectionTitle = "SAVINGS TRANSACTIONS";
            sectionSubtitle = "Emergency & cash reserves";
          } else if (_selectedChipId == 'donation') {
            sectionTitle = "DONATION & GIVING TRANSACTIONS";
            sectionSubtitle = "Charity & social impact";
          } else if (_selectedChipId == 'personal_dev') {
            sectionTitle = "PERSONAL DEVELOPMENT TRANSACTIONS";
            sectionSubtitle = "Up-skilling & growth";
          }

          return Column(
            children: [
              // HOME CASHFLOW HERO BANNER
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark
                        ? softBlue.withValues(alpha: 0.25)
                        : const Color(0xFFBFDBFE),
                    width: 1.2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Stack(
                    children: [
                      // Decorative background watermark icon
                      Positioned(
                        right: -12,
                        bottom: -16,
                        child: Icon(
                          Icons.insights_rounded,
                          size: 90,
                          color: softBlue.withValues(alpha: 0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: softBlue.withValues(
                                      alpha: isDark ? 0.18 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.swap_vert_rounded,
                                        size: 13,
                                        color: isDark
                                            ? const Color(0xFF93C5FD)
                                            : const Color(0xFF2563EB),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'TOTAL CASHFLOW',
                                        style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 1.1,
                                          color: isDark
                                              ? const Color(0xFF93C5FD)
                                              : const Color(0xFF2563EB),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '$currency ${formatAmount(netTotal)}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? (netTotal >= 0
                                                ? Colors.white
                                                : Colors.redAccent)
                                            : (netTotal >= 0
                                                ? const Color(0xFF0F172A)
                                                : const Color(0xFFDC2626)),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildHeroStatPill(
                                    label: 'Earned',
                                    amount:
                                        '$currency ${formatAmount(totalIncome)}',
                                    color: profitColor,
                                    icon: Icons.arrow_downward_rounded,
                                    isDark: isDark,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildHeroStatPill(
                                    label: 'Spent',
                                    amount:
                                        '$currency ${formatAmount(totalSpent)}',
                                    color: expenseColor,
                                    icon: Icons.arrow_upward_rounded,
                                    isDark: isDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CATEGORY CHIPS BAR (TODAY, THIS WEEK, FINANCIAL CATEGORIES)
              _buildCategoryChips(context, all),

              // TRANSACTIONS SECTION HEADER ROW
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                sectionTitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: softBlue.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${filteredExpenses.length}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: softBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (sectionSubtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              sectionSubtitle,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? lightGrayText
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 6),
                          // CATEGORY TOTAL DISPLAY IN COLORED CONTAINER MATCHING FINANCIAL CATEGORY
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getSelectedCategoryColor(_selectedChipId),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              chipNetTotal < 0
                                  ? "-$currency ${formatAmount(chipNetTotal.abs())}"
                                  : "$currency ${formatAmount(chipNetTotal)}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        provider.isAscending
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 18,
                        color: softBlue,
                      ),
                      tooltip: 'Toggle Sort Order',
                      onPressed: () {
                        provider.sortExpensesByDate();
                      },
                    ),
                  ],
                ),
              ),

              // FILTERED TRANSACTIONS LIST
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: filteredExpenses.isEmpty
                      ? Center(
                          key: ValueKey('empty_state_$_selectedChipId'),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: 48,
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No transactions found",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? lightGrayText
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Tap '+' to add a transaction",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          key: ValueKey('list_chip_$_selectedChipId'),
                          padding: const EdgeInsets.only(top: 2, bottom: 20),
                          itemCount: filteredExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = filteredExpenses[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF334155).withValues(alpha: 0.5)
                                      : const Color(0xFFE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black.withValues(alpha: 0.15)
                                        : Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
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
                                            builder: (_) => EditExpensePage(
                                              expense: expense,
                                            ),
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
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
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
                        ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildCategoryChips(BuildContext context, List<Expense> all) {
    final isDark = context.isDarkMode;

    final chips = [
      _ChipData(id: 'today', label: 'Today', color: softBlue),
      _ChipData(id: 'this_week', label: 'This Week', color: softBlue),
      _ChipData(
        id: 'living',
        label: 'Living & Utilities',
        color: const Color(0xFFF59E0B),
      ),
      _ChipData(
        id: 'investment',
        label: 'Investment',
        color: const Color(0xFF8B5CF6),
      ),
      _ChipData(id: 'savings', label: 'Savings', color: softBlue),
      _ChipData(id: 'donation', label: 'Donation', color: profitColor),
      _ChipData(
        id: 'personal_dev',
        label: 'Personal Development',
        color: const Color(0xFFEC4899),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: chips.map((chip) {
          final isSelected = _selectedChipId == chip.id;
          final count = _getChipTxnCount(all, chip.id);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chip.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? lightColor : darkGray),
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : chip.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : chip.color,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              selected: isSelected,
              selectedColor: chip.color,
              backgroundColor: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? chip.color
                      : (isDark
                            ? const Color(0xFF334155).withValues(alpha: 0.6)
                            : const Color(0xFFE2E8F0)),
                ),
              ),
              elevation: isSelected ? 3 : 0,
              pressElevation: 1,
              shadowColor: chip.color.withValues(alpha: 0.3),
              onSelected: (selected) {
                if (selected) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedChipId = chip.id;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeroStatPill({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
    bool isDark = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : color.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.25 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int expenseId) {
    DialogService.showDeleteConfirmationDialog(
      context,
      () async {
        await Provider.of<ExpenseProvider>(
          context,
          listen: false,
        ).removeExpense(expenseId);
        if (mounted) {
          await Provider.of<ExpenseSummaryProvider>(
            context,
            listen: false,
          ).refreshCurrentMonth();
        }
      },
    );
  }
}

class _ChipData {
  final String id;
  final String label;
  final Color color;

  _ChipData({required this.id, required this.label, required this.color});
}
