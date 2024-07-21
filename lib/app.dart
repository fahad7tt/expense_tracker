import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/theme/theme_data.dart';
import 'package:personal_expense_tracker/presentation/pages/expense_list/expense_list_page.dart';
import 'package:personal_expense_tracker/presentation/pages/splash_screen/splash_screen.dart';
import 'package:personal_expense_tracker/presentation/pages/expense_summary/expense_summary_pages.dart';
import 'package:personal_expense_tracker/presentation/pages/profile/profile_page.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => di.sl<ExpenseProvider>(),
        ),
        ChangeNotifierProvider<ExpenseSummaryProvider>(
          create: (_) => di.sl<ExpenseSummaryProvider>(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => di.sl<NavigationProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'Personal Expense Tracker',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(),
          '/home':  (context) => ExpenseListPage(),
          '/summary': (context) => const ExpenseSummaryPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}