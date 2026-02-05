import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;

import '../helpers/notification_helper.dart';

Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  // Initialize Dependency Injection
  await di.init();

  // Initialize Notifications
  NotificationHelper.init();
  await NotificationHelper.requestPermissions();
  NotificationHelper.scheduleDailyNotification(
    'Expense Reminder',
    'Don\'t forget to record your expenses for today!',
    const TimeOfDay(hour: 8, minute: 0),
  );
  // NotificationHelper.scheduleTestNotification(
  //   'Test Notification',
  //   'This notification was scheduled to test functionality.',
  //   const Duration(seconds: 10),
  // );
}
