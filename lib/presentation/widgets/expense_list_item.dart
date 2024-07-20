import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/theme/theme_data.dart';
import '../../core/utils/constants/constants.dart';
import '../../domain/entities/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background container that covers a portion of the card
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: 34.0,
            height: 100.0, 
            color: lightTheme.colorScheme.primary,
            child: const Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded, 
                color: lightColor,
                size: 22.0,
              ),
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 72, top: 12, right: 10, bottom: 12),
          leading: const Icon(
            Icons.wallet,
            color: darkColor,
            size: iconSize,
          ),
          title: Text(
            expense.type!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '₹${expense.amount}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: buttonColor,
                      ),
                ),
              ),
            ],
          ),
          trailing: Text(
            DateFormat.yMMMd().format(expense.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          tileColor: Theme.of(context).cardTheme.color,
        ),
      ],
    );
  }
}
