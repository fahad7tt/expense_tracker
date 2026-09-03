import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';

class ButtonThemes {
  static final ButtonStyle sortFilterButtonStyle = ElevatedButton.styleFrom(
    elevation: 1,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle addExpenseButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: deepBlue,
    minimumSize: const Size(double.infinity, 48),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  static const TextStyle elevatedButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500
  );
}
