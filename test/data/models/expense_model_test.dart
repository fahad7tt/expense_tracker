import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';

void main() {
  group('ExpenseModel', () {
    final expense = Expense(
      id: 1,
      amount: 100.0,
      date: DateTime.now(),
      description: 'Test Expense',
      type: 'Food',
    );

    test('should convert from entity to model', () {
      final model = ExpenseModel.fromEntity(expense);

      expect(model.id, expense.id);
      expect(model.amount, expense.amount);
      expect(model.date, expense.date);
      expect(model.description, expense.description);
      expect(model.type, expense.type);
    });

    test('should convert from model to entity', () {
      final model = ExpenseModel.fromEntity(expense);
      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.amount, model.amount);
      expect(entity.date, model.date);
      expect(entity.description, model.description);
      expect(entity.type, model.type);
    });

    test('should copy with new values', () {
      final model = ExpenseModel(
        id: 1,
        amount: 100.0,
        date: DateTime.now(),
        description: 'Test Expense',
        type: 'Food',
      );

      final newModel = model.copyWith(amount: 150.0, description: 'Updated Expense');

      expect(newModel.id, model.id);
      expect(newModel.amount, 150.0);
      expect(newModel.date, model.date);
      expect(newModel.description, 'Updated Expense');
      expect(newModel.type, model.type);
    });
  });
}
