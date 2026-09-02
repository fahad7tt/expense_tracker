// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import '../../../core/utils/theme/button_theme.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedMonth =
        Provider.of<ExpenseSummaryProvider>(context).selectedMonth ??
            DateTime.now();

    // Format month and year
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final String formattedMonth = formatter.format(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 14, bottom: 4),
            child: ElevatedButton.icon(
              icon: Icon(Icons.calendar_today,
                  size: normalIcon,
                  color: context.isDarkMode ? darkColor : deepBlue),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedMonth,
                    style: ButtonThemes.elevatedButtonTextStyle.copyWith(
                        fontSize: dateIcon,
                        color: context.isDarkMode ? darkColor : deepBlue),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(Icons.arrow_drop_down,
                      size: normalIcon,
                      color: context.isDarkMode ? darkColor : deepBlue),
                ],
              ),
              onPressed: () async {
                final DateTime? picked = await showMonthPicker(
                  context: context,
                  initialDate: selectedMonth,
                  firstDate: DateTime(DateTime.now().year - 5, 1),
                  lastDate: DateTime(DateTime.now().year, DateTime.now().month),
                  monthPickerDialogSettings: MonthPickerDialogSettings(
                    headerSettings: PickerHeaderSettings(
                      headerBackgroundColor:
                          context.isDarkMode ? darkGray : deepBlue,
                      headerCurrentPageTextStyle:
                          const TextStyle(color: lightColor),
                    ),
                    dialogSettings: const PickerDialogSettings(
                      dialogBackgroundColor: lightColor,
                    ),
                    dateButtonsSettings: const PickerDateButtonsSettings(
                      selectedMonthBackgroundColor: buttonColor,
                      selectedMonthTextColor: lightColor,
                      unselectedMonthsTextColor: darkColor,
                      currentMonthTextColor: darkColor,
                    ),
                    actionBarSettings: const PickerActionBarSettings(
                      confirmWidget:
                          Text('OK', style: TextStyle(color: Colors.green)),
                      cancelWidget:
                          Text('Cancel', style: TextStyle(color: errorColor)),
                    ),
                  ),
                );

                if (picked != null && picked != selectedMonth) {
                  final DateTime startDate =
                      DateTime(picked.year, picked.month, 1);
                  final DateTime endDate =
                      DateTime(picked.year, picked.month + 1, 0);
                  Provider.of<ExpenseSummaryProvider>(context, listen: false)
                      .setSelectedMonth(picked);
                  Provider.of<ExpenseSummaryProvider>(context, listen: false)
                      .loadSummaries(startDate, endDate);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                backgroundColor: buttonColor,
                foregroundColor: lightColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
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
                  }

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

                final double netBalance = initialBankBalance + totalProfits - totalExpenses;
                final double totalPool = (initialBankBalance + totalProfits) > 0
                    ? (initialBankBalance + totalProfits)
                    : (livingTotal + savingsTotal + charityTotal);
                final double targetPerBucket = totalPool > 0 ? (totalPool / 3.0) : 1.0;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Net Balance',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$currency ${formatAmount(netBalance)}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: netBalance >= 0
                                            ? profitColor
                                            : expenseColor,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  tooltip: 'Set Total Bank Balance',
                                  icon: const Icon(
                                    Icons.edit_note,
                                    size: 28,
                                    color: buttonColor,
                                  ),
                                  onPressed: () => _showEditBankBalanceDialog(
                                      context, provider, currency),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Initial Bank Balance:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '$currency ${formatAmount(initialBankBalance)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0x222E7D32),
                                        child: Icon(Icons.arrow_downward,
                                            size: 16, color: profitColor),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Profit',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            '$currency ${formatAmount(totalProfits)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: profitColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 30,
                                    width: 1,
                                    color: Theme.of(context).dividerColor),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0x22D32F2F),
                                        child: Icon(Icons.arrow_upward,
                                            size: 16, color: expenseColor),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Expense',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            '$currency ${formatAmount(totalExpenses)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: expenseColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 33-33-33 Budget Split Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.pie_chart_outline, size: 20, color: selectedIconColor),
                                SizedBox(width: 8),
                                Text(
                                  '33-33-33 Budget Allocation (1/3 Rule)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Target per bucket: $currency ${formatAmount(targetPerBucket)} (33.3%)',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 14),

                            // Bucket 1: Living Expenses
                            _buildBucketProgressRow(
                              context,
                              title: 'Living & Misc Expenses (1/3)',
                              actual: livingTotal,
                              target: targetPerBucket,
                              currency: currency,
                              color: buttonColor,
                              icon: Icons.home_work_outlined,
                            ),
                            const SizedBox(height: 12),

                            // Bucket 2: Savings & Investment
                            _buildBucketProgressRow(
                              context,
                              title: 'Savings & Investment (1/3)',
                              actual: savingsTotal,
                              target: targetPerBucket,
                              currency: currency,
                              color: selectedIconColor,
                              icon: Icons.savings_outlined,
                            ),
                            const SizedBox(height: 12),

                            // Bucket 3: Charity & Beneficial
                            _buildBucketProgressRow(
                              context,
                              title: 'Charity & Beneficial (1/3)',
                              actual: charityTotal,
                              target: targetPerBucket,
                              currency: currency,
                              color: profitColor,
                              icon: Icons.volunteer_activism_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (summaries.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text('No summaries available for this period.'),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final summary = summaries[index];
                            final Color color = summary.isProfit
                                ? profitColor
                                : buttonColor;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 14.0),
                              child: Card(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12.0),
                                  leading: CircleAvatar(
                                    backgroundColor: color.withOpacity(0.12),
                                    child: Icon(
                                      typeIcons[summary.type] ??
                                          (summary.isProfit
                                              ? Icons.trending_up
                                              : Icons.category),
                                      color: color,
                                      size: normalIcon,
                                    ),
                                  ),
                                  title: Text(
                                    summary.type,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 18),
                                  ),
                                  subtitle: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 35),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          '${summary.isProfit ? '+' : '-'} ${summary.currency} ${formatAmount(summary.totalAmount)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    'Entries: ${summary.count}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _showEditBankBalanceDialog(
      BuildContext context, ExpenseSummaryProvider provider, String currency) {
    final controller = TextEditingController(
      text: provider.initialBankBalance > 0
          ? provider.initialBankBalance.toStringAsFixed(2)
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Set Initial Bank Balance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your total/initial bank balance to calculate accurate net balance across income and expenses:',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Bank Balance ($currency)',
                  prefixIcon: const Icon(Icons.account_balance),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double? val = double.tryParse(controller.text.trim());
                if (val != null && val >= 0) {
                  provider.setInitialBankBalance(val);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
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
                    fontSize: 12,
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
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}


