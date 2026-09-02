import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/data/datasources/expense_data_source.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/data/repositories/expense_repository_impl.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';

class MockExpenseLocalDataSource extends Mock
    implements ExpenseLocalDataSource {
  @override
  Future<void> addExpense(ExpenseModel? expense) =>
      super.noSuchMethod(Invocation.method(#addExpense, [expense]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as Future<void>;

  @override
  Future<List<ExpenseModel>> getAllExpenses() =>
      super.noSuchMethod(Invocation.method(#getAllExpenses, []),
              returnValue: Future<List<ExpenseModel>>.value([]),
              returnValueForMissingStub: Future<List<ExpenseModel>>.value([]))
          as Future<List<ExpenseModel>>;

  @override
  Future<void> updateExpense(ExpenseModel? expense) =>
      super.noSuchMethod(Invocation.method(#updateExpense, [expense]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as Future<void>;

  @override
  Future<void> deleteExpense(int? id) =>
      super.noSuchMethod(Invocation.method(#deleteExpense, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as Future<void>;
}

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
      when(mockLocalDataSource.addExpense(any))
          .thenAnswer((_) async {});

      await repository.addExpense(expense);

      verify(mockLocalDataSource.addExpense(any)).called(1);
    });

    test('should get all expenses', () async {
      when(mockLocalDataSource.getAllExpenses())
          .thenAnswer((_) async => [expenseModel]);

      final result = await repository.getAllExpenses();

      expect(result.length, 1);
      expect(result.first.id, expense.id);
      expect(result.first.amount, expense.amount);
    });

    test('should update an expense', () async {
      when(mockLocalDataSource.updateExpense(any))
          .thenAnswer((_) async {});

      await repository.updateExpense(expense);

      verify(mockLocalDataSource.updateExpense(any)).called(1);
    });

    test('should delete an expense', () async {
      when(mockLocalDataSource.deleteExpense(1)).thenAnswer((_) async {});

      await repository.deleteExpense(1);

      verify(mockLocalDataSource.deleteExpense(1)).called(1);
    });

    test('should get expense summary by type', () async {
      final expenses = [
        Expense(
            id: 1,
            amount: 50.0,
            date: DateTime(2024, 7, 2),
            description: 'Test1',
            type: 'Food',
            currency: '₹'),
        Expense(
            id: 2,
            amount: 30.0,
            date: DateTime(2024, 7, 3),
            description: 'Test2',
            type: 'Food',
            currency: '₹'),
        Expense(
            id: 3,
            amount: 20.0,
            date: DateTime(2024, 7, 4),
            description: 'Test3',
            type: 'Drink',
            currency: '₹'),
      ];
      final expenseModels =
          expenses.map((e) => ExpenseModel.fromEntity(e)).toList();

      when(mockLocalDataSource.getAllExpenses())
          .thenAnswer((_) async => expenseModels);

      final startDate = DateTime(2024, 7, 1);
      final endDate = DateTime(2024, 7, 31);
      final summaries =
          await repository.getExpenseSummaryByType(startDate, endDate);

      expect(
          summaries.any((s) =>
              s.type == 'Food' && s.totalAmount == 80.0 && s.currency == '₹'),
          true);
      expect(
          summaries.any((s) =>
              s.type == 'Drink' && s.totalAmount == 20.0 && s.currency == '₹'),
          true);
    });
  });
}
