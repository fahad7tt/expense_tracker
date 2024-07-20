import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';

class DatePickerWidget extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate;
  final DateFormat dateFormat;

  const DatePickerWidget({
    super.key,
    required this.selectedDate,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: darkColor),
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
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
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
