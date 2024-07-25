import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
import 'package:personal_expense_tracker/domain/usecases/add_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late AddExpense addExpense;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    addExpense = AddExpense(mockExpenseRepository);
  });

  test('should call addExpense on the repository', () async {
    final expense = Expense(
      id: 1,
      amount: 100.0,
      date: DateTime.now(),
      description: 'Test Expense',
      type: 'Food',
    );

    // Configuring the mock to return a completed future
    when(mockExpenseRepository.addExpense(expense)).thenAnswer((_) async {});

    await addExpense.call(expense);

    verify(mockExpenseRepository.addExpense(expense)).called(1);
  });
}
