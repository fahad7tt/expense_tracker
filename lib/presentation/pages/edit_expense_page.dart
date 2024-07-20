import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/presentation/widgets/type_picker/type_picker.dart';
import '../../core/utils/validation/form_validation.dart';
import '../../domain/entities/expense.dart';
import '../widgets/button/button_widget.dart';
import '../widgets/date_picker/date_picker_widget.dart';
import '../widgets/form_field/form_field_widget.dart';

class EditExpensePage extends StatelessWidget {
  final Expense expense;

  const EditExpensePage({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController(text: expense.amount.toString());
    final TextEditingController descriptionController = TextEditingController(text: expense.description);
    final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(expense.date);
    final ValueNotifier<String> selectedType = ValueNotifier<String>(expense.type!);
    late final ValueNotifier<List<String>> typesNotifier;
    final Box<String> typesBox = GetIt.instance<Box<String>>();
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    final formKey = GlobalKey<FormState>(); // GlobalKey for Form

    // Initialize typesNotifier with data from Hive
    typesNotifier = ValueNotifier<List<String>>(typesBox.values.toList());

    if (typesBox.isEmpty) {
      typesBox.addAll(['Food', 'Drink', 'Sports', 'Others']);
      typesNotifier.value = typesBox.values.toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TypePicker(
                selectedType: selectedType,
                typesNotifier: typesNotifier,
                typesBox: typesBox,
              ),
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
                formKey: formKey,
                amountController: amountController,
                descriptionController: descriptionController,
                selectedDate: selectedDate,
                selectedType: selectedType,
                isEdit: true,
                expense: expense,
              ),
            ],
          ),
        ),
      ),
    );
  }
}