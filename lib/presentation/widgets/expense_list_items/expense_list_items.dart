// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../domain/entities/expense.dart';

class ExpenseListItem extends StatefulWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  State<ExpenseListItem> createState() => _ExpenseListItemState();
}

class _ExpenseListItemState extends State<ExpenseListItem> {
  bool _isOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to slidable state changes
    final slidable = Slidable.of(context);
    if (slidable != null) {
      slidable.actionPaneType.addListener(() {
        final isCurrentlyOpen =
            slidable.actionPaneType.value != ActionPaneType.none;
        if (_isOpen != isCurrentlyOpen) {
          setState(() {
            _isOpen = isCurrentlyOpen;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.isDarkMode;

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
              backgroundColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.12),
              child: Icon(
                typeIcons[widget.expense.type] ?? Icons.category,
                color: isDarkMode
                    ? lightColor
                    : Theme.of(context).colorScheme.primary,
                size: normalIcon,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.expense.type ?? 'Other',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMd().format(widget.expense.date),
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
                    '${widget.expense.currency ?? currencies.first} ${formatAmount(widget.expense.amount)}',
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
                  setState(() {
                    _isOpen = true;
                  });
                } else {
                  slidable.close();
                  setState(() {
                    _isOpen = false;
                  });
                }
              }
            },
            child: Container(
              width: 32,
              height: 104,
              color: isDarkMode
                  ? lightColor
                  : Theme.of(context).colorScheme.primary,
              child: Center(
                child: Icon(
                    _isOpen
                        ? Icons.arrow_back_ios_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: isDarkMode ? deepBlue : lightColor,
                    size: forwardIcon),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
