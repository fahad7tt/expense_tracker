import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/app.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;

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