import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<void> addExpense(Expense expense) async {
    return localDataSource.addExpense(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    return (await localDataSource.getAllExpenses())
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    return localDataSource.updateExpense(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<void> deleteExpense(int id) async {
    return localDataSource.deleteExpense(id);
  }
}
