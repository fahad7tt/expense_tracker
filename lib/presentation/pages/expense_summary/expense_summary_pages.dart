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
  } else if (lower.contains('donation') ||
      lower.contains('gift') ||
      lower.contains('personal development') ||
      lower.contains('education')) {
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
                double investmentTotal = 0;
                double savingsTotal = 0;
                double donationTotal = 0;
                double personalDevTotal = 0;

                for (var summary in summaries) {
                  if (summary.currency.isNotEmpty) {
                    currency = summary.currency;
                  }
                  if (summary.isProfit) {
                    totalProfits += summary.totalAmount;
                  } else {
                    totalExpenses += summary.totalAmount;
                    final lower = summary.type.toLowerCase();
                    if (lower.contains('investment')) {
                      investmentTotal += summary.totalAmount;
                    } else if (lower.contains('savings') ||
                        lower.contains('insurance') ||
                        lower.contains('tax')) {
                      savingsTotal += summary.totalAmount;
                    } else if (lower.contains('donation') ||
                        lower.contains('charity') ||
                        lower.contains('gift')) {
                      donationTotal += summary.totalAmount;
                    } else if (lower.contains('personal development') ||
                        lower.contains('education') ||
                        lower.contains('book')) {
                      personalDevTotal += summary.totalAmount;
                    } else {
                      livingTotal += summary.totalAmount;
                    }
                  }
                }

                final double netBalance =
                    initialBankBalance + totalProfits - totalExpenses;
                final double baseIncome = totalProfits > 0
                    ? totalProfits
                    : 24000.0;

                final double livingTarget = baseIncome * (8000.0 / 24000.0);
                final double investmentTarget = baseIncome * (5000.0 / 24000.0);
                final double savingsTarget = baseIncome * (5000.0 / 24000.0);
                final double donationTarget = baseIncome * (3000.0 / 24000.0);
                final double personalDevTarget =
                    baseIncome * (3000.0 / 24000.0);

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: Column(
                    children: [
                      // HERO NET BALANCE CARD
                      Container(
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: context.isDarkMode
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
                                right: -14,
                                bottom: -16,
                                child: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 90,
                                  color: softBlue.withValues(alpha: 0.1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: softBlue.withValues(
                                              alpha: context.isDarkMode
                                                  ? 0.18
                                                  : 0.10,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons
                                                    .account_balance_wallet_rounded,
                                                size: 13,
                                                color: context.isDarkMode
                                                    ? const Color(0xFF93C5FD)
                                                    : const Color(0xFF2563EB),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'NET BALANCE',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  letterSpacing: 1.1,
                                                  color: context.isDarkMode
                                                      ? const Color(0xFF93C5FD)
                                                      : const Color(0xFF2563EB),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: context.isDarkMode
                                                ? Colors.white.withValues(
                                                    alpha: 0.1,
                                                  )
                                                : softBlue.withValues(
                                                    alpha: 0.1,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(5),
                                            icon: Icon(
                                              Icons.edit_note_rounded,
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : softBlue,
                                              size: 18,
                                            ),
                                            tooltip:
                                                'Edit Initial Bank Balance',
                                            onPressed: () =>
                                                _showEditBankBalanceDialog(
                                                  context,
                                                  provider,
                                                  currency,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '$currency ${formatAmount(netBalance)}',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: context.isDarkMode
                                            ? (netBalance >= 0
                                                  ? Colors.white
                                                  : Colors.redAccent)
                                            : (netBalance >= 0
                                                  ? const Color(0xFF0F172A)
                                                  : const Color(0xFFDC2626)),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode
                                            ? Colors.white.withValues(
                                                alpha: 0.06,
                                              )
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: context.isDarkMode
                                              ? Colors.white.withValues(
                                                  alpha: 0.06,
                                                )
                                              : const Color(0xFFE2E8F0),
                                          width: 1.2,
                                        ),
                                        boxShadow: context.isDarkMode
                                            ? null
                                            : [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.03),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: profitColor
                                                        .withValues(
                                                          alpha:
                                                              context.isDarkMode
                                                              ? 0.25
                                                              : 0.15,
                                                        ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .arrow_downward_rounded,
                                                    size: 16,
                                                    color: profitColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Income',
                                                      style: TextStyle(
                                                        fontSize: 10.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            context.isDarkMode
                                                            ? const Color(
                                                                0xFF94A3B8,
                                                              )
                                                            : const Color(
                                                                0xFF64748B,
                                                              ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$currency ${formatAmount(totalProfits)}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            context.isDarkMode
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF0F172A,
                                                              ),
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
                                            color: context.isDarkMode
                                                ? Colors.white24
                                                : const Color(0xFFE2E8F0),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: expenseColor
                                                        .withValues(
                                                          alpha:
                                                              context.isDarkMode
                                                              ? 0.25
                                                              : 0.15,
                                                        ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_upward_rounded,
                                                    size: 16,
                                                    color: expenseColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Expenses',
                                                      style: TextStyle(
                                                        fontSize: 10.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            context.isDarkMode
                                                            ? const Color(
                                                                0xFF94A3B8,
                                                              )
                                                            : const Color(
                                                                0xFF64748B,
                                                              ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$currency ${formatAmount(totalExpenses)}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            context.isDarkMode
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF0F172A,
                                                              ),
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // FINANCIAL ALLOCATION MODEL (24,000 TARGET) CARD
                      Container(
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: context.isDarkMode
                                ? const Color(0xFF8B5CF6).withValues(alpha: 0.3)
                                : const Color(0xFFDDD6FE),
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
                                top: -12,
                                child: Icon(
                                  Icons.pie_chart_rounded,
                                  size: 110,
                                  color: const Color(0xFF8B5CF6).withValues(
                                    alpha: context.isDarkMode ? 0.08 : 0.06,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF8B5CF6),
                                                    Color(0xFF3B82F6),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF8B5CF6,
                                                    ).withValues(alpha: 0.35),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.auto_graph_rounded,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Financial Allocation Model',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                                Text(
                                                  '5-Tier Budget Distribution',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: context.isDarkMode
                                                        ? lightGrayText
                                                        : Colors.grey.shade600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 9,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B5CF6)
                                                .withValues(
                                                  alpha: context.isDarkMode
                                                      ? 0.2
                                                      : 0.12,
                                                ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFF8B5CF6)
                                                  .withValues(
                                                    alpha: context.isDarkMode
                                                        ? 0.35
                                                        : 0.25,
                                                  ),
                                            ),
                                          ),
                                          child: Text(
                                            'Target: $currency ${formatAmount(baseIncome)}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: context.isDarkMode
                                                  ? const Color(0xFFC4B5FD)
                                                  : const Color(0xFF7C3AED),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // Multi-color Segmented Target Distribution Preview Bar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 333,
                                            child: Container(
                                              height: 6,
                                              color: const Color(0xFFF59E0B),
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 208,
                                            child: Container(
                                              height: 6,
                                              color: const Color(0xFF8B5CF6),
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 208,
                                            child: Container(
                                              height: 6,
                                              color: softBlue,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 125,
                                            child: Container(
                                              height: 6,
                                              color: profitColor,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 125,
                                            child: Container(
                                              height: 6,
                                              color: const Color(0xFFEC4899),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Living & Utilities',
                                      percentageLabel: '33.3%',
                                      actual: livingTotal,
                                      target: livingTarget,
                                      currency: currency,
                                      color: const Color(0xFFF59E0B),
                                      icon: Icons.home_work_rounded,
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Investment',
                                      percentageLabel: '20.8%',
                                      actual: investmentTotal,
                                      target: investmentTarget,
                                      currency: currency,
                                      color: const Color(0xFF8B5CF6),
                                      icon: Icons.show_chart_rounded,
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Savings Reserve',
                                      percentageLabel: '20.8%',
                                      actual: savingsTotal,
                                      target: savingsTarget,
                                      currency: currency,
                                      color: softBlue,
                                      icon: Icons.savings_rounded,
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Donation & Giving',
                                      percentageLabel: '12.5%',
                                      actual: donationTotal,
                                      target: donationTarget,
                                      currency: currency,
                                      color: profitColor,
                                      icon: Icons.volunteer_activism_rounded,
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Personal Development',
                                      percentageLabel: '12.5%',
                                      actual: personalDevTotal,
                                      target: personalDevTarget,
                                      currency: currency,
                                      color: const Color(0xFFEC4899),
                                      icon: Icons.psychology_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // FIXED MONTHLY RULE IMPACT CARD
                      // Consumer<FixedItemProvider>(
                      //   builder: (context, fixedProvider, child) {
                      //     final fixedIncomes = fixedProvider.fixedIncomes
                      //         .where((i) => i.isActive)
                      //         .toList();
                      //     final fixedExpenses = fixedProvider.fixedExpenses
                      //         .where((i) => i.isActive)
                      //         .toList();
                      //     final totalFixedInc = fixedProvider.totalFixedIncome;
                      //     final totalFixedExp =
                      //         fixedProvider.totalFixedExpenses;

                      //     return Container(
                      //       margin: const EdgeInsets.only(top: 16.0),
                      //       padding: const EdgeInsets.all(18.0),
                      //       decoration: BoxDecoration(
                      //         color: Theme.of(context).cardTheme.color,
                      //         borderRadius: BorderRadius.circular(20),
                      //         border: Border.all(
                      //           color: context.isDarkMode
                      //               ? const Color(0xFF334155).withOpacity(0.5)
                      //               : const Color(0xFFE2E8F0),
                      //         ),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: context.isDarkMode
                      //                 ? Colors.black.withOpacity(0.15)
                      //                 : Colors.black.withOpacity(0.03),
                      //             blurRadius: 12,
                      //             offset: const Offset(0, 3),
                      //           ),
                      //         ],
                      //       ),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   Container(
                      //                     padding: const EdgeInsets.all(6),
                      //                     decoration: BoxDecoration(
                      //                       color: softBlue.withOpacity(0.12),
                      //                       borderRadius: BorderRadius.circular(
                      //                         8,
                      //                       ),
                      //                     ),
                      //                     child: const Icon(
                      //                       Icons.repeat_rounded,
                      //                       size: 18,
                      //                       color: softBlue,
                      //                     ),
                      //                   ),
                      //                   const SizedBox(width: 8),
                      //                   const Text(
                      //                     'Fixed Monthly Rule Impact',
                      //                     style: TextStyle(
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.bold,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //               InkWell(
                      //                 onTap: () => Navigator.pushNamed(
                      //                   context,
                      //                   '/fixedItems',
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(12),
                      //                 child: const Padding(
                      //                   padding: EdgeInsets.symmetric(
                      //                     horizontal: 8,
                      //                     vertical: 4,
                      //                   ),
                      //                   child: Row(
                      //                     children: [
                      //                       Text(
                      //                         'Manage',
                      //                         style: TextStyle(
                      //                           fontSize: 12,
                      //                           color: softBlue,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //                       SizedBox(width: 2),
                      //                       Icon(
                      //                         Icons.chevron_right_rounded,
                      //                         size: 16,
                      //                         color: softBlue,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           const SizedBox(height: 12),
                      //           Row(
                      //             children: [
                      //               Expanded(
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       'Fixed Income',
                      //                       style: TextStyle(
                      //                         fontSize: 11,
                      //                         color: context.isDarkMode
                      //                             ? lightGrayText
                      //                             : Colors.grey.shade600,
                      //                       ),
                      //                     ),
                      //                     const SizedBox(height: 2),
                      //                     Text(
                      //                       '$currency ${formatAmount(totalFixedInc)}',
                      //                       style: const TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         color: profitColor,
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       '${fixedIncomes.length} active items',
                      //                       style: TextStyle(
                      //                         fontSize: 10,
                      //                         color: context.isDarkMode
                      //                             ? lightGrayText
                      //                             : Colors.grey.shade500,
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               Container(
                      //                 height: 30,
                      //                 width: 1,
                      //                 color: Colors.grey.withOpacity(0.2),
                      //               ),
                      //               Expanded(
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.only(
                      //                     left: 12.0,
                      //                   ),
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       Text(
                      //                         'Fixed Expenses',
                      //                         style: TextStyle(
                      //                           fontSize: 11,
                      //                           color: context.isDarkMode
                      //                               ? lightGrayText
                      //                               : Colors.grey.shade600,
                      //                         ),
                      //                       ),
                      //                       const SizedBox(height: 2),
                      //                       Text(
                      //                         '$currency ${formatAmount(totalFixedExp)}',
                      //                         style: const TextStyle(
                      //                           fontSize: 14,
                      //                           fontWeight: FontWeight.bold,
                      //                           color: expenseColor,
                      //                         ),
                      //                       ),
                      //                       Text(
                      //                         '${fixedExpenses.length} active items',
                      //                         style: TextStyle(
                      //                           fontSize: 10,
                      //                           color: context.isDarkMode
                      //                               ? lightGrayText
                      //                               : Colors.grey.shade500,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           if (fixedExpenses.isNotEmpty) ...[
                      //             const SizedBox(height: 12),
                      //             Divider(
                      //               height: 1,
                      //               color: context.isDarkMode
                      //                   ? Colors.white10
                      //                   : Colors.black12,
                      //             ),
                      //             const SizedBox(height: 10),
                      //             Wrap(
                      //               spacing: 6,
                      //               runSpacing: 6,
                      //               children: fixedExpenses.map((exp) {
                      //                 final bucket = getBucketForCategory(
                      //                   exp.category,
                      //                 );
                      //                 String bucketLabel = 'Living';
                      //                 if (bucket == BudgetBucket.savings) {
                      //                   bucketLabel = 'Savings';
                      //                 }
                      //                 if (bucket == BudgetBucket.charity) {
                      //                   bucketLabel = 'Charity';
                      //                 }

                      //                 return Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                     horizontal: 8,
                      //                     vertical: 4,
                      //                   ),
                      //                   decoration: BoxDecoration(
                      //                     color: context.isDarkMode
                      //                         ? const Color(0xFF1E293B)
                      //                         : const Color(0xFFF1F5F9),
                      //                     borderRadius: BorderRadius.circular(
                      //                       8,
                      //                     ),
                      //                     border: Border.all(
                      //                       color: context.isDarkMode
                      //                           ? const Color(0xFF334155)
                      //                           : const Color(0xFFE2E8F0),
                      //                     ),
                      //                   ),
                      //                   child: Text(
                      //                     '${exp.title}: $currency ${formatAmount(exp.amount)} → $bucketLabel 33%',
                      //                     style: TextStyle(
                      //                       fontSize: 10,
                      //                       fontWeight: FontWeight.w500,
                      //                       color: context.isDarkMode
                      //                           ? lightColor
                      //                           : darkColor,
                      //                     ),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ],
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      const SizedBox(height: 10),
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
    required String percentageLabel,
    required double actual,
    required double target,
    required String currency,
    required Color color,
    required IconData icon,
  }) {
    final bool isDarkMode = context.isDarkMode;
    final double ratio = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;
    final double percentage = target > 0 ? (actual / target * 100) : 0.0;
    final bool isOverBudget = actual > target && target > 0;
    final double remaining = target - actual;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.04)
            : color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: isDarkMode ? 0.25 : 0.18),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDarkMode ? 0.22 : 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(
                              alpha: isDarkMode ? 0.2 : 0.12,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            percentageLabel,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isOverBudget
                          ? '+$currency ${formatAmount(actual - target)} over target (${percentage.toStringAsFixed(0)}%)'
                          : '$currency ${formatAmount(remaining)} left (${percentage.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: isOverBudget
                            ? (isDarkMode
                                  ? Colors.redAccent
                                  : const Color(0xFFDC2626))
                            : (isDarkMode
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currency ${formatAmount(actual)}',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isOverBudget
                          ? (isDarkMode
                                ? Colors.redAccent
                                : const Color(0xFFDC2626))
                          : (isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A)),
                    ),
                  ),
                  Text(
                    'of $currency ${formatAmount(target)}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Custom Gradient Progress Bar
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 7,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDarkMode ? 0.15 : 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 7,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isOverBudget
                            ? [color, const Color(0xFFEF4444)]
                            : [color.withValues(alpha: 0.7), color],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isOverBudget ? const Color(0xFFEF4444) : color)
                                  .withValues(alpha: 0.35),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
