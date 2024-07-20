import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/presentation/widgets/type_picker/type_picker.dart';
import '../../core/utils/validation/form_validation.dart';
import '../widgets/button/button_widget.dart';
import '../widgets/date_picker/date_picker_widget.dart';
import '../widgets/form_field/form_field_widget.dart';

class AddExpensePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String?> selectedType = ValueNotifier<String?>(null);
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // Date format

  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TypePicker(selectedType: selectedType),
                const SizedBox(height: 22.0),
                FormFieldWidget(
                  controller: amountController,
                  labelText: 'Amount',
                  keyboardType: TextInputType.number,
                  validator: validateAmount,
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
                ),
                const SizedBox(height: 28.0),
                ButtonWidget(
                  formKey: _formKey,
                  amountController: amountController,
                  descriptionController: descriptionController,
                  selectedDate: selectedDate,
                  selectedType: selectedType
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}