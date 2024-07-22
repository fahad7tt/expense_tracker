import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
import 'package:personal_expense_tracker/domain/usecases/get_all_expenses.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late GetAllExpenses getAllExpenses;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    getAllExpenses = GetAllExpenses(mockExpenseRepository);
  });

  test('should return all expenses from the repository', () async {
    final expenses = [
      Expense(id: 1, amount: 50.0, date: DateTime.now(), description: 'Test1'),
      Expense(id: 2, amount: 30.0, date: DateTime.now(), description: 'Test2'),
    ];

    when(mockExpenseRepository.getAllExpenses()).thenAnswer((_) async => expenses);

    final result = await getAllExpenses.call();

    expect(result, expenses);
  });
}
