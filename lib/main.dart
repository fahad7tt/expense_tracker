import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/app.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;
import 'core/utils/helper/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  await di.init();

  // Scheduled a daily notification at 8:00 AM
  NotificationHelper.scheduleDailyNotification(
    'Expense Reminder',
    'Don\'t forget to record your expenses for today!',
    const TimeOfDay(hour: 8, minute: 0),
  );

  // Test notification in 10 seconds
   NotificationHelper.scheduleTestNotification(
    'Test Notification',
    'This notification was scheduled to test functionality.',
    const Duration(seconds: 10), // Set to 10 seconds for testing
  );

  runApp(const MyApp());
}