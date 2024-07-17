import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import '../../core/usecases/usecase.dart';

class AddExpense implements UseCase<void, Expense> {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  @override
  Future<void> call(Expense expense) async {
    return repository.addExpense(expense);
  }
}
