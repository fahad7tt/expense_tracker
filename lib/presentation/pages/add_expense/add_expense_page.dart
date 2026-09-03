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
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  final _formKey = GlobalKey<FormState>();

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isProfitNotifier,
      builder: (context, isProfit, child) {
        final Color activeColor = isProfit ? profitColor : expenseColor;

        return Scaffold(
          appBar: AppBar(
            title: Text(isProfit ? 'New Income' : 'New Expense'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // SEGMENTED TOGGLE SWITCH
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(30),
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
                                      ? expenseColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !isProfit
                                        ? lightColor
                                        : (context.isDarkMode
                                            ? lightGrayText
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
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Income / Profit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isProfit
                                        ? lightColor
                                        : (context.isDarkMode
                                            ? lightGrayText
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

                    // AMOUNT & CURRENCY CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: context.isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ENTER AMOUNT',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: activeColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CurrencyPicker(selectedCurrency: selectedCurrency),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FormFieldWidget(
                                  controller: amountController,
                                  labelText: 'Amount',
                                  keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [CurrencyInputFormatter()],
                                  validator: validateAmount,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // DETAILS CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: context.isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TRANSACTION DETAILS',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: softBlue,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TypePicker(
                            selectedType: selectedType,
                            isProfit: isProfit,
                          ),
                          const SizedBox(height: 16),
                          FormFieldWidget(
                            controller: descriptionController,
                            labelText: 'Description',
                            maxLines: 2,
                            validator: validateDescription,
                          ),
                          const SizedBox(height: 16),
                          DatePickerWidget(
                            selectedDate: selectedDate,
                            dateFormat: dateFormat,
                            minDate: DateTime(2000),
                            maxDate: DateTime.now(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // SUBMIT ACTION BUTTON
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
