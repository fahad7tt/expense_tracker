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

class ExpenseSummaryPage extends StatefulWidget {
  const ExpenseSummaryPage({super.key});

  @override
  State<ExpenseSummaryPage> createState() => _ExpenseSummaryPageState();
}

class _ExpenseSummaryPageState extends State<ExpenseSummaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ExpenseSummaryProvider>(
          context,
          listen: false,
        ).refreshCurrentMonth();
      }
    });
  }

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

                livingTotal =
                    provider.getCategorySpent('living') ?? livingTotal;
                investmentTotal =
                    provider.getCategorySpent('investment') ?? investmentTotal;
                savingsTotal =
                    provider.getCategorySpent('savings') ?? savingsTotal;
                donationTotal =
                    provider.getCategorySpent('donation') ?? donationTotal;
                personalDevTotal =
                    provider.getCategorySpent('personal_dev') ??
                    personalDevTotal;

                totalExpenses =
                    livingTotal +
                    investmentTotal +
                    savingsTotal +
                    donationTotal +
                    personalDevTotal;

                final double netBalance =
                    initialBankBalance + totalProfits - totalExpenses;
                provider.updateMonthlyClosingBalance(selectedMonth, netBalance);
                final double totalMonthlyFunds =
                    initialBankBalance + totalProfits;
                final double baseIncome = totalMonthlyFunds > 0
                    ? totalMonthlyFunds
                    : (netBalance > 0 ? netBalance : 0.0);

                final effectiveTargets = provider.getEffectiveTargets(
                  baseIncome,
                );
                final double livingTarget = effectiveTargets['living'] ?? 0.0;
                final double investmentTarget =
                    effectiveTargets['investment'] ?? 0.0;
                final double savingsTarget = effectiveTargets['savings'] ?? 0.0;
                final double donationTarget =
                    effectiveTargets['donation'] ?? 0.0;
                final double personalDevTarget =
                    effectiveTargets['personal_dev'] ?? 0.0;

                String calcPercent(double target) {
                  if (baseIncome <= 0) return '0%';
                  return '${((target / baseIncome) * 100).toStringAsFixed(1)}%';
                }

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
                                              40,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit_rounded,
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : softBlue,
                                              size: 18,
                                            ),
                                            tooltip: 'Edit Net Balance',
                                            onPressed: () =>
                                                _showEditNetBalanceDialog(
                                                  context,
                                                  provider,
                                                  currency,
                                                  formattedMonth,
                                                  netBalance,
                                                  totalProfits,
                                                  totalExpenses,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    InkWell(
                                      onTap: () => _showEditNetBalanceDialog(
                                        context,
                                        provider,
                                        currency,
                                        formattedMonth,
                                        netBalance,
                                        totalProfits,
                                        totalExpenses,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2.0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
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
                                                          ? const Color(
                                                              0xFF0F172A,
                                                            )
                                                          : const Color(
                                                              0xFFDC2626,
                                                            )),
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Carries over to next month • Tap to edit',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: context.isDarkMode
                                            ? lightGrayText
                                            : Colors.grey.shade600,
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
                      const SizedBox(height: 16),

                      // WALLET RESERVE (END-OF-MONTH SURPLUS VAULT) CARD
                      _buildWalletReserveCard(
                        context,
                        provider,
                        netBalance,
                        currency,
                      ),
                      const SizedBox(height: 20),

                      // FINANCIAL ALLOCATION MODEL (DYNAMIC / FIXED TARGETS) CARD
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
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  7,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF8B5CF6),
                                                          Color(0xFF3B82F6),
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFF8B5CF6,
                                                      ).withValues(alpha: 0.35),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
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
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Financial Allocation Model',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: -0.2,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      '5-Tier Budget Distribution',
                                                      style: TextStyle(
                                                        fontSize: 10.5,
                                                        color:
                                                            context.isDarkMode
                                                            ? lightGrayText
                                                            : Colors
                                                                  .grey
                                                                  .shade600,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B5CF6)
                                                .withValues(
                                                  alpha: context.isDarkMode
                                                      ? 0.2
                                                      : 0.12,
                                                ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: const Color(0xFF8B5CF6)
                                                  .withValues(
                                                    alpha: context.isDarkMode
                                                        ? 0.35
                                                        : 0.25,
                                                  ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.auto_awesome_rounded,
                                                size: 13,
                                                color: Color(0xFF8B5CF6),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                'Target: $currency ${formatAmount(baseIncome)}',
                                                style: TextStyle(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: context.isDarkMode
                                                      ? const Color(0xFFC4B5FD)
                                                      : const Color(0xFF7C3AED),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Living & Utilities',
                                      percentageLabel: calcPercent(
                                        livingTarget,
                                      ),
                                      actual: livingTotal,
                                      target: livingTarget,
                                      isFixed: provider.isCategoryFixed(
                                        'living',
                                      ),
                                      currency: currency,
                                      color: const Color(0xFFF59E0B),
                                      icon: Icons.home_work_rounded,
                                      onTap: () =>
                                          _showEditCategoryTargetDialog(
                                            context,
                                            provider,
                                            categoryKey: 'living',
                                            title: 'Living & Utilities',
                                            currentTarget: livingTarget,
                                            currentSpent: livingTotal,
                                            baseIncome: baseIncome,
                                            currency: currency,
                                            color: const Color(0xFFF59E0B),
                                            icon: Icons.home_work_rounded,
                                          ),
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Investment',
                                      percentageLabel: calcPercent(
                                        investmentTarget,
                                      ),
                                      actual: investmentTotal,
                                      target: investmentTarget,
                                      isFixed: provider.isCategoryFixed(
                                        'investment',
                                      ),
                                      currency: currency,
                                      color: const Color(0xFF8B5CF6),
                                      icon: Icons.show_chart_rounded,
                                      onTap: () =>
                                          _showEditCategoryTargetDialog(
                                            context,
                                            provider,
                                            categoryKey: 'investment',
                                            title: 'Investment',
                                            currentTarget: investmentTarget,
                                            currentSpent: investmentTotal,
                                            baseIncome: baseIncome,
                                            currency: currency,
                                            color: const Color(0xFF8B5CF6),
                                            icon: Icons.show_chart_rounded,
                                          ),
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Savings Reserve',
                                      percentageLabel: calcPercent(
                                        savingsTarget,
                                      ),
                                      actual: savingsTotal,
                                      target: savingsTarget,
                                      isFixed: provider.isCategoryFixed(
                                        'savings',
                                      ),
                                      currency: currency,
                                      color: softBlue,
                                      icon: Icons.savings_rounded,
                                      onTap: () =>
                                          _showEditCategoryTargetDialog(
                                            context,
                                            provider,
                                            categoryKey: 'savings',
                                            title: 'Savings Reserve',
                                            currentTarget: savingsTarget,
                                            currentSpent: savingsTotal,
                                            baseIncome: baseIncome,
                                            currency: currency,
                                            color: softBlue,
                                            icon: Icons.savings_rounded,
                                          ),
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Donation & Giving',
                                      percentageLabel: calcPercent(
                                        donationTarget,
                                      ),
                                      actual: donationTotal,
                                      target: donationTarget,
                                      isFixed: provider.isCategoryFixed(
                                        'donation',
                                      ),
                                      currency: currency,
                                      color: profitColor,
                                      icon: Icons.volunteer_activism_rounded,
                                      onTap: () =>
                                          _showEditCategoryTargetDialog(
                                            context,
                                            provider,
                                            categoryKey: 'donation',
                                            title: 'Donation & Giving',
                                            currentTarget: donationTarget,
                                            currentSpent: donationTotal,
                                            baseIncome: baseIncome,
                                            currency: currency,
                                            color: profitColor,
                                            icon: Icons
                                                .volunteer_activism_rounded,
                                          ),
                                    ),
                                    _buildBucketProgressRow(
                                      context,
                                      title: 'Personal Development',
                                      percentageLabel: calcPercent(
                                        personalDevTarget,
                                      ),
                                      actual: personalDevTotal,
                                      target: personalDevTarget,
                                      isFixed: provider.isCategoryFixed(
                                        'personal_dev',
                                      ),
                                      currency: currency,
                                      color: const Color(0xFFEC4899),
                                      icon: Icons.psychology_rounded,
                                      onTap: () =>
                                          _showEditCategoryTargetDialog(
                                            context,
                                            provider,
                                            categoryKey: 'personal_dev',
                                            title: 'Personal Development',
                                            currentTarget: personalDevTarget,
                                            currentSpent: personalDevTotal,
                                            baseIncome: baseIncome,
                                            currency: currency,
                                            color: const Color(0xFFEC4899),
                                            icon: Icons.psychology_rounded,
                                          ),
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
    final provider = Provider.of<ExpenseSummaryProvider>(
      context,
      listen: false,
    );
    provider.setSelectedMonth(newMonth);
    provider.refreshCurrentMonth();
  }

  void _showEditNetBalanceDialog(
    BuildContext context,
    ExpenseSummaryProvider provider,
    String currency,
    String formattedMonth,
    double currentNetBalance,
    double totalProfits,
    double totalExpenses,
  ) {
    final String initialText = currentNetBalance == 0.0
        ? ''
        : (currentNetBalance % 1 == 0
              ? currentNetBalance.toInt().toString()
              : currentNetBalance.toStringAsFixed(2));
    final controller = TextEditingController(text: initialText);

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDarkMode = ctx.isDarkMode;

        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            final double? enteredVal = double.tryParse(
              controller.text.trim().replaceAll(',', ''),
            );
            final double targetNet = enteredVal ?? currentNetBalance;
            final double calculatedStartingBal =
                targetNet - totalProfits + totalExpenses;

            return AlertDialog(
              backgroundColor: Theme.of(ctx).cardTheme.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  color: isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              title: Text(
                'Edit Net Balance ($formattedMonth)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : deepBlue,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Information banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: softBlue.withValues(
                          alpha: isDarkMode ? 0.16 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: softBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: softBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'The net balance carries over into the next month. You can adjust it here anytime for $formattedMonth. Income and expenses logged this month will continue to adjust it automatically.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDarkMode
                                    ? const Color(0xFF93C5FD)
                                    : const Color(0xFF1D4ED8),
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Target Net Balance text field
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      autofocus: true,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Net Balance Amount',
                        hintText: '0.00',
                        prefixText: '$currency ',
                        prefixStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? lightColor : deepBlue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // LIVE CALCULATION BREAKDOWN PREVIEW
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.04)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'LIVE CALCULATION BREAKDOWN',
                            style: TextStyle(
                              fontSize: 9.5,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w800,
                              color: isDarkMode
                                  ? lightGrayText
                                  : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Target Net Balance:',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? lightColor : deepBlue,
                                ),
                              ),
                              Text(
                                '$currency ${formatAmount(targetNet)}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: targetNet >= 0
                                      ? (isDarkMode ? Colors.white : deepBlue)
                                      : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '+ Month\'s Income:',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: profitColor,
                                ),
                              ),
                              Text(
                                '+ $currency ${formatAmount(totalProfits)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: profitColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '- Month\'s Expenses:',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: expenseColor,
                                ),
                              ),
                              Text(
                                '- $currency ${formatAmount(totalExpenses)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: expenseColor,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Resulting Budget Target:',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? const Color(0xFFC4B5FD)
                                      : const Color(0xFF7C3AED),
                                ),
                              ),
                              Text(
                                '$currency ${formatAmount((targetNet + totalExpenses).clamp(0.0, double.infinity))}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? const Color(0xFFC4B5FD)
                                      : const Color(0xFF7C3AED),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Effective Starting Balance:',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDarkMode
                                      ? lightGrayText
                                      : Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '$currency ${formatAmount(calculatedStartingBal)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? lightGrayText : darkGray,
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
                          foregroundColor: isDarkMode
                              ? lightGrayText
                              : darkGray,
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
                        onPressed: () async {
                          final double? val = double.tryParse(
                            controller.text.trim().replaceAll(',', ''),
                          );
                          if (val != null) {
                            await provider.setNetBalanceForMonth(
                              val,
                              month: provider.selectedMonth,
                              totalProfits: totalProfits,
                              totalExpenses: totalExpenses,
                            );
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Net balance for $formattedMonth set to $currency ${formatAmount(val)}.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            }
                          }
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
      },
    );
  }

  void _showEditCategoryTargetDialog(
    BuildContext context,
    ExpenseSummaryProvider provider, {
    required String categoryKey,
    required String title,
    required double currentTarget,
    required double currentSpent,
    required double baseIncome,
    required String currency,
    required Color color,
    required IconData icon,
  }) {
    final bool initialIsFixed = provider.isCategoryFixed(categoryKey);
    bool isFixed = initialIsFixed;
    final spentController = TextEditingController(
      text: currentSpent > 0
          ? (currentSpent % 1 == 0
                ? currentSpent.toInt().toString()
                : currentSpent.toStringAsFixed(2))
          : (currentSpent == 0 ? '0' : ''),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDarkMode = ctx.isDarkMode;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final double previewPercent = baseIncome > 0
                ? (currentTarget / baseIncome * 100)
                : 0.0;

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
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              title: Text(
                'Edit $title Budget',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : deepBlue,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget target is automatically allocated from your Net Balance ($currency ${formatAmount(baseIncome)}). You can adjust your spent amount or toggle Fixed vs Dynamic mode below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDarkMode
                            ? lightGrayText
                            : Colors.grey.shade600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fixed vs Dynamic Mode Selector
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                isFixed = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isFixed
                                    ? color.withValues(
                                        alpha: isDarkMode ? 0.22 : 0.12,
                                      )
                                    : (isDarkMode
                                          ? Colors.white.withValues(alpha: 0.04)
                                          : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isFixed
                                      ? color
                                      : (isDarkMode
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFE2E8F0)),
                                  width: isFixed ? 1.5 : 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    size: 16,
                                    color: isFixed
                                        ? color
                                        : (isDarkMode
                                              ? lightGrayText
                                              : Colors.grey),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '🔒 Fixed Budget',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isFixed
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isFixed
                                          ? color
                                          : (isDarkMode
                                                ? lightColor
                                                : deepBlue),
                                    ),
                                  ),
                                  Text(
                                    'Locks amount',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: isDarkMode
                                          ? lightGrayText
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                isFixed = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: !isFixed
                                    ? color.withValues(
                                        alpha: isDarkMode ? 0.22 : 0.12,
                                      )
                                    : (isDarkMode
                                          ? Colors.white.withValues(alpha: 0.04)
                                          : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !isFixed
                                      ? color
                                      : (isDarkMode
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFE2E8F0)),
                                  width: !isFixed ? 1.5 : 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                    color: !isFixed
                                        ? color
                                        : (isDarkMode
                                              ? lightGrayText
                                              : Colors.grey),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '⚡ Dynamic %',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: !isFixed
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: !isFixed
                                          ? color
                                          : (isDarkMode
                                                ? lightColor
                                                : deepBlue),
                                    ),
                                  ),
                                  Text(
                                    'Scales w/ income',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: isDarkMode
                                          ? lightGrayText
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Amount Spent Input
                    TextField(
                      controller: spentController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Amount Spent',
                        prefixText: '$currency ',
                        prefixStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? lightColor : deepBlue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Target Budget Display (Uneditable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(
                          alpha: isDarkMode ? 0.14 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target Budget (Auto-Allocated)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? lightGrayText
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isFixed
                                    ? '🔒 Fixed target amount'
                                    : '⚡ Dynamic (~${previewPercent.toStringAsFixed(1)}% of Net Balance)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$currency ${formatAmount(currentTarget)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDarkMode ? Colors.white : deepBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          foregroundColor: isDarkMode
                              ? lightGrayText
                              : darkGray,
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
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final cleanedSpent = spentController.text
                              .trim()
                              .replaceAll(',', '');
                          final double? spentVal = double.tryParse(
                            cleanedSpent,
                          );
                          if (spentVal != null && spentVal >= 0) {
                            await provider.setCategorySpent(
                              categoryKey,
                              spentVal,
                            );
                          }

                          if (isFixed != initialIsFixed) {
                            await provider.toggleCategoryFixedMode(
                              categoryKey,
                              currentTarget: currentTarget,
                            );
                          }
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text(
                          'Save Changes',
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
      },
    );
  }

  // ==============================================================
  // WALLET RESERVE (SURPLUS VAULT) CARD & DIALOGS
  // ==============================================================

  Widget _buildWalletReserveCard(
    BuildContext context,
    ExpenseSummaryProvider provider,
    double netBalance,
    String currency,
  ) {
    final bool isDarkMode = context.isDarkMode;
    final double walletBalance = provider.walletBalance;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF10B981).withValues(alpha: 0.28)
              : const Color(0xFFA7F3D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF10B981,
            ).withValues(alpha: isDarkMode ? 0.05 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                Icons.savings_rounded,
                size: 85,
                color: const Color(0xFF10B981).withValues(alpha: 0.07),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: isDarkMode ? 0.20 : 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.savings_rounded,
                              size: 13,
                              color: Color(0xFF10B981),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'WALLET RESERVE (VAULT)',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.1,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(5),
                        icon: Icon(
                          Icons.history_rounded,
                          color: isDarkMode
                              ? Colors.white70
                              : const Color(0xFF047857),
                          size: 20,
                        ),
                        tooltip: 'Reserve History',
                        onPressed: () => _showWalletHistoryDialog(
                          context,
                          provider,
                          currency,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          '$currency ${formatAmount(walletBalance)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF065F46),
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vault Reserve',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    netBalance > 0
                        ? '✨ Save your extra net balance ($currency ${formatAmount(netBalance)}) here at month-end so it doesn\'t blindly accumulate. Withdraw it into upcoming months whenever you want.'
                        : 'Store leftover monthly surplus here, then withdraw it into next month\'s active net balance as needed.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF475569),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // SAVE SURPLUS BUTTON
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_downward_rounded,
                            size: 16,
                          ),
                          label: const Text(
                            'Save Surplus',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => _showDepositToWalletDialog(
                            context,
                            provider,
                            netBalance,
                            currency,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // WITHDRAW BUTTON
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            foregroundColor: walletBalance > 0
                                ? (isDarkMode
                                      ? const Color(0xFF6EE7B7)
                                      : const Color(0xFF047857))
                                : Colors.grey,
                            side: BorderSide(
                              color: walletBalance > 0
                                  ? const Color(0xFF10B981)
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_upward_rounded,
                            size: 16,
                          ),
                          label: const Text(
                            'Withdraw',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: walletBalance > 0
                              ? () => _showWithdrawFromWalletDialog(
                                  context,
                                  provider,
                                  currency,
                                )
                              : null,
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
    );
  }

  void _showDepositToWalletDialog(
    BuildContext context,
    ExpenseSummaryProvider provider,
    double currentNetBalance,
    String currency,
  ) {
    final TextEditingController controller = TextEditingController(
      text: currentNetBalance > 0
          ? (currentNetBalance % 1 == 0
                ? currentNetBalance.toInt().toString()
                : currentNetBalance.toStringAsFixed(2))
          : '',
    );
    final TextEditingController noteController = TextEditingController(
      text: 'Month-end surplus saved',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDark = ctx.isDarkMode;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final double? entered = double.tryParse(
              controller.text.trim().replaceAll(',', ''),
            );
            return AlertDialog(
              backgroundColor: Theme.of(ctx).cardTheme.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Save Surplus to Vault',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? lightColor : deepBlue,
                          ),
                        ),
                        Text(
                          'Deducts from net balance and stores in vault',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? lightGrayText
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Net Balance:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? lightGrayText
                                  : Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '$currency ${formatAmount(currentNetBalance)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (currentNetBalance > 0) ...[
                      Row(
                        children: [
                          _buildQuickAmountChip(
                            label: 'All Surplus',
                            onTap: () {
                              controller.text = currentNetBalance % 1 == 0
                                  ? currentNetBalance.toInt().toString()
                                  : currentNetBalance.toStringAsFixed(2);
                              setDialogState(() {});
                            },
                            isDark: isDark,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickAmountChip(
                            label: '50%',
                            onTap: () {
                              final half = currentNetBalance * 0.5;
                              controller.text = half % 1 == 0
                                  ? half.toInt().toString()
                                  : half.toStringAsFixed(2);
                              setDialogState(() {});
                            },
                            isDark: isDark,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickAmountChip(
                            label: '25%',
                            onTap: () {
                              final quarter = currentNetBalance * 0.25;
                              controller.text = quarter % 1 == 0
                                  ? quarter.toInt().toString()
                                  : quarter.toStringAsFixed(2);
                              setDialogState(() {});
                            },
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: true,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Deposit Amount',
                        prefixText: '$currency ',
                        prefixStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? lightColor : deepBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Note (Optional)',
                        hintText: 'e.g. Month-end surplus',
                      ),
                    ),
                    if (entered != null && entered > 0) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Remaining Net Balance: $currency ${formatAmount((currentNetBalance - entered).clamp(0.0, double.infinity))}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? lightGrayText : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
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
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          foregroundColor: isDark ? lightGrayText : darkGray,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final amt = double.tryParse(
                            controller.text.trim().replaceAll(',', ''),
                          );
                          if (amt != null && amt > 0) {
                            await provider.depositToWallet(
                              amt,
                              note: noteController.text.trim().isNotEmpty
                                  ? noteController.text.trim()
                                  : null,
                            );
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Deposited $currency ${formatAmount(amt)} into Wallet Reserve!',
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Save to Vault',
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
      },
    );
  }

  void _showWithdrawFromWalletDialog(
    BuildContext context,
    ExpenseSummaryProvider provider,
    String currency,
  ) {
    final double walletBalance = provider.walletBalance;
    final TextEditingController controller = TextEditingController(
      text: walletBalance % 1 == 0
          ? walletBalance.toInt().toString()
          : walletBalance.toStringAsFixed(2),
    );
    final TextEditingController noteController = TextEditingController(
      text: 'Withdrawn into upcoming month',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDark = ctx.isDarkMode;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final double? entered = double.tryParse(
              controller.text.trim().replaceAll(',', ''),
            );
            return AlertDialog(
              backgroundColor: Theme.of(ctx).cardTheme.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: softBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: softBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Withdraw to Net Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? lightColor : deepBlue,
                          ),
                        ),
                        Text(
                          'Transfers vault funds into active monthly balance',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? lightGrayText
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: softBlue.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available in Vault:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? lightGrayText
                                  : Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '$currency ${formatAmount(walletBalance)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: softBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildQuickAmountChip(
                          label: 'All Funds',
                          onTap: () {
                            controller.text = walletBalance % 1 == 0
                                ? walletBalance.toInt().toString()
                                : walletBalance.toStringAsFixed(2);
                            setDialogState(() {});
                          },
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        _buildQuickAmountChip(
                          label: '50%',
                          onTap: () {
                            final half = walletBalance * 0.5;
                            controller.text = half % 1 == 0
                                ? half.toInt().toString()
                                : half.toStringAsFixed(2);
                            setDialogState(() {});
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: true,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Withdraw Amount',
                        prefixText: '$currency ',
                        prefixStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? lightColor : deepBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Note (Optional)',
                        hintText: 'e.g. Rollover into new month',
                      ),
                    ),
                    if (entered != null && entered > walletBalance) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Amount exceeds available vault reserve!',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
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
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          foregroundColor: isDark ? lightGrayText : darkGray,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          backgroundColor: softBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final amt = double.tryParse(
                            controller.text.trim().replaceAll(',', ''),
                          );
                          if (amt != null && amt > 0 && amt <= walletBalance) {
                            await provider.withdrawFromWallet(
                              amt,
                              note: noteController.text.trim().isNotEmpty
                                  ? noteController.text.trim()
                                  : null,
                            );
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Transferred $currency ${formatAmount(amt)} into Net Balance!',
                                  ),
                                  backgroundColor: softBlue,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Withdraw',
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
      },
    );
  }

  void _showWalletHistoryDialog(
    BuildContext context,
    ExpenseSummaryProvider provider,
    String currency,
  ) {
    final bool isDark = context.isDarkMode;
    final history = provider.walletHistory;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          title: Row(
            children: [
              const Icon(
                Icons.history_rounded,
                size: 22,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 10),
              Text(
                'Reserve History',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? lightColor : deepBlue,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: history.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No deposits or withdrawals yet.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? lightGrayText : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  )
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 350),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: history.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: isDark ? Colors.white12 : Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final item = history[index];
                        final bool isDeposit = item['type'] == 'deposit';
                        final double amount =
                            (item['amount'] as num?)?.toDouble() ?? 0.0;
                        final String note = item['note']?.toString() ?? '';
                        final String dateStr = item['date']?.toString() ?? '';
                        DateTime? dt = DateTime.tryParse(dateStr);
                        final String formattedDate = dt != null
                            ? '${dt.day}/${dt.month}/${dt.year}'
                            : '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      (isDeposit
                                              ? const Color(0xFF10B981)
                                              : softBlue)
                                          .withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isDeposit
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  size: 16,
                                  color: isDeposit
                                      ? const Color(0xFF10B981)
                                      : softBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.isNotEmpty
                                          ? note
                                          : (isDeposit
                                                ? 'Deposit'
                                                : 'Withdrawal'),
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : deepBlue,
                                      ),
                                    ),
                                    if (formattedDate.isNotEmpty)
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark
                                              ? lightGrayText
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isDeposit ? '+' : '-'}$currency ${formatAmount(amount)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDeposit
                                      ? const Color(0xFF10B981)
                                      : softBlue,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // QUICK AMOUNT CHIP
  // ==============================================================

  Widget _buildQuickAmountChip({
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? lightColor : deepBlue,
          ),
        ),
      ),
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
    bool isFixed = false,
    VoidCallback? onTap,
  }) {
    final bool isDarkMode = context.isDarkMode;
    final double ratio = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;
    final double percentage = target > 0 ? (actual / target * 100) : 0.0;
    final bool isOverBudget = actual > target && target > 0;
    final double remaining = target - actual;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: color.withValues(
                          alpha: isDarkMode ? 0.22 : 0.15,
                        ),
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isFixed
                                          ? Icons.lock_rounded
                                          : Icons.auto_awesome_rounded,
                                      size: 9,
                                      color: color,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      isFixed
                                          ? 'Fixed $percentageLabel'
                                          : percentageLabel,
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                      ),
                                    ),
                                  ],
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
                          'Target: $currency ${formatAmount(target)}',
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
                          height: 4,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: color.withValues(
                              alpha: isDarkMode ? 0.15 : 0.10,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 5,
                          width: constraints.maxWidth * ratio,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color.withValues(alpha: 0.70), color],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
