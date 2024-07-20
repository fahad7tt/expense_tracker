import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/get_all_expenses.dart';
import '../../domain/usecases/update_expense.dart';
import '../../domain/usecases/delete_expense.dart';

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
  List<String> _customTypes = [];
  bool _isAscending = true;
  DateTime? _startDate;
  DateTime? _endDate;

  List<Expense> get expenses => _expenses;
  List<String> get customTypes => _customTypes;

  Future<void> fetchAllExpenses() async {
    _expenses = await getAllExpenses();
    notifyListeners();
  }

  Future<void> addNewExpense(Expense expense) async {
    await addExpense(expense);
    fetchAllExpenses();
  }

  Future<void> modifyExpense(Expense expense) async {
    await updateExpense(expense);
    fetchAllExpenses();
  }

  Future<void> removeExpense(int id) async {
    await deleteExpense(id);
    fetchAllExpenses();
  }

  void addCustomType(String type) {
    if (!_customTypes.contains(type)) {
      _customTypes.add(type);
      notifyListeners();
    }
  }

  void sortExpensesByDate() {
    _isAscending = !_isAscending;
    _expenses.sort((a, b) => _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    notifyListeners();
  }

  void filterExpensesByDate(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    _expenses = _expenses.where((expense) => expense.date.isAfter(startDate) && expense.date.isBefore(endDate)).toList();
    notifyListeners();
  }

  void clearFilters() {
    _startDate = null;
    _endDate = null;
    fetchAllExpenses();
  }

  bool get isAscending => _isAscending;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
}
