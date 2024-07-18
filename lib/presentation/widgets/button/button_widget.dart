import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/theme/button_theme.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/expense.dart';
import '../../pages/expense_list_page.dart';
import '../../providers/expense_provider.dart';

class ButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final ValueNotifier<DateTime> selectedDate;

  const ButtonWidget({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.descriptionController,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final amount = double.parse(amountController.text);
          final description = descriptionController.text;

          final expense = Expense(
            id: DateTime.now().millisecondsSinceEpoch,
            amount: amount,
            date: selectedDate.value,
            description: description,
          );

          await Provider.of<ExpenseProvider>(context, listen: false)
              .addNewExpense(expense);

          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ExpenseListPage(),
            ),
          );
        }
      },
      style: ButtonThemes.elevatedButtonStyle,
      child: Text(
        'Save Expense',
        style: ButtonThemes.elevatedButtonTextStyle,
      ),
    );
  }
}
