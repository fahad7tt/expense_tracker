import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_summary.dart';
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

  Future<List<ExpenseSummary>> getExpenseSummaryByType(
      DateTime startDate, DateTime endDate) async {
    final expenses = await getAllExpenses();
    final summaries = _calculateSummaries(expenses, startDate, endDate);
    return summaries;
  }

  List<ExpenseSummary> _calculateSummaries(
      List<Expense> expenses, DateTime startDate, DateTime endDate) {
    final filteredExpenses = expenses
        .where((expense) =>
            expense.date.isAfter(startDate) && expense.date.isBefore(endDate))
        .toList();

    final Map<String, List<Expense>> groupedByType = {};
    for (var expense in filteredExpenses) {
      groupedByType.putIfAbsent(expense.type ?? 'Other', () => []).add(expense);
    }

    return groupedByType.entries.map((entry) {
      final totalAmount =
          entry.value.fold(0.0, (sum, expense) => sum + expense.amount);
      return ExpenseSummary(
        type: entry.key,
        totalAmount: totalAmount,
        count: entry.value.length,
      );
    }).toList();
  }
}
