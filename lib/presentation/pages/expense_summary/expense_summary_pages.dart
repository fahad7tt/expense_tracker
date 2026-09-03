// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';

enum BudgetBucket { living, savings, charity }

BudgetBucket getBucketForCategory(String? type) {
  if (type == null) return BudgetBucket.living;
  final lower = type.toLowerCase();
  if (lower.contains('investment') ||
      lower.contains('savings') ||
      lower.contains('insurance') ||
      lower.contains('tax')) {
    return BudgetBucket.savings;
  } else if (lower.contains('donation') || lower.contains('gift')) {
    return BudgetBucket.charity;
  }
  return BudgetBucket.living;
}

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<ExpenseSummaryProvider>(context);
    final DateTime selectedMonth =
        summaryProvider.selectedMonth ?? DateTime.now();
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final String formattedMonth = formatter.format(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Analytics'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Centered Header Month Switcher Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF1E293B)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: context.isDarkMode
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 24),
                  onPressed: () {
                    final prevMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month - 1,
                      1,
                    );
                    _updateMonth(context, prevMonth);
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showMonthPicker(
                      context: context,
                      initialDate: selectedMonth,
                      firstDate: DateTime(DateTime.now().year - 5, 1),
                      lastDate: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                      monthPickerDialogSettings: MonthPickerDialogSettings(
                        headerSettings: PickerHeaderSettings(
                          headerBackgroundColor: context.isDarkMode
                              ? darkGray
                              : deepBlue,
                          headerCurrentPageTextStyle: const TextStyle(
                            color: lightColor,
                          ),
                        ),
                        dialogSettings: PickerDialogSettings(
                          dialogBackgroundColor: context.isDarkMode
                              ? const Color(0xFF1E293B)
                              : lightColor,
                        ),
                        dateButtonsSettings: PickerDateButtonsSettings(
                          selectedMonthBackgroundColor: softBlue,
                          selectedMonthTextColor: lightColor,
                          unselectedMonthsTextColor: context.isDarkMode
                              ? lightColor
                              : darkColor,
                          currentMonthTextColor: context.isDarkMode
                              ? lightColor
                              : darkColor,
                        ),
                      ),
                    );
                    if (picked != null && picked != selectedMonth) {
                      _updateMonth(context, picked);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: softBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedMonth,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode ? lightColor : deepBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, size: 24),
                  onPressed: () {
                    final nextMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                      1,
                    );
                    if (!nextMonth.isAfter(DateTime.now())) {
                      _updateMonth(context, nextMonth);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ExpenseSummaryProvider>(
              builder: (context, provider, child) {
                final initialBankBalance = provider.initialBankBalance;
                final summaries = provider.summaries;
                double totalProfits = 0;
                double totalExpenses = 0;
                String currency = currencies.first;
                double livingTotal = 0;
                double savingsTotal = 0;
                double charityTotal = 0;

                for (var summary in summaries) {
                  if (summary.currency.isNotEmpty) {
                    currency = summary.currency;
                  }
                  if (summary.isProfit) {
                    totalProfits += summary.totalAmount;
                  } else {
                    totalExpenses += summary.totalAmount;
                    final bucket = getBucketForCategory(summary.type);
                    switch (bucket) {
                      case BudgetBucket.living:
                        livingTotal += summary.totalAmount;
                        break;
                      case BudgetBucket.savings:
                        savingsTotal += summary.totalAmount;
                        break;
                      case BudgetBucket.charity:
                        charityTotal += summary.totalAmount;
                        break;
                    }
                  }
                }

                final double netBalance =
                    initialBankBalance + totalProfits - totalExpenses;
                final double totalPool = (initialBankBalance + totalProfits) > 0
                    ? (initialBankBalance + totalProfits)
                    : (livingTotal + savingsTotal + charityTotal);
                final double targetPerBucket = totalPool > 0
                    ? (totalPool / 3.0)
                    : 1.0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: Column(
                    children: [
                      // HERO NET BALANCE CARD
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'NET BALANCE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.1,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(5),
                                    icon: const Icon(
                                      Icons.edit_note_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    tooltip: 'Edit Initial Bank Balance',
                                    onPressed: () => _showEditBankBalanceDialog(
                                      context,
                                      provider,
                                      currency,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$currency ${formatAmount(netBalance)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: profitColor.withOpacity(
                                              0.25,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_downward_rounded,
                                            size: 16,
                                            color: Colors.greenAccent,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Income',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              '$currency ${formatAmount(totalProfits)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 28,
                                    width: 1,
                                    color: Colors.white24,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: expenseColor.withOpacity(
                                              0.25,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_upward_rounded,
                                            size: 16,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Expenses',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              '$currency ${formatAmount(totalExpenses)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 33-33-33 BUDGET ALLOCATION CARD
                      Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: context.isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: softBlue.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.pie_chart_outline_rounded,
                                    size: 20,
                                    color: softBlue,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '33-33-33 Budget Split Rule',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Target / bucket: $currency ${formatAmount(targetPerBucket)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: context.isDarkMode
                                              ? lightGrayText
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildBucketProgressRow(
                              context,
                              title: 'Living & Utilities (1/3)',
                              actual: livingTotal,
                              target: targetPerBucket,
                              currency: currency,
                              color: const Color(0xFFF59E0B),
                              icon: Icons.home_work_outlined,
                            ),
                            const SizedBox(height: 14),
                            _buildBucketProgressRow(
                              context,
                              title: 'Savings & Investments (1/3)',
                              actual: savingsTotal,
                              target: targetPerBucket,
                              currency: currency,
                              color: softBlue,
                              icon: Icons.savings_outlined,
                            ),
                            const SizedBox(height: 14),
                            _buildBucketProgressRow(
                              context,
                              title: 'Charity & Giving (1/3)',
                              actual: charityTotal,
                              target: targetPerBucket,
                              currency: currency,
                              color: profitColor,
                              icon: Icons.volunteer_activism_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CATEGORY BREAKDOWN LIST
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Category Breakdown',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode ? lightColor : deepBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (summaries.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          child: Text(
                            'No category data available for this month.',
                            style: TextStyle(
                              color: context.isDarkMode
                                  ? lightGrayText
                                  : Colors.grey.shade600,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final summary = summaries[index];
                            final Color color = summary.isProfit
                                ? profitColor
                                : expenseColor;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: context.isDarkMode
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: color.withOpacity(0.12),
                                    child: Icon(
                                      typeIcons[summary.type] ??
                                          (summary.isProfit
                                              ? Icons.trending_up
                                              : Icons.category),
                                      color: color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          summary.type,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${summary.count} transaction${summary.count > 1 ? 's' : ''}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: context.isDarkMode
                                                ? lightGrayText
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${summary.isProfit ? '+' : '-'} $currency ${formatAmount(summary.totalAmount)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _updateMonth(BuildContext context, DateTime newMonth) {
    final startDate = DateTime(newMonth.year, newMonth.month, 1);
    final endDate = DateTime(newMonth.year, newMonth.month + 1, 0);
    final provider = Provider.of<ExpenseSummaryProvider>(
      context,
      listen: false,
    );
    provider.setSelectedMonth(newMonth);
    provider.loadSummaries(startDate, endDate);
  }

  void _showEditBankBalanceDialog(
    BuildContext context,
    ExpenseSummaryProvider provider,
    String currency,
  ) {
    final controller = TextEditingController(
      text: provider.initialBankBalance > 0
          ? provider.initialBankBalance.toStringAsFixed(2)
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDarkMode = ctx.isDarkMode;

        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: softBlue.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: softBlue,
              size: 28,
            ),
          ),
          title: Text(
            'Set Bank Balance',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : deepBlue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your starting bank balance to calculate accurate net cashflow:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? lightGrayText : Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Bank Balance',
                  prefixText: '$currency ',
                  prefixStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? lightColor : deepBlue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      foregroundColor: isDarkMode ? lightGrayText : darkGray,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      backgroundColor: softBlue,
                      foregroundColor: lightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final double? val = double.tryParse(
                        controller.text.trim(),
                      );
                      if (val != null && val >= 0) {
                        provider.setInitialBankBalance(val);
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Save Balance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBucketProgressRow(
    BuildContext context, {
    required String title,
    required double actual,
    required double target,
    required String currency,
    required Color color,
    required IconData icon,
  }) {
    final double ratio = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;
    final double percentage = target > 0 ? (actual / target * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '$currency ${formatAmount(actual)} (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
