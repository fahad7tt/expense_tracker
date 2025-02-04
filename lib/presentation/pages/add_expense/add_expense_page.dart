import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import '../../../core/utils/validation/form_validation.dart';
import '../../widgets/button/button_widget.dart';
import '../../widgets/date_picker/date_picker_widget.dart';
import '../../widgets/form_field/form_field_widget.dart';
import '../../widgets/type_picker/type_picker.dart';

class AddExpensePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String?> selectedType = ValueNotifier<String?>(null);
  late final ValueNotifier<List<String>> typesNotifier;
  final Box<String> typesBox = GetIt.instance<Box<String>>();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // Date format

  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  AddExpensePage({super.key}) {
    // Initialize typesNotifier with data from Hive
    typesNotifier = ValueNotifier<List<String>>(typesBox.values.toList());

    // Optionally add default types if not present in the box
    if (typesBox.isEmpty) {
      typesBox.addAll(['Food', 'Drink', 'Sports', 'Others']);
      typesNotifier.value = typesBox.values.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
      title: const Text('Add Expense'),
      centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                TypePicker(
                  selectedType: selectedType,
                  typesNotifier: typesNotifier,
                  typesBox: typesBox,
                ),
                const SizedBox(height: 24.0),
                FormFieldWidget(
                  controller: amountController,
                  labelText: 'Amount',
                  keyboardType: TextInputType.number,
                  validator: validateAmount,
                ),
                const SizedBox(height: 24.0),
                FormFieldWidget(
                  controller: descriptionController,
                  labelText: 'Description',
                  maxLines: 3,
                  validator: validateDescription,
                ),
                const SizedBox(height: 24.0),
                DatePickerWidget(
                  selectedDate: selectedDate,
                  dateFormat: dateFormat,
                  minDate: DateTime(2000),
                  maxDate: DateTime.now(),
                ),
                const SizedBox(height: 28.0),
                ButtonWidget(
                  formKey: _formKey,
                  amountController: amountController,
                  descriptionController: descriptionController,
                  selectedDate: selectedDate,
                  selectedType: selectedType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
