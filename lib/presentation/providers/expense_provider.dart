import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/get_all_expenses.dart';
import '../../domain/usecases/update_expense.dart';
import '../../domain/usecases/delete_expense.dart';

import 'package:personal_expense_tracker/core/utils/helpers/monthly_cycle_helper.dart';

/// Manages state for expenses list, sorting, filtering, and custom categories.
/// Acts as the bridge between UI pages and domain Use Cases.
class ExpenseProvider with ChangeNotifier {
  final AddExpense addExpense;
  final GetAllExpenses getAllExpenses;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;

  ExpenseProvider({
    required this.addExpense,
    required this.getAllExpenses,
    required this.updateExpense,
    required this.deleteExpense,
  });

  List<Expense> _expenses = [];
  final List<String> _customTypes = [];
  bool _isAscending = true;
  DateTime? _startDate;
  DateTime? _endDate;
  int _cycleStartDay = MonthlyCycleHelper.defaultCycleStartDay;
  VoidCallback? onExpensesChanged;

  List<Expense> get expenses => _expenses;
  List<String> get customTypes => _customTypes;
  bool get isAscending => _isAscending;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  int get cycleStartDay => _cycleStartDay;

  /// Returns only the expenses falling within the active monthly cycle.
  List<Expense> get currentCycleExpenses {
    final now = DateTime.now();
    return _expenses
        .where((expense) => MonthlyCycleHelper.isInCycle(
              expense.date,
              startDay: _cycleStartDay,
              referenceDate: now,
            ))
        .toList();
  }

  /// Loads saved cycle start day from storage.
  Future<void> loadCycleSettings() async {
    _cycleStartDay = await MonthlyCycleHelper.getSavedCycleStartDay();
    notifyListeners();
  }

  /// Updates the cycle start day and persists to storage.
  Future<void> setCycleStartDay(int day) async {
    _cycleStartDay = day;
    await MonthlyCycleHelper.saveCycleStartDay(day);
    notifyListeners();
  }

  /// Loads all expenses from the database via [GetAllExpenses] use case.
  Future<void> fetchAllExpenses() async {
    _cycleStartDay = await MonthlyCycleHelper.getSavedCycleStartDay();
    _expenses = await getAllExpenses();
    notifyListeners();
  }

  /// Adds a new expense record and refreshes the list.
  Future<void> addNewExpense(Expense expense) async {
    await addExpense(expense);
    await fetchAllExpenses();
    onExpensesChanged?.call();
  }

  /// Updates an existing expense record.
  Future<void> modifyExpense(Expense expense) async {
    await updateExpense(expense);
    await fetchAllExpenses();
    onExpensesChanged?.call();
  }

  /// Deletes an expense record by ID.
  Future<void> removeExpense(int id) async {
    await deleteExpense(id);
    await fetchAllExpenses();
    onExpensesChanged?.call();
  }

  /// Adds a custom expense category type if not present.
  void addCustomType(String type) {
    if (!_customTypes.contains(type)) {
      _customTypes.add(type);
      notifyListeners();
    }
  }

  /// Toggles date sorting order (Ascending / Descending).
  void sortExpensesByDate() {
    _isAscending = !_isAscending;
    _expenses.sort((a, b) =>
        _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    notifyListeners();
  }

  /// Filters the expense list within a date range.
  void filterExpensesByDate(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    _expenses = _expenses
        .where((expense) =>
            expense.date.isAfter(startDate) && expense.date.isBefore(endDate))
        .toList();
    notifyListeners();
  }

  /// Resets date filters and reloads all expenses.
  void clearFilters() {
    _startDate = null;
    _endDate = null;
    fetchAllExpenses();
  }
}
