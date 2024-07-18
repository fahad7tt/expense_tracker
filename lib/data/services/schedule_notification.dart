// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationScheduler {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'Expense Tracker Notifications',
//       'Notifications for your expense tracker app',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     final IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails();
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics.copyWith(
//         scheduleMode: ScheduleMode.once,
//       ),
//       iOS: iOSPlatformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       TZDateTime.from(scheduledDate, tz.local),
//       platformChannelSpecifics,
//     );
//   }
// }