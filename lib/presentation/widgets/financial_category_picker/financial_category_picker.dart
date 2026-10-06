import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';

class FinancialCategoryPicker extends StatelessWidget {
  final ValueNotifier<String?> selectedCategory;
  final bool isProfit;

  const FinancialCategoryPicker({
    super.key,
    required this.selectedCategory,
    this.isProfit = false,
  });

  static const List<String> expenseFinancialCategories = [
    'Living & Utilities',
    'Investment',
    'Savings',
    'Donation',
    'Personal Development',
  ];

  static const List<String> incomeFinancialCategories = [
    'Salary',
    'Investment Return',
    'Gift / Allowance',
    'Other Profit',
  ];

  static String detectCategory(String? type, bool isProfit) {
    if (type == null || type.isEmpty) {
      return isProfit ? 'Salary' : 'Living & Utilities';
    }
    final lower = type.toLowerCase();
    if (isProfit) {
      if (lower.contains('investment') ||
          lower.contains('dividend') ||
          lower.contains('passive')) {
        return 'Investment Return';
      } else if (lower.contains('gift') ||
          lower.contains('allowance') ||
          lower.contains('refund')) {
        return 'Gift / Allowance';
      } else if (lower.contains('salary') ||
          lower.contains('freelance') ||
          lower.contains('bonus') ||
          lower.contains('business')) {
        return 'Salary';
      }
      return 'Other Profit';
    } else {
      if (lower.contains('investment')) return 'Investment';
      if (lower.contains('savings') ||
          lower.contains('insurance') ||
          lower.contains('tax')) return 'Savings';
      if (lower.contains('donation') ||
          lower.contains('charity') ||
          lower.contains('gift')) return 'Donation';
      if (lower.contains('personal development') ||
          lower.contains('education') ||
          lower.contains('book')) return 'Personal Development';
      return 'Living & Utilities';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        isProfit ? incomeFinancialCategories : expenseFinancialCategories;
    final isDark = context.isDarkMode;

    return ValueListenableBuilder<String?>(
      valueListenable: selectedCategory,
      builder: (context, value, child) {
        final currentValue =
            (value != null && categories.contains(value)) ? value : categories.first;

        return DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            labelText: 'Financial Category',
            labelStyle: TextStyle(
              fontSize: 14,
              color: isDark ? lightGrayText : Colors.grey.shade700,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: softBlue,
                width: 1.5,
              ),
            ),
          ),
          dropdownColor: Theme.of(context).cardTheme.color,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? lightGrayText : Colors.grey.shade600,
          ),
          items: categories.map((cat) {
            final color = getCategoryThemeColor(cat, isProfit);
            final icon = _getCategoryIcon(cat, isProfit);

            return DropdownMenuItem<String>(
              value: cat,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? lightColor : darkGray,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              selectedCategory.value = val;
            }
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(String cat, bool isProfit) {
    if (isProfit) {
      if (cat.toLowerCase().contains('investment')) {
        return Icons.trending_up_rounded;
      }
      if (cat.toLowerCase().contains('gift')) return Icons.redeem_rounded;
      return Icons.account_balance_wallet_rounded;
    }
    final lower = cat.toLowerCase();
    if (lower.contains('investment')) return Icons.show_chart_rounded;
    if (lower.contains('savings')) return Icons.savings_rounded;
    if (lower.contains('donation')) return Icons.volunteer_activism_rounded;
    if (lower.contains('personal development')) return Icons.psychology_rounded;
    return Icons.home_work_rounded;
  }
}
