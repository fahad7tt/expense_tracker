import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';

class ButtonThemes {
  static final ButtonStyle sortFilterButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
    ), backgroundColor: Colors.amber[900],
  );

  static final ButtonStyle addExpenseButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: deepBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
    ),
  );

  static const TextStyle elevatedButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500
  );
}
