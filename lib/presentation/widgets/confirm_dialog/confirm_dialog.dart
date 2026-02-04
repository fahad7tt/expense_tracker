import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';

class DialogService {
  static Future<void> showDeleteConfirmationDialog(
      BuildContext context, VoidCallback onConfirmed) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.isDarkMode ? lightColor : deepBlue,
          title: Text('Delete Expense',
              style: TextStyle(
                  color: context.isDarkMode ? errorColor : lightColor,
                  fontWeight: FontWeight.w500)),
          content: Text('Are you sure you want to delete?',
              style: TextStyle(
                  color: context.isDarkMode ? darkColor : lightColor,
                  fontWeight: FontWeight.w600)),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDarkMode ? darkColor : lightColor,
                foregroundColor: context.isDarkMode ? lightColor : deepBlue,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDarkMode ? errorColor : lightColor,
                foregroundColor: context.isDarkMode ? lightColor : errorColor,
              ),
              child: const Text('Delete'),
              onPressed: () {
                onConfirmed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
