import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../domain/entities/expense.dart';
import '../expense_detail_bottom_sheet/expense_detail_bottom_sheet.dart';

/// A simple, clean list item widget representing an individual expense or income item.
class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.isDarkMode;
    final bool isProfit = expense.isProfit;
    final Color itemColor = getCategoryThemeColor(expense.type, isProfit);

    return InkWell(
      onTap: () {
        Slidable.of(context)?.close();
        showExpenseDetailBottomSheet(context, expense);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Category Icon Avatar
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: isDarkMode ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                typeIcons[expense.type] ??
                    (isProfit
                        ? Icons.trending_up_rounded
                        : Icons.category_rounded),
                color: itemColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Category Title, Date & Notes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          expense.type ?? 'General',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? lightColor : deepBlue,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM').format(expense.date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? lightGrayText
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.description.isNotEmpty
                        ? expense.description
                        : 'No notes',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? lightGrayText
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Amount Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: isDarkMode ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${isProfit ? '+' : '-'} ${expense.currency ?? currencies.first} ${formatAmount(expense.amount)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: itemColor,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
