import 'package:flutter/material.dart';
import '../constants/constants.dart';

// Light Theme - Unified Palette
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: softBlue,
    secondary: profitColor,
    surface: Colors.white,
    error: errorColor,
    onPrimary: lightColor,
    onSecondary: lightColor,
    onSurface: darkGray,
    onError: lightColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: deepBlue,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.2,
    ),
    iconTheme: IconThemeData(color: lightColor),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: softBlue,
    foregroundColor: lightColor,
    elevation: 3,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: softBlue,
    unselectedItemColor: Color(0xFF94A3B8),
    elevation: 8,
  ),
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: Colors.white,
    elevation: 8,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: darkGray,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.8,
    ),
    headlineMedium: TextStyle(
      color: darkGray,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineSmall: TextStyle(
      color: darkGray,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: darkGray,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: darkGray,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: darkGray,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: darkGray,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: darkGray,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      color: lightColor,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: lightGrayText,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: lightGrayText,
      fontSize: 11,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: softBlue, width: 2.0),
    ),
    labelStyle: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
);

// Dark Theme - Unified Slate Palette
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: softBlue,
    secondary: profitColor,
    surface: Color(0xFF0F172A),
    error: errorColor,
    onPrimary: lightColor,
    onSecondary: lightColor,
    onSurface: lightColor,
    onError: lightColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F172A),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.2,
    ),
    iconTheme: IconThemeData(color: lightColor),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E293B),
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFF334155)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: softBlue,
    foregroundColor: lightColor,
    elevation: 3,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E293B),
    selectedItemColor: softBlue,
    unselectedItemColor: Color(0xFF64748B),
    elevation: 8,
  ),
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: Color(0xFF1E293B),
    elevation: 8,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF1E293B),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Color(0xFF334155)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: const Color(0xFF1E293B),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: lightColor,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.8,
    ),
    headlineMedium: TextStyle(
      color: lightColor,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineSmall: TextStyle(
      color: lightColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: lightColor,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: lightColor,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: lightColor,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: lightColor,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: lightColor,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      color: lightColor,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 11,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E293B),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF334155)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF334155)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: softBlue, width: 2.0),
    ),
    labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
);
