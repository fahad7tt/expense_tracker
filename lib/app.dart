import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/theme/theme_data.dart';
import 'package:provider/provider.dart';
import 'core/utils/providers/providers.dart';
import 'core/utils/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        title: 'Personal Expense Tracker',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routes: appRoutes,
      ),
    );
  }
}
