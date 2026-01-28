import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
import 'package:personal_expense_tracker/domain/usecases/fetch_summary_by_type.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late FetchExpenseSummaryByType fetchExpenseSummaryByType;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    fetchExpenseSummaryByType =
        FetchExpenseSummaryByType(mockExpenseRepository);
  });

  test('should return correct summaries by type', () async {
    final expenses = [
      Expense(
          id: 1,
          amount: 50.0,
          date: DateTime(2024, 7, 1),
          description: 'Test1',
          type: 'Food',
          currency: '₹'),
      Expense(
          id: 2,
          amount: 30.0,
          date: DateTime(2024, 7, 2),
          description: 'Test2',
          type: 'Food',
          currency: '₹'),
      Expense(
          id: 3,
          amount: 20.0,
          date: DateTime(2024, 7, 3),
          description: 'Test3',
          type: 'Drink',
          currency: '₹'),
    ];

    when(mockExpenseRepository.getAllExpenses())
        .thenAnswer((_) async => expenses);

    final startDate = DateTime(2024, 7, 1);
    final endDate = DateTime(2024, 7, 31);
    final summaries =
        await fetchExpenseSummaryByType.execute(startDate, endDate);

    expect(
        summaries.any((s) =>
            s.type == 'Food' && s.totalAmount == 80.0 && s.currency == '₹'),
        true);
    expect(
        summaries.any((s) =>
            s.type == 'Drink' && s.totalAmount == 20.0 && s.currency == '₹'),
        true);
  });
}
