import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/entities/expense_summary.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';

extension DateTimeComparison on DateTime {
  bool isAtOrAfter(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  bool isAtOrBefore(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }
}

class FetchExpenseSummaryByType {
  final ExpenseRepository repository;

  FetchExpenseSummaryByType(this.repository);

  Future<List<ExpenseSummary>> execute(DateTime startDate, DateTime endDate) async {
    final expenses = await repository.getAllExpenses();
    return _calculateSummaries(expenses, startDate, endDate);
  }

  List<ExpenseSummary> _calculateSummaries(List<Expense> expenses, DateTime startDate, DateTime endDate) {
    final filteredExpenses = expenses
        .where((expense) => expense.date.isAtOrAfter(startDate) && expense.date.isAtOrBefore(endDate))
        .toList();

    final Map<String, List<Expense>> groupedByType = {};
    for (var expense in filteredExpenses) {
      groupedByType.putIfAbsent(expense.type!, () => []).add(expense);
    }

    return groupedByType.entries.map((entry) {
      final totalAmount = entry.value.fold(0.0, (sum, expense) => sum + expense.amount);
      return ExpenseSummary(
        type: entry.key,
        totalAmount: totalAmount,
        count: entry.value.length,
      );
    }).toList();
  }
}
