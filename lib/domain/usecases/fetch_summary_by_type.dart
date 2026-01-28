import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/entities/expense_summary.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';

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

  Future<List<ExpenseSummary>> execute(
      DateTime startDate, DateTime endDate) async {
    final expenses = await repository.getAllExpenses();
    return _calculateSummaries(expenses, startDate, endDate);
  }

  List<ExpenseSummary> _calculateSummaries(
      List<Expense> expenses, DateTime startDate, DateTime endDate) {
    final filteredExpenses = expenses
        .where((expense) =>
            expense.date.isAtOrAfter(startDate) &&
            expense.date.isAtOrBefore(endDate))
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
