import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/theme/theme_data.dart';

ThemeData getLightTheme() => lightTheme;
ThemeData getDarkTheme() => darkTheme;

extension ThemeContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
