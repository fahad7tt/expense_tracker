import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import '../../../core/utils/validation/form_validation.dart';
import '../../widgets/button/button_widget.dart';
import '../../widgets/date_picker/date_picker_widget.dart';
import '../../widgets/form_field/form_field_widget.dart';
import '../../widgets/type_picker/type_picker.dart';
import '../../widgets/currency_picker/currency_picker.dart';
import '../../../core/utils/formatters/currency_input_formatter.dart';

class AddExpensePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String?> selectedType = ValueNotifier<String?>(null);
  final ValueNotifier<String> selectedCurrency =
      ValueNotifier<String>(currencies.first);
  final ValueNotifier<bool> isProfitNotifier = ValueNotifier<bool>(false);
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // Date format

  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isProfitNotifier,
      builder: (context, isProfit, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(isProfit ? 'Add Profit' : 'Add Expense'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isProfitNotifier.value != false) {
                                  isProfitNotifier.value = false;
                                  selectedType.value = null;
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isProfit
                                      ? buttonColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !isProfit
                                        ? lightColor
                                        : (context.isDarkMode
                                            ? lightGray
                                            : darkGray),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isProfitNotifier.value != true) {
                                  isProfitNotifier.value = true;
                                  selectedType.value = null;
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isProfit
                                      ? profitColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Profit / Income',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isProfit
                                        ? lightColor
                                        : (context.isDarkMode
                                            ? lightGray
                                            : darkGray),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TypePicker(
                      selectedType: selectedType,
                      isProfit: isProfit,
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrencyPicker(selectedCurrency: selectedCurrency),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FormFieldWidget(
                            controller: amountController,
                            labelText: 'Amount',
                            labelStyle: TextStyle(
                              color: context.isDarkMode ? lightGray : null,
                            ),
                            cursorColor: context.isDarkMode ? lightGray : null,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [CurrencyInputFormatter()],
                            validator: validateAmount,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    FormFieldWidget(
                      controller: descriptionController,
                      labelText: 'Description',
                      labelStyle:
                          TextStyle(color: context.isDarkMode ? lightGray : null),
                      cursorColor: context.isDarkMode ? lightGray : null,
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
                      selectedCurrency: selectedCurrency,
                      isProfitNotifier: isProfitNotifier,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
