// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import 'package:personal_expense_tracker/domain/entities/fixed_item.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/fixed_item_provider.dart';
import 'package:provider/provider.dart';

class FixedItemsPage extends StatefulWidget {
  const FixedItemsPage({super.key});

  @override
  State<FixedItemsPage> createState() => _FixedItemsPageState();
}

class _FixedItemsPageState extends State<FixedItemsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fixedProvider = Provider.of<FixedItemProvider>(context);
    final isDark = context.isDarkMode;

    final String currency = fixedProvider.fixedItems.isNotEmpty
        ? (fixedProvider.fixedItems.first.currency ?? currencies.first)
        : currencies.first;

    final double totalIncome = fixedProvider.totalFixedIncome;
    final double totalExpenses = fixedProvider.totalFixedExpenses;
    final double netFixed = fixedProvider.netFixedCashflow;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Monthly Items'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded),
            tooltip: 'Apply Fixed Items to Month',
            onPressed: () => _showApplyToMonthDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More Options',
            onSelected: (val) {
              if (val == 'preset') {
                _confirmApplyPreset(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'preset',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 18, color: softBlue),
                    SizedBox(width: 8),
                    Text('Load 24,000 Budget Structure'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // SUMMARY HERO CARD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    right: -14,
                    bottom: -16,
                    child: Icon(
                      Icons.event_repeat_rounded,
                      size: 90,
                      color: softBlue.withValues(alpha: 0.1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
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
                                color: softBlue.withValues(
                                  alpha: isDark ? 0.18 : 0.10,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_repeat_rounded,
                                    size: 13,
                                    color: isDark
                                        ? const Color(0xFF93C5FD)
                                        : const Color(0xFF2563EB),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'FIXED MONTHLY SUMMARY',
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? softBlue.withValues(alpha: 0.15)
                                    : softBlue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: softBlue.withValues(
                                    alpha: isDark ? 0.3 : 0.2,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Target: $currency ${formatAmount(totalIncome > 0 ? totalIncome : 24000.0)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? const Color(0xFF93C5FD)
                                      : softBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$currency ${formatAmount(netFixed)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? (netFixed >= 0
                                      ? Colors.white
                                      : Colors.redAccent)
                                : (netFixed >= 0
                                      ? const Color(0xFF0F172A)
                                      : const Color(0xFFDC2626)),
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : profitColor.withValues(alpha: 0.25),
                                    width: 1.2,
                                  ),
                                  boxShadow: isDark
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: profitColor.withValues(
                                              alpha: 0.08,
                                            ),
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
                                        color: profitColor.withValues(
                                          alpha: isDark ? 0.25 : 0.12,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_downward_rounded,
                                        color: profitColor,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fixed Income',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B),
                                            ),
                                          ),
                                          Text(
                                            '$currency ${formatAmount(totalIncome)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : expenseColor.withValues(alpha: 0.25),
                                    width: 1.2,
                                  ),
                                  boxShadow: isDark
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: expenseColor.withValues(
                                              alpha: 0.08,
                                            ),
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
                                        color: expenseColor.withValues(
                                          alpha: isDark ? 0.25 : 0.12,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_upward_rounded,
                                        color: expenseColor,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fixed Expenses',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B),
                                            ),
                                          ),
                                          Text(
                                            '$currency ${formatAmount(totalExpenses)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
          ),

          // TAB BAR & ADD BUTTON ROW
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(26),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: softBlue,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: softBlue.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                    ? lightGrayText
                    : Colors.grey.shade700,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Incomes (${fixedProvider.fixedIncomes.length})'),
                  Tab(text: 'Expenses (${fixedProvider.fixedExpenses.length})'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // TAB BAR VIEW
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItemList(
                  context,
                  fixedProvider.fixedIncomes,
                  isIncome: true,
                ),
                _buildItemList(
                  context,
                  fixedProvider.fixedExpenses,
                  isIncome: false,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditBottomSheet(context),
        backgroundColor: softBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Fixed Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildItemList(
    BuildContext context,
    List<FixedItem> items, {
    required bool isIncome,
  }) {
    final isDark = context.isDarkMode;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncome
                  ? Icons.account_balance_wallet_outlined
                  : Icons.receipt_long_outlined,
              size: 48,
              color: isDark ? lightGrayText : Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              isIncome ? 'No fixed incomes set' : 'No fixed expenses set',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? lightGrayText : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final String currency = item.currency ?? currencies.first;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (item.isIncome ? profitColor : expenseColor).withOpacity(
                  0.12,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(item.category, item.isIncome),
                color: item.isIncome ? profitColor : expenseColor,
                size: 22,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: item.isActive
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                      color: item.isActive
                          ? null
                          : (isDark ? Colors.grey : Colors.grey.shade500),
                    ),
                  ),
                ),
                Text(
                  '$currency ${formatAmount(item.amount)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: item.isIncome ? profitColor : expenseColor,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: softBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category ?? (item.isIncome ? 'Income' : 'Expense'),
                      style: const TextStyle(
                        fontSize: 11,
                        color: softBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    item.isActive ? 'Active' : 'Paused',
                    style: TextStyle(
                      fontSize: 11,
                      color: item.isActive
                          ? Colors.green
                          : (isDark ? Colors.grey : Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: item.isActive,
                  activeColor: softBlue,
                  onChanged: (val) {
                    Provider.of<FixedItemProvider>(
                      context,
                      listen: false,
                    ).toggleActiveStatus(item.id);
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: isDark ? lightGrayText : Colors.grey.shade600,
                  ),
                  onSelected: (val) {
                    if (val == 'edit') {
                      _showAddEditBottomSheet(context, item: item);
                    } else if (val == 'delete') {
                      _confirmDelete(context, item);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String? category, bool isIncome) {
    if (isIncome) return Icons.work_outline_rounded;
    if (category == null) return Icons.receipt_outlined;

    final lower = category.toLowerCase();
    if (lower.contains('gym') || lower.contains('fitness')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('donation') || lower.contains('charity')) {
      return Icons.volunteer_activism_rounded;
    } else if (lower.contains('rent') || lower.contains('housing')) {
      return Icons.home_rounded;
    } else if (lower.contains('utility') || lower.contains('bill')) {
      return Icons.lightbulb_outline_rounded;
    } else if (lower.contains('subscription') || lower.contains('net')) {
      return Icons.subscriptions_rounded;
    }
    return Icons.shopping_bag_outlined;
  }

  void _showAddEditBottomSheet(BuildContext context, {FixedItem? item}) {
    final titleController = TextEditingController(text: item?.title ?? '');
    final amountController = TextEditingController(
      text: item != null ? item.amount.toString() : '',
    );
    bool isIncome = item?.isIncome ?? false;
    String category = item?.category ?? (isIncome ? 'Salary' : 'General');
    String currency = item?.currency ?? currencies.first;

    final isDark = context.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item == null ? 'Add Fixed Item' : 'Edit Fixed Item',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Type Selector (Income vs Expense)
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Income')),
                            selected: isIncome,
                            selectedColor: profitColor.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isIncome
                                  ? profitColor
                                  : (isDark ? Colors.white : Colors.black),
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (val) {
                              setModalState(() {
                                isIncome = true;
                                category = 'Salary';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Expense')),
                            selected: !isIncome,
                            selectedColor: expenseColor.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: !isIncome
                                  ? expenseColor
                                  : (isDark ? Colors.white : Colors.black),
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (val) {
                              setModalState(() {
                                isIncome = false;
                                category = 'General';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title / Description',
                        hintText: isIncome ? 'e.g. Job Salary' : 'e.g. Gym',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount & Currency
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              hintText: 'e.g. 1200',
                              prefixText: '$currency ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category
                    Builder(
                      builder: (context) {
                        final List<String> categoriesList = isIncome
                            ? groupedProfitCategories.values
                                  .expand((list) => list)
                                  .toList()
                            : groupedCategories.values
                                  .expand((list) => list)
                                  .toList();

                        final String selectedValue =
                            categoriesList.contains(category)
                            ? category
                            : categoriesList.first;

                        return DropdownButtonFormField<String>(
                          initialValue: selectedValue,
                          decoration: InputDecoration(
                            labelText: 'Category / Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: categoriesList.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                category = val;
                              });
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: softBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          final title = titleController.text.trim();
                          final amountText = amountController.text.trim();

                          if (title.isEmpty || amountText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill in both title and amount',
                                ),
                              ),
                            );
                            return;
                          }

                          final amount = double.tryParse(amountText);
                          if (amount == null || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid amount'),
                              ),
                            );
                            return;
                          }

                          final newItem = FixedItem(
                            id:
                                item?.id ??
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            title: title,
                            amount: amount,
                            isIncome: isIncome,
                            category: category,
                            currency: currency,
                            isActive: item?.isActive ?? true,
                          );

                          await Provider.of<FixedItemProvider>(
                            context,
                            listen: false,
                          ).addOrUpdateFixedItem(newItem);

                          Navigator.pop(context);
                        },
                        child: Text(
                          item == null ? 'Add Fixed Item' : 'Save Changes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FixedItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Fixed Item'),
          content: Text('Are you sure you want to delete "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Provider.of<FixedItemProvider>(
                  context,
                  listen: false,
                ).removeFixedItem(item.id);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showApplyToMonthDialog(BuildContext context) {
    DateTime selectedMonth = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM yyyy');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.sync_rounded, color: softBlue),
                  SizedBox(width: 10),
                  Text('Apply Fixed Items'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log all active fixed monthly incomes and expenses as transactions for the chosen month.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: softBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatter.format(selectedMonth),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedMonth,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                selectedMonth = picked;
                              });
                            }
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: softBlue),
                  onPressed: () async {
                    Navigator.pop(context);
                    final count =
                        await Provider.of<FixedItemProvider>(
                          context,
                          listen: false,
                        ).applyFixedItemsToMonth(
                          targetMonth: selectedMonth,
                          expenseProvider: Provider.of<ExpenseProvider>(
                            context,
                            listen: false,
                          ),
                          summaryProvider: Provider.of<ExpenseSummaryProvider>(
                            context,
                            listen: false,
                          ),
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          count > 0
                              ? 'Successfully applied $count fixed items to ${formatter.format(selectedMonth)}!'
                              : 'All active fixed items are already logged for ${formatter.format(selectedMonth)}.',
                        ),
                        backgroundColor: count > 0 ? profitColor : softBlue,
                      ),
                    );
                  },
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmApplyPreset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: softBlue),
              SizedBox(width: 10),
              Text('Load 24k Structure'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This will set your fixed monthly items to your financial structure:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Text(
                  '• Total Salary: 24,000 (Income)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: profitColor,
                  ),
                ),
                SizedBox(height: 6),
                Text('• Living & Utilities: 8,000 (33.33%)'),
                Text('• Investment: 5,000 (20.83%)'),
                Text('• Savings: 3,000 (12.50%)'),
                Text('• Misc Savings: 2,000 (8.33%)'),
                Text('• Donation: 3,000 (12.50%)'),
                Text('• Personal Development: 3,000 (12.50%)'),
                SizedBox(height: 12),
                Text(
                  'Do you want to apply this structure to your fixed items?',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: softBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await Provider.of<FixedItemProvider>(
                  context,
                  listen: false,
                ).applyUserFinancialPreset();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '24,000 Financial structure applied successfully!',
                    ),
                    backgroundColor: profitColor,
                  ),
                );
              },
              child: const Text(
                'Apply Preset',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
