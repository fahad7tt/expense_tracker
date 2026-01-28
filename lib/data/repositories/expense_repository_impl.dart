import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_data_source.dart';
import '../models/expense_model.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';

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

    final Map<String, List<Expense>> grouped = {};
    for (var expense in filteredExpenses) {
      final key =
          '${expense.type ?? 'Other'}|${expense.currency ?? currencies.first}';
      grouped.putIfAbsent(key, () => []).add(expense);
    }

    return grouped.entries.map((entry) {
      final totalAmount =
          entry.value.fold(0.0, (sum, expense) => sum + expense.amount);
      final firstExpense = entry.value.first;
      return ExpenseSummary(
        type: firstExpense.type ?? 'Other',
        totalAmount: totalAmount,
        count: entry.value.length,
        currency: firstExpense.currency ?? currencies.first,
      );
    }).toList();
  }
}
