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

  List<Expense> get expenses => _expenses;

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
}
