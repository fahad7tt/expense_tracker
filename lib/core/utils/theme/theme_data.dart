import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0056A0), // Deep Blue
    secondary: Color(0xFFE0F7FA), // Light Cyan
    surface: Color(0xFFFFFFFF), // White
    error: Color(0xFFD32F2F), // Red
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Color(0xFF212121), // Dark Gray
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF0056A0), // Deep Blue
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFFFFFFFF), // White
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFFFFFF), // White
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF212121), // Dark Gray
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF757575), // Gray
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Color(0xFF757575), // Gray
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      color: Color(0xFF757575), // Gray
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE0F7FA), // Light Cyan
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF757575)), // Gray
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: const Color(0xFF009688),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
