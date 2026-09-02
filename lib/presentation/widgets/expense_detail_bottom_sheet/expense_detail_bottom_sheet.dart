// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../core/utils/formatters/amount_formatter.dart';
import '../../../core/utils/theme/system_theme.dart';
import '../../../domain/entities/expense.dart';
import '../../pages/edit_expense/edit_expense_page.dart';
import '../../providers/expense_provider.dart';
import '../confirm_dialog/confirm_dialog.dart';

void showExpenseDetailBottomSheet(BuildContext context, Expense expense) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final bool isDarkMode = ctx.isDarkMode;
      final bool isProfit = expense.isProfit;
      final Color itemColor = isProfit ? profitColor : buttonColor;
      final String currencyStr = expense.currency ?? currencies.first;

      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(ctx).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Bar with Drag Handle and Action Icons (Edit & Delete) at Top Right
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        color: isDarkMode ? softBlue : deepBlue,
                        tooltip: 'Edit',
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditExpensePage(expense: expense),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Theme.of(ctx).colorScheme.error,
                        tooltip: 'Delete',
                        onPressed: () {
                          Navigator.pop(ctx);
                          DialogService.showDeleteConfirmationDialog(context, () {
                            Provider.of<ExpenseProvider>(context, listen: false)
                                .removeExpense(expense.id);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Header Row: Icon Avatar + Title & Type Badge + Amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isDarkMode
                      ? itemColor.withOpacity(0.2)
                      : itemColor.withOpacity(0.12),
                  child: Icon(
                    typeIcons[expense.type] ??
                        (isProfit ? Icons.trending_up : Icons.category),
                    color: isDarkMode ? lightColor : itemColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.type ?? 'General',
                        style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: itemColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          isProfit ? 'Income / Profit' : 'Expense',
                          style: TextStyle(
                            color: itemColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${isProfit ? '+' : '-'} $currencyStr ${formatAmount(expense.amount)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: itemColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Details List (Date formatted as dd-MM-yyyy, EEEE)
            _buildDetailRow(
              ctx,
              icon: Icons.calendar_today_rounded,
              title: 'Date',
              value: DateFormat('dd-MM-yyyy, EEEE').format(expense.date),
            ),
            const Divider(height: 20),

            _buildDetailRow(
              ctx,
              icon: Icons.tag,
              title: 'Transaction ID',
              value: '#${expense.id}',
            ),
            const Divider(height: 20),

            _buildDetailRow(
              ctx,
              icon: Icons.notes_rounded,
              title: 'Description / Notes',
              value: expense.description.trim().isNotEmpty
                  ? expense.description
                  : 'No notes provided',
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget _buildDetailRow(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Colors.grey.shade600),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    ],
  );
}
