import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/presentation/widgets/type_picker/type_picker.dart';
import '../../../core/utils/validation/form_validation.dart';
import '../../../domain/entities/expense.dart';
import '../../widgets/button/button_widget.dart';
import '../../widgets/date_picker/date_picker_widget.dart';
import '../../widgets/form_field/form_field_widget.dart';
import '../../widgets/currency_picker/currency_picker.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';

class EditExpensePage extends StatelessWidget {
  final Expense expense;

  const EditExpensePage({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController =
        TextEditingController(text: formatAmount(expense.amount));
    final TextEditingController descriptionController =
        TextEditingController(text: expense.description);
    final ValueNotifier<DateTime> selectedDate =
        ValueNotifier<DateTime>(expense.date);
    final ValueNotifier<String?> selectedType =
        ValueNotifier<String?>(expense.type);
    final ValueNotifier<String> selectedCurrency =
        ValueNotifier<String>(expense.currency ?? currencies.first);
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    final formKey = GlobalKey<FormState>(); // GlobalKey for Form

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TypePicker(
                  selectedType: selectedType,
                ),
                const SizedBox(height: 22.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurrencyPicker(selectedCurrency: selectedCurrency),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FormFieldWidget(
                        controller: amountController,
                        labelText: 'Amount',
                        keyboardType: TextInputType.number,
                        validator: validateAmount,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22.0),
                FormFieldWidget(
                  controller: descriptionController,
                  labelText: 'Description',
                  maxLines: 3,
                  validator: validateDescription,
                ),
                const SizedBox(height: 22.0),
                DatePickerWidget(
                  selectedDate: selectedDate,
                  dateFormat: dateFormat,
                  minDate: DateTime(2000),
                  maxDate: DateTime.now(),
                ),
                const SizedBox(height: 28.0),
                ButtonWidget(
                  formKey: formKey,
                  amountController: amountController,
                  descriptionController: descriptionController,
                  selectedDate: selectedDate,
                  selectedType: selectedType,
                  selectedCurrency: selectedCurrency,
                  isEdit: true,
                  expense: expense,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
