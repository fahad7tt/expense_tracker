import 'package:flutter/material.dart';

class DialogService {
  static Future<void> showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirmed) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
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
