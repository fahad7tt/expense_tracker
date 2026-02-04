import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';

class DatePickerWidget extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate;
  final DateFormat dateFormat;
  final DateTime minDate;
  final DateTime maxDate;

  DatePickerWidget({
    super.key,
    required this.selectedDate,
    required this.dateFormat,
    DateTime? minDate,
    DateTime? maxDate,
  })  : minDate = minDate ?? DateTime(2000),
        maxDate = maxDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.isDarkMode ? lightGray : darkColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ValueListenableBuilder<DateTime>(
        valueListenable: selectedDate,
        builder: (context, date, child) {
          return ListTile(
            title: Text(dateFormat.format(date)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: minDate,
                lastDate: maxDate,
                builder: (context, child) {
                  if (context.isDarkMode) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: buttonColor, // Selected date BG
                          onPrimary: lightColor, // Selected date text
                          surface: darkGray, // Dialog BG
                          onSurface: lightColor, // General text
                          secondary: buttonColor,
                        ),
                        datePickerTheme: DatePickerThemeData(
                          confirmButtonStyle: TextButton.styleFrom(
                            foregroundColor: buttonColor,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  }
                  return child!;
                },
              );
              if (picked != null && picked != date) {
                selectedDate.value = picked;
              }
            },
          );
        },
      ),
    );
  }
}
