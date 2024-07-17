import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';

class UpdateExpense {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  Future<void> call(Expense expense) async {
    return await repository.updateExpense(expense);
  }
}
