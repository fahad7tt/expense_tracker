// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import '../../main.dart';

// Future<void> scheduleDailyNotification() async {
//   final tz.TZDateTime scheduledDate = _nextInstanceOfTime(12, 20, 0); // 8:00 AM

//   const androidDetails = AndroidNotificationDetails(
//     'daily_expense_channel_id',
//     'Daily Expense Notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
//   const notificationDetails = NotificationDetails(
//     android: androidDetails,
//     iOS: iosDetails,
//   );

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     'Expense Tracker Reminder',
//     'Remember to record your expenses for today!',
//     scheduledDate,
//     notificationDetails,
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
// }

// tz.TZDateTime _nextInstanceOfTime(int hour, int minute, int second) {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute, second);
//   if (scheduledDate.isBefore(now)) {
//     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   }
//   return scheduledDate;
// }