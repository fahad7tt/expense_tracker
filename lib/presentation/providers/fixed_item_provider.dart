import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/fixed_item.dart';
import '../../domain/usecases/manage_fixed_items.dart';
import 'expense_provider.dart';
import 'expense_summary_provider.dart';

class FixedItemProvider with ChangeNotifier {
  final GetFixedItems getFixedItems;
  final SaveFixedItem saveFixedItem;
  final DeleteFixedItem deleteFixedItem;

  FixedItemProvider({
    required this.getFixedItems,
    required this.saveFixedItem,
    required this.deleteFixedItem,
  }) {
    loadFixedItems();
  }

  List<FixedItem> _fixedItems = [];
  bool _isLoading = false;

  List<FixedItem> get fixedItems => _fixedItems;
  bool get isLoading => _isLoading;

  List<FixedItem> get fixedIncomes =>
      _fixedItems.where((item) => item.isIncome).toList();

  List<FixedItem> get fixedExpenses =>
      _fixedItems.where((item) => !item.isIncome).toList();

  double get totalFixedIncome => fixedIncomes
      .where((item) => item.isActive)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalFixedExpenses => fixedExpenses
      .where((item) => item.isActive)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get netFixedCashflow => totalFixedIncome - totalFixedExpenses;

  List<FixedItem> get userFinancialStructurePreset => [
        FixedItem(
          id: 'fixed_total_salary',
          title: 'Total Salary',
          amount: 24000.0,
          isIncome: true,
          category: 'Salary',
          currency: currencies.first,
          isActive: true,
        ),
        FixedItem(
          id: 'fixed_living_utilities',
          title: 'Living & Utilities',
          amount: 8000.0,
          isIncome: false,
          category: 'Living & Utilities',
          currency: currencies.first,
          isActive: true,
        ),
        FixedItem(
          id: 'fixed_investment',
          title: 'Investment',
          amount: 5000.0,
          isIncome: false,
          category: 'Investment',
          currency: currencies.first,
          isActive: true,
        ),
        FixedItem(
          id: 'fixed_savings',
          title: 'Savings',
          amount: 3000.0,
          isIncome: false,
          category: 'Savings',
          currency: currencies.first,
          isActive: true,
        ),
        FixedItem(
          id: 'fixed_misc_savings',
          title: 'Misc Savings',
          amount: 2000.0,
          isIncome: false,
          category: 'Savings',
          currency: currencies.first,
          isActive: true,
        ),
        FixedItem(
          id: 'fixed_donation',
          title: 'Donation',
          amount: 3000.0,
          isIncome: false,
          category: 'Donation',
          currency: currencies.first,
          isActive: true,
        ),
        FixedItem(
          id: 'fixed_personal_development',
          title: 'Personal Development',
          amount: 3000.0,
          isIncome: false,
          category: 'Personal Development',
          currency: currencies.first,
          isActive: true,
        ),
      ];

  Future<void> loadFixedItems() async {
    _isLoading = true;
    notifyListeners();

    _fixedItems = await getFixedItems.execute();

    if (_fixedItems.isEmpty) {
      // Pre-seed default fixed items matching user's financial structure
      final defaultItems = userFinancialStructurePreset;

      for (var item in defaultItems) {
        await saveFixedItem.execute(item);
      }
      _fixedItems = defaultItems;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Replaces active fixed items with the user's custom 24,000 financial structure preset
  Future<void> applyUserFinancialPreset() async {
    _isLoading = true;
    notifyListeners();

    // Clear existing items
    for (var item in List<FixedItem>.from(_fixedItems)) {
      await deleteFixedItem.execute(item.id);
    }

    final preset = userFinancialStructurePreset;
    for (var item in preset) {
      await saveFixedItem.execute(item);
    }

    _fixedItems = preset;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrUpdateFixedItem(FixedItem item) async {
    await saveFixedItem.execute(item);
    await loadFixedItems();
  }

  Future<void> removeFixedItem(String id) async {
    await deleteFixedItem.execute(id);
    await loadFixedItems();
  }

  Future<void> toggleActiveStatus(String id) async {
    final index = _fixedItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final updated = _fixedItems[index].copyWith(
        isActive: !_fixedItems[index].isActive,
      );
      await saveFixedItem.execute(updated);
      await loadFixedItems();
    }
  }

  /// Applies active fixed income & expense items to a specified month as logged transactions.
  Future<int> applyFixedItemsToMonth({
    required DateTime targetMonth,
    required ExpenseProvider expenseProvider,
    required ExpenseSummaryProvider summaryProvider,
  }) async {
    final activeItems = _fixedItems.where((item) => item.isActive).toList();
    if (activeItems.isEmpty) return 0;

    await expenseProvider.fetchAllExpenses();
    final existingExpenses = expenseProvider.expenses;

    int addedCount = 0;
    final DateTime targetDate = DateTime(targetMonth.year, targetMonth.month, 1);

    for (var fixed in activeItems) {
      // Check if already logged for this month with matching description tag
      final fixedTag = '[Fixed] ${fixed.title}';
      final bool alreadyExists = existingExpenses.any((e) {
        return e.date.year == targetMonth.year &&
            e.date.month == targetMonth.month &&
            (e.description.toLowerCase() == fixedTag.toLowerCase() ||
                e.description.toLowerCase() == fixed.title.toLowerCase());
      });

      if (!alreadyExists) {
        final newExpense = Expense(
          id: 0, // Auto-generated by Data Source
          amount: fixed.amount,
          date: targetDate,
          description: fixedTag,
          type: fixed.category ?? (fixed.isIncome ? 'Salary' : 'General'),
          currency: fixed.currency ?? currencies.first,
          isProfit: fixed.isIncome,
        );

        await expenseProvider.addNewExpense(newExpense);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      final startDate = DateTime(targetMonth.year, targetMonth.month, 1);
      final endDate = DateTime(targetMonth.year, targetMonth.month + 1, 0);
      await summaryProvider.loadSummaries(startDate, endDate);
    }

    return addedCount;
  }
}
