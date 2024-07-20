// ignore_for_file: avoid_print
import 'package:hive/hive.dart';
import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getAllExpenses();
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(int id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseModel> expenseBox;

  ExpenseLocalDataSourceImpl(this.expenseBox);

  int _generateId() {
    // Ensure the ID is within the valid range
    return expenseBox.isEmpty ? 1 : (expenseBox.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
     int newId = _generateId();
    print('Adding Expense with ID: $newId');
    await expenseBox.put(newId, expense.copyWith(id: newId));
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    print('********************');
    print('Fetching all expenses');
    return expenseBox.values.toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    print('********************');
    print('Updating Expense with ID: ${expense.id}');
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(int id) async {
    print('********************');
    print('Deleting Expense with ID: $id');
    await expenseBox.delete(id);
  }
}
