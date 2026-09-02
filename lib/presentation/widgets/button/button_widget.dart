import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme/button_theme.dart';
import '../../../domain/entities/expense.dart';
import '../../providers/expense_provider.dart';
import '../../providers/expense_summary_provider.dart';
import '../../../core/utils/constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final ValueNotifier<DateTime> selectedDate;
  final ValueNotifier<String?> selectedType;
  final ValueNotifier<String> selectedCurrency;
  final ValueNotifier<bool>? isProfitNotifier;
  final bool isEdit;
  final Expense? expense;

  const ButtonWidget({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.descriptionController,
    required this.selectedDate,
    required this.selectedType,
    required this.selectedCurrency,
    this.isProfitNotifier,
    this.isEdit = false,
    this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final bool isProfit = isProfitNotifier?.value ?? (expense?.isProfit ?? false);
    final Color activeColor = isProfit ? profitColor : buttonColor;

    return ElevatedButton(
      onPressed: () async {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          final amount =
              double.parse(amountController.text.replaceAll(',', ''));
          final description = descriptionController.text;
          final date = selectedDate.value;
          final type = selectedType.value;
          final currency = selectedCurrency.value;
          final currentIsProfit = isProfitNotifier?.value ?? (expense?.isProfit ?? false);

          if (isEdit && expense != null) {
            final updatedExpense = Expense(
              id: expense!.id,
              amount: amount,
              date: date,
              type: type,
              description: description,
              currency: currency,
              isProfit: currentIsProfit,
            );
            await Provider.of<ExpenseProvider>(context, listen: false)
                .modifyExpense(updatedExpense);
          } else {
            final newExpense = Expense(
              id: DateTime.now().millisecondsSinceEpoch,
              amount: amount,
              date: date,
              type: type,
              description: description,
              currency: currency,
              isProfit: currentIsProfit,
            );
            await Provider.of<ExpenseProvider>(context, listen: false)
                .addNewExpense(newExpense);
          }

          // Refresh the summary provider
          // ignore: use_build_context_synchronously
          await Provider.of<ExpenseSummaryProvider>(context, listen: false)
              .loadSummaries(
            DateTime(DateTime.now().year, DateTime.now().month, 1),
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
          );

          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      style: ButtonThemes.addExpenseButtonStyle.copyWith(
        backgroundColor: WidgetStateProperty.all(activeColor),
      ),
      child: Text(
        isEdit
            ? 'Save Changes'
            : (isProfit ? 'Add Profit' : 'Add Expense'),
        style: ButtonThemes.elevatedButtonTextStyle.copyWith(
          color: lightColor,
        ),
      ),
    );
  }
}
