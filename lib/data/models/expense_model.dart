import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/expense.dart';
part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String? type;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    this.type,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      date: expense.date,
      description: expense.description,
      type: expense.type,
    );
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      date: date,
      description: description,
      type: type,
    );
  }

  ExpenseModel copyWith({
    int? id,
    double? amount,
    DateTime? date,
    String? description,
    String? type,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }
}