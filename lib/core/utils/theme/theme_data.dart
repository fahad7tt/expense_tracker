import 'package:flutter/material.dart';
import '../constants/constants.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: deepBlue,
    secondary: softBlue,
    surface: lightGray,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: darkGray,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    color: deepBlue,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: const CardTheme(
    color: Colors.white,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
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
    headlineSmall: TextStyle(
      color: darkGray,
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      color: darkGray,
      fontSize: 22,
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
    bodyLarge: TextStyle(
      color: darkGray,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: lightGrayText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
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
    filled: true,
    fillColor: lightGray,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayText),
    ),
  ),
  scaffoldBackgroundColor: Colors.white, 
  bottomAppBarTheme: const BottomAppBarTheme(color: deepBlue),
);


// Dark Theme
final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: deepBlue,
    secondary: softBlue,
    surface: darkGray,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    color: deepBlue,
    titleTextStyle: TextStyle(
      color: Colors.white,
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
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: lightGrayText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
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
    filled: true,
    fillColor: darkGray,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayText),
    ),
  ),
  scaffoldBackgroundColor: darkGray, 
  bottomAppBarTheme: const BottomAppBarTheme(color: deepBlue),
);