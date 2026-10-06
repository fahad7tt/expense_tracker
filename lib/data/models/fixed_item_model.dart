import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/fixed_item.dart';
part 'fixed_item_model.g.dart';

@HiveType(typeId: 2)
class FixedItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final bool isIncome;

  @HiveField(4)
  final String? category;

  @HiveField(5)
  final String? currency;

  @HiveField(6)
  final bool? isActive;

  FixedItemModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    this.category,
    this.currency,
    this.isActive,
  });

  factory FixedItemModel.fromEntity(FixedItem item) {
    return FixedItemModel(
      id: item.id,
      title: item.title,
      amount: item.amount,
      isIncome: item.isIncome,
      category: item.category,
      currency: item.currency,
      isActive: item.isActive,
    );
  }

  FixedItem toEntity() {
    return FixedItem(
      id: id,
      title: title,
      amount: amount,
      isIncome: isIncome,
      category: category,
      currency: currency,
      isActive: isActive ?? true,
    );
  }

  FixedItemModel copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isIncome,
    String? category,
    String? currency,
    bool? isActive,
  }) {
    return FixedItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
    );
  }
}
