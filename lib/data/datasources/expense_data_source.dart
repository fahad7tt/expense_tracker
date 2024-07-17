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

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    return expenseBox.values.toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await expenseBox.delete(id);
  }
}
