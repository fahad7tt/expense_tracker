// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/theme/theme_data.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../domain/entities/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Slidable.of(context)?.close();
          },
          onHorizontalDragStart: (_) {},
          behavior: HitTestBehavior.translucent,
          child: ListTile(
            contentPadding:
                const EdgeInsets.only(left: 48, top: 12, right: 10, bottom: 12),
            leading: CircleAvatar(
              backgroundColor: lightTheme.colorScheme.primary.withOpacity(0.12),
              child: Icon(
                typeIcons[expense.type] ?? Icons.category,
                color: lightTheme.colorScheme.primary,
                size: normalIcon,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    expense.type ?? 'Other',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMd().format(expense.date),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 13),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${expense.currency ?? currencies.first} ${formatAmount(expense.amount)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: buttonColor,
                        ),
                  ),
                ),
              ),
            ),
            tileColor: Theme.of(context).cardTheme.color,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              final slidable = Slidable.of(context);
              if (slidable != null) {
                if (slidable.actionPaneType.value == ActionPaneType.none) {
                  slidable.openStartActionPane();
                } else {
                  slidable.close();
                }
              }
            },
            child: Container(
              width: 34.0,
              height: 104.0,
              color: lightTheme.colorScheme.primary,
              child: const Center(
                child: Icon(Icons.arrow_forward_ios_rounded,
                    color: lightColor, size: forwardIcon),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
