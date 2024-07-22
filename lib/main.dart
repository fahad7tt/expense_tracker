import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/app.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;
import 'data/services/notification_initialize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  await di.init();

  // Initialize NotificationService
  final notificationService = NotificationService();
  await notificationService.init();

  // Request permission and schedule notifications
  bool hasPermission = await notificationService.requestExactAlarmPermission();
  if (hasPermission) {
    await notificationService.scheduleDailyNotification();
    print('Daily notification scheduled successfully');
  } else {
    print('User denied exact alarm permission. Falling back to inexact scheduling.');
    // You might want to call a method for inexact scheduling here
    // await notificationService.scheduleInexactDailyNotification();
  }

  // Schedule test notification
  try {
    await notificationService.scheduleTestNotification();
    print('Test notification scheduled successfully');
  } catch (e) {
    print('Failed to schedule test notification: $e');
  }

  runApp(const MyApp());
}