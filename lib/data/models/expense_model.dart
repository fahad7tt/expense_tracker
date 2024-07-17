// ignore_for_file: annotate_overrides, overridden_fields

import 'package:hive/hive.dart';
import 'package:personal_expense_tracker/domain/entities/expense.dart';
part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel extends Expense {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
  }) : super(id: id, amount: amount, date: date, description: description);

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      date: expense.date,
      description: expense.description,
    );
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      date: date,
      description: description,
    );
  }
}