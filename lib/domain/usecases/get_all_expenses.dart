import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';

class GetAllExpenses {
  final ExpenseRepository repository;

  GetAllExpenses(this.repository);

  Future<List<Expense>> call() async {
    return await repository.getAllExpenses();
  }
}
