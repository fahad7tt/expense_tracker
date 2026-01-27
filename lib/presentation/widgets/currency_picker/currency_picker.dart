import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';

class CurrencyPicker extends StatelessWidget {
  final ValueNotifier<String> selectedCurrency;

  const CurrencyPicker({
    required this.selectedCurrency,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedCurrency,
      builder: (context, value, child) {
        return InkWell(
          onTap: () => _showCurrencyBottomSheet(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 56, // Fixed height to match FormFieldWidget
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: darkColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding:
              const EdgeInsets.only(top: 12, bottom: 24, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: currencies.toSet().toList().map((currency) {
                  return ValueListenableBuilder<String>(
                    valueListenable: selectedCurrency,
                    builder: (context, value, child) {
                      final bool isSelected = value == currency;
                      return ChoiceChip(
                        label: Text(
                          currency,
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        showCheckmark: false,
                        onSelected: (selected) {
                          if (selected) {
                            selectedCurrency.value = currency;
                            Navigator.pop(context);
                          }
                        },
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Colors.grey.shade200,
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
