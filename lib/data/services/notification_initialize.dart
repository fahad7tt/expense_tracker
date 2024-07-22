import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'expense_reminder_channel',
      'Expense Reminder',
      channelDescription: 'Daily reminder to record expenses',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Expense Reminder',
      'Don\'t forget to record your expenses for today!',
      platformChannelSpecifics,
    );
  }

  Future<void> scheduleDailyNotification() async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Daily Expense Reminder',
        'Remember to record your expenses for today!',
        _nextInstanceOf8PM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'expense_reminder_channel',
            'Expense Reminder',
            channelDescription: 'Daily reminder to record expenses',
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        print('Exact alarms not permitted. Falling back to inexact scheduling.');
        await _scheduleInexactDailyNotification();
      } else {
        print('Failed to schedule notification: ${e.message}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<void> _scheduleInexactDailyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Daily Expense Reminder',
      'Remember to record your expenses for today!',
      _nextInstanceOf8PM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expense_reminder_channel',
          'Expense Reminder',
          channelDescription: 'Daily reminder to record expenses',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 14, 21);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleTestNotification() async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        'Test Notification',
        'This is a test notification',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Notifications',
            channelDescription: 'For testing notifications',
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        print('Exact alarms not permitted for test notification. Showing immediate notification instead.');
        await showNotification();
      } else {
        print('Failed to schedule test notification: ${e.message}');
      }
    } catch (e) {
      print('An unexpected error occurred while scheduling test notification: $e');
    }
  }

  Future<bool> requestExactAlarmPermission() async {
  final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin != null) {
    return await androidPlugin.requestExactAlarmsPermission() ?? false;
  }
  return false;
}
}