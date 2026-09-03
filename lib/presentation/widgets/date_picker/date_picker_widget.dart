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
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDate,
      builder: (context, date, child) {
        final bool isToday = DateUtils.isSameDay(date, DateTime.now());
        final bool isYesterday = DateUtils.isSameDay(
            date, DateTime.now().subtract(const Duration(days: 1)));

        String datePresetLabel = dateFormat.format(date);
        if (isToday) datePresetLabel = 'Today (${dateFormat.format(date)})';
        if (isYesterday) datePresetLabel = 'Yesterday (${dateFormat.format(date)})';

        return InkWell(
          onTap: () => _showDatePickerBottomSheet(context, date),
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Transaction Date',
              suffixIcon: Icon(Icons.calendar_today_rounded, size: 20),
            ),
            child: Text(
              datePresetLabel,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDatePickerBottomSheet(BuildContext context, DateTime currentDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bool isDarkMode = context.isDarkMode;
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              const SizedBox(height: 16),
              Text(
                'Select Transaction Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : deepBlue,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildPresetChip(
                      context,
                      label: 'Today',
                      isSelected: DateUtils.isSameDay(currentDate, today),
                      onTap: () {
                        selectedDate.value = today;
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPresetChip(
                      context,
                      label: 'Yesterday',
                      isSelected: DateUtils.isSameDay(currentDate, yesterday),
                      onTap: () {
                        selectedDate.value = yesterday;
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: minDate,
                      lastDate: maxDate,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: softBlue,
                              onPrimary: lightColor,
                              surface: isDarkMode ? darkGray : lightColor,
                              onSurface: isDarkMode ? lightColor : darkColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != currentDate) {
                      selectedDate.value = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: const Text('Pick Custom Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: softBlue,
                    foregroundColor: lightColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  Widget _buildPresetChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? softBlue
              : (context.isDarkMode
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isSelected
                ? lightColor
                : (context.isDarkMode ? lightGrayText : darkGray),
          ),
        ),
      ),
    );
  }
}
