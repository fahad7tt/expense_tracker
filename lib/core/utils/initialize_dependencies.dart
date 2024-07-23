import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/core/utils/helper/notification_helper.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;

Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  // Initialize Dependency Injection
  await di.init();

  // Initialize Notifications
  NotificationHelper.init();
  NotificationHelper.scheduleDailyNotification(
    'Expense Reminder',
    'Don\'t forget to record your expenses for today!',
    const TimeOfDay(hour: 8, minute: 0),
  );
  NotificationHelper.scheduleTestNotification(
    'Test Notification',
    'This notification was scheduled to test functionality.',
    const Duration(seconds: 10),
  );
}
