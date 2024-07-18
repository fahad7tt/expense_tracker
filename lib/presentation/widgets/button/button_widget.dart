import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/expense.dart';
import '../../providers/expense_provider.dart';

class ButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final ValueNotifier<DateTime> selectedDate;
  final bool isEdit;
  final Expense? expense;

  const ButtonWidget({super.key, 
    required this.formKey,
    required this.amountController,
    required this.descriptionController,
    required this.selectedDate,
    this.isEdit = false,
    this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          final amount = double.parse(amountController.text);
          final description = descriptionController.text;

          if (isEdit && expense != null) {
            final updatedExpense = Expense(
              id: expense!.id,
              amount: amount,
              date: selectedDate.value,
              description: description,
            );
            await Provider.of<ExpenseProvider>(context, listen: false).modifyExpense(updatedExpense);
          } else {
            final newExpense = Expense(
              id: DateTime.now().millisecondsSinceEpoch,
              amount: amount,
              date: selectedDate.value,
              description: description,
            );
            await Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);
          }

          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        isEdit ? 'Save Changes' : 'Add Expense',
        style: TextStyle(color: Colors.grey[800]),
      ),
    );
  }
}