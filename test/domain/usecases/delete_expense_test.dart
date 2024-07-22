import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
import 'package:personal_expense_tracker/domain/usecases/delete_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late DeleteExpense deleteExpense;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    deleteExpense = DeleteExpense(mockExpenseRepository);
  });

  test('should call deleteExpense on the repository', () async {
    const id = 1;

    await deleteExpense.call(id);

    verify(mockExpenseRepository.deleteExpense(id)).called(1);
  });
}
