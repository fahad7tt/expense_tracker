import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/data/datasources/expense_data_source.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/entities/expense_summary.dart';
import '../data sources/expense_data_source_test.dart';

class MockExpenseLocalDataSource extends Mock implements ExpenseLocalDataSource {}

void main() {
  late ExpenseRepositoryImpl repository;
  late MockExpenseLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockExpenseLocalDataSource();
    repository = ExpenseRepositoryImpl(mockLocalDataSource);
  });

  group('ExpenseRepositoryImpl', () {
    final expense = Expense(
      id: 1,
      amount: 100.0,
      date: DateTime.now(),
      description: 'Test Expense',
      type: 'Food',
    );
    final expenseModel = ExpenseModel.fromEntity(expense);

    test('should add an expense', () async {
      when(mockLocalDataSource.addExpense(expenseModel)).thenAnswer((_) async {});

      await repository.addExpense(expense);

      verify(mockLocalDataSource.addExpense(expenseModel)).called(1);
    });

    test('should get all expenses', () async {
      when(mockLocalDataSource.getAllExpenses()).thenAnswer((_) async => [expenseModel]);

      final result = await repository.getAllExpenses();

      expect(result, [expense]);
    });

    test('should update an expense', () async {
      when(mockLocalDataSource.updateExpense(expenseModel)).thenAnswer((_) async {});

      await repository.updateExpense(expense);

      verify(mockLocalDataSource.updateExpense(expenseModel)).called(1);
    });

    test('should delete an expense', () async {
      when(mockLocalDataSource.deleteExpense(1)).thenAnswer((_) async {});

      await repository.deleteExpense(1);

      verify(mockLocalDataSource.deleteExpense(1)).called(1);
    });

    test('should get expense summary by type', () async {
      final expenses = [
        Expense(id: 1, amount: 50.0, date: DateTime(2024, 7, 1), description: 'Test1', type: 'Food'),
        Expense(id: 2, amount: 30.0, date: DateTime(2024, 7, 2), description: 'Test2', type: 'Food'),
        Expense(id: 3, amount: 20.0, date: DateTime(2024, 7, 3), description: 'Test3', type: 'Drink'),
      ];
      final expenseModels = expenses.map((e) => ExpenseModel.fromEntity(e)).toList();

      when(mockLocalDataSource.getAllExpenses()).thenAnswer((_) async => expenseModels);

      final startDate = DateTime(2024, 7, 1);
      final endDate = DateTime(2024, 7, 31);
      final summaries = await repository.getExpenseSummaryByType(startDate, endDate);

      expect(summaries, [
        ExpenseSummary(type: 'Food', totalAmount: 80.0, count: 2),
        ExpenseSummary(type: 'Drink', totalAmount: 20.0, count: 1),
      ]);
    });
  });
}