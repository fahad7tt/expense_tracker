// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/core/utils/formatters/amount_formatter.dart';
import '../../../core/utils/theme/button_theme.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedMonth =
        Provider.of<ExpenseSummaryProvider>(context).selectedMonth ??
            DateTime.now();

    // Format month and year
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final String formattedMonth = formatter.format(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 14, bottom: 4),
            child: ElevatedButton.icon(
              icon: Icon(Icons.calendar_today,
                  size: normalIcon,
                  color: context.isDarkMode ? darkColor : deepBlue),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedMonth,
                    style: ButtonThemes.elevatedButtonTextStyle.copyWith(
                        fontSize: dateIcon,
                        color: context.isDarkMode ? darkColor : deepBlue),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(Icons.arrow_drop_down,
                      size: normalIcon,
                      color: context.isDarkMode ? darkColor : deepBlue),
                ],
              ),
              onPressed: () async {
                final DateTime? picked = await showMonthPicker(
                  context: context,
                  initialDate: selectedMonth,
                  firstDate: DateTime(DateTime.now().year - 5, 1),
                  lastDate: DateTime(DateTime.now().year, DateTime.now().month),
                  monthPickerDialogSettings: MonthPickerDialogSettings(
                    headerSettings: PickerHeaderSettings(
                      headerBackgroundColor:
                          context.isDarkMode ? darkGray : deepBlue,
                      headerCurrentPageTextStyle:
                          const TextStyle(color: lightColor),
                    ),
                    dialogSettings: const PickerDialogSettings(
                      dialogBackgroundColor: lightColor,
                    ),
                    dateButtonsSettings: const PickerDateButtonsSettings(
                      selectedMonthBackgroundColor: buttonColor,
                      selectedMonthTextColor: lightColor,
                      unselectedMonthsTextColor: darkColor,
                      currentMonthTextColor: darkColor,
                    ),
                    actionBarSettings: const PickerActionBarSettings(
                      confirmWidget:
                          Text('OK', style: TextStyle(color: Colors.green)),
                      cancelWidget:
                          Text('Cancel', style: TextStyle(color: errorColor)),
                    ),
                  ),
                );

                if (picked != null && picked != selectedMonth) {
                  final DateTime startDate =
                      DateTime(picked.year, picked.month, 1);
                  final DateTime endDate =
                      DateTime(picked.year, picked.month + 1, 0);
                  Provider.of<ExpenseSummaryProvider>(context, listen: false)
                      .setSelectedMonth(picked);
                  Provider.of<ExpenseSummaryProvider>(context, listen: false)
                      .loadSummaries(startDate, endDate);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                backgroundColor: buttonColor,
                foregroundColor: lightColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ExpenseSummaryProvider>(
              builder: (context, provider, child) {
                final summaries = provider.summaries;
                if (summaries.isEmpty) {
                  return const Center(
                    child: Text('No summaries available for this period.'),
                  );
                }
                return ListView.builder(
                  itemCount: summaries.length,
                  itemBuilder: (context, index) {
                    final summary = summaries[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 14.0),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: CircleAvatar(
                            backgroundColor: context.isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.12),
                            child: Icon(
                              typeIcons[summary.type] ?? Icons.category,
                              color: context.isDarkMode
                                  ? lightColor
                                  : Theme.of(context).primaryColor,
                              size: normalIcon,
                            ),
                          ),
                          title: Text(
                            summary.type,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 18),
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 35),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  '${summary.currency} ${formatAmount(summary.totalAmount)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            'Total entries: ${summary.count}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
