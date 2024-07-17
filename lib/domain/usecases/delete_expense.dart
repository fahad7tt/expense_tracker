import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteExpense(id);
  }
}
