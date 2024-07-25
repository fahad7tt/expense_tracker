import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
import 'package:personal_expense_tracker/domain/usecases/update_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late UpdateExpense updateExpense;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    updateExpense = UpdateExpense(mockExpenseRepository);
  });

  test('should call updateExpense on the repository', () async {
    final expense = Expense(
      id: 1,
      amount: 100.0,
      date: DateTime.now(),
      description: 'Test Expense',
      type: 'Food',
    );

    await updateExpense.call(expense);

    verify(mockExpenseRepository.updateExpense(expense)).called(1);
  });
}