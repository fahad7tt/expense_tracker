import 'package:flutter/material.dart';

const Color cardAndDialogBackgroundColor = Colors.white;

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF003366), // Deep Blue
    secondary: Color(0xFF66CCFF), // Soft Blue
    surface: Color(0xFFF5F5F5), // Light Gray
    error: Color(0xFFB00020),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Color(0xFF333333),
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF003366), // Deep Blue
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold, // Bold font for app bar title
    ),
  ),
  cardTheme: const CardTheme(
    color: cardAndDialogBackgroundColor, // Card background color
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: cardAndDialogBackgroundColor, // Dialog background color
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF333333), // Dark Gray
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF888888), // Light Gray
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold, // Bold font for button text
    ),
    bodySmall: TextStyle(
      color: Color(0xFF888888), // Light Gray
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      color: Color(0xFF888888), // Light Gray
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F5F5), // Light Gray (used for input fields)
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF888888)), // Light Gray border
    ),
  ),
);
