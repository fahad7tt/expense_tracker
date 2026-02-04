import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
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
    this.isEdit = false,
    this.expense,
  });

  @override
  Widget build(BuildContext context) {
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

          if (isEdit && expense != null) {
            final updatedExpense = Expense(
              id: expense!.id,
              amount: amount,
              date: date,
              type: type,
              description: description,
              currency: currency,
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
      style: context.isDarkMode
          ? ButtonThemes.addExpenseButtonStyle
              .copyWith(backgroundColor: WidgetStateProperty.all(buttonColor))
          : ButtonThemes.addExpenseButtonStyle,
      child: Text(
        isEdit ? 'Save Changes' : 'Add Expense',
        style: ButtonThemes.elevatedButtonTextStyle.copyWith(
          color: context.isDarkMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
