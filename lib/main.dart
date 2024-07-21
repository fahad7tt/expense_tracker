import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/presentation/pages/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/theme/theme_data.dart';
import 'injection_container.dart' as di;
import 'presentation/providers/expense_provider.dart';
import 'presentation/providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize local notifications plugin
  // final notificationInitialization = NotificationInitialization();
  // await notificationInitialization.initializeNotifications();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => di.sl<ExpenseProvider>(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => di.sl<NavigationProvider>(),
        ),
        // Provider<NotificationInitialization>(
        //   create: (_) => NotificationInitialization(),
        // ),
      ],
      child: MaterialApp(
        title: 'Personal Expense Tracker',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}