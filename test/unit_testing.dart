// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:personal_expense_tracker/domain/entities/expense.dart';
// import 'package:personal_expense_tracker/domain/repositories/expense_repository.dart';
// import 'package:personal_expense_tracker/domain/usecases/get_all_expenses.dart';

// class MockExpenseRepository extends Mock implements ExpenseRepository {}

// void main() {
//   GetAllExpenses getAllExpenses;
//   MockExpenseRepository mockRepository;

//   setUp(() {
//     mockRepository = MockExpenseRepository();
//     getAllExpenses = GetAllExpenses(mockRepository);
//   });

//   test('GetAllExpenses Use Case', () async {
//     // Mock data
//     final expenses = [
//       Expense(id: '1', amount: 100.0, date: DateTime.now(), description: 'Test Expense'),
//     ];

//     // Stub the repository method
//     when(mockRepository.getAllExpenses()).thenAnswer((_) async => expenses);

//     // Call the use case
//     final result = await getAllExpenses();

//     // Verify the result
//     expect(result, expenses);
//   });
// }
