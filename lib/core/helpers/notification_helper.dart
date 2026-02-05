import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    tz.initializeTimeZones();
  }

  static Future<void> requestPermissions() async {
    await _notification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleDailyNotification(
    String title,
    String body,
    TimeOfDay time,
  ) async {
    var androidDetails = const AndroidNotificationDetails(
      'daily_notifications',
      'DailyNotifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notification.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleTestNotification(
    String title,
    String body,
    Duration delay,
  ) async {
    var androidDetails = const AndroidNotificationDetails(
      'test_notifications',
      'TestNotifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now.add(delay);

    // ignore: avoid_print
    print('Scheduling test notification for: $scheduledDate');

    await _notification.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
