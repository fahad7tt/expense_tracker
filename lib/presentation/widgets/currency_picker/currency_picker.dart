import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import '../../../../core/utils/theme/system_theme.dart';

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
        return SizedBox(
          width: 95,
          child: InkWell(
            onTap: () => _showCurrencyBottomSheet(context),
            borderRadius: BorderRadius.circular(10),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Currency',
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: context.isDarkMode ? lightGrayText : darkGray,
                    size: 20,
                  ),
                ],
              ),
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
      builder: (ctx) {
        final bool isDarkMode = context.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? lightColor : deepBlue,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? lightColor
                                    : (isDarkMode ? lightColor : darkColor),
                              ),
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) {
                                selectedCurrency.value = currency;
                                Navigator.pop(ctx);
                              }
                            },
                            selectedColor: softBlue,
                            backgroundColor: isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? softBlue
                                    : (isDarkMode
                                        ? const Color(0xFF475569)
                                        : const Color(0xFFCBD5E1)),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
