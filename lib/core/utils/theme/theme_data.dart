import 'package:flutter/material.dart';
import '../constants/constants.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: deepBlue,
    secondary: Color.fromARGB(255, 9, 155, 14),
    surface: lightGray,
    error: errorColor,
    onPrimary: lightColor,
    onSecondary: darkColor,
    onSurface: darkColor,
    onError: lightColor,
  ),
  appBarTheme: const AppBarTheme(
    color: deepBlue,
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 22,
      fontWeight: FontWeight.w400,
    ),
    iconTheme: IconThemeData(
    color: iconColor
  ),
  ),
  cardTheme: const CardTheme(
    color: cardColor,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: lightColor,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: darkGray,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: darkGray,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    // delete text
    headlineSmall: TextStyle(
      color: darkGray,
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    // type name text
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: darkGray,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    
    titleSmall: TextStyle(
      color: darkGray,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    // edit textfields
    bodyLarge: TextStyle(
      color: darkGray,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    // calendar dates
    bodyMedium: TextStyle(
      color: deepBlue,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    // calendar save button
    labelLarge: TextStyle(
      color: lightColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    // date text
    bodySmall: TextStyle(
      color: lightGrayText,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      color: lightGrayText,
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayText),
    ),
  ),
  scaffoldBackgroundColor: lightColor, 
  bottomAppBarTheme: const BottomAppBarTheme(color: deepBlue),
);


// Dark Theme
final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: deepBlue,
    secondary: Colors.green,
    surface: darkGray,
    error: errorColor,
    onPrimary: lightColor,
    onSecondary: darkColor,
    onSurface: lightColor,
    onError: lightColor,
  ),
  appBarTheme: const AppBarTheme(
    color: deepBlue,
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: const CardTheme(
    color: darkGray,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: darkGray,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: lightColor,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: lightColor,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: lightColor,
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      color: lightColor,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: lightColor,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      color: lightColor,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: TextStyle(
      color: lightColor,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: lightGrayText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: lightColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: lightGrayText,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      color: lightGrayText,
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayText),
    ),
  ),
  scaffoldBackgroundColor: darkGray, 
  bottomAppBarTheme: const BottomAppBarTheme(color: deepBlue),
);