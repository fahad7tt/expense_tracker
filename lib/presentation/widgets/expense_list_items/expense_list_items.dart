import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../domain/entities/expense.dart';
import '../expense_detail_bottom_sheet/expense_detail_bottom_sheet.dart';

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
    final bool isProfit = widget.expense.isProfit;
    final Color itemColor = isProfit ? profitColor : expenseColor;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Slidable.of(context)?.close();
            showExpenseDetailBottomSheet(context, widget.expense);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 40, top: 14, right: 16, bottom: 14),
            child: Row(
              children: [
                // Category Icon Avatar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: itemColor.withOpacity(isDarkMode ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    typeIcons[widget.expense.type] ??
                        (isProfit ? Icons.trending_up_rounded : Icons.category_rounded),
                    color: isDarkMode ? lightColor : itemColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Title & Description/Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expense.type ?? 'General',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? lightColor : deepBlue,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.expense.description.isNotEmpty
                            ? widget.expense.description
                            : DateFormat.yMMMd().format(widget.expense.date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? lightGrayText : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Amount Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: itemColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${isProfit ? '+' : '-'} ${widget.expense.currency ?? currencies.first} ${formatAmount(widget.expense.amount)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: itemColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Slidable Drag Indicator Handle
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
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
              width: 28,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.04),
              ),
              child: Center(
                child: Icon(
                  _isOpen
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: isDarkMode ? lightGrayText : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
