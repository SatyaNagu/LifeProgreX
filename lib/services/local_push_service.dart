import 'dart:math' as math;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class LocalPushService {
  static final LocalPushService _instance = LocalPushService._internal();

  factory LocalPushService() {
    return _instance;
  }

  LocalPushService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );

    // Request permissions for Android 13+ and iOS
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  /// Called when the app is paused/closed. Schedules repeated dynamic reminders.
  Future<void> scheduleAbsenceNotifications() async {
    // We cancel any previous schedules so they don't pile up.
    await cancelAllNotifications();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'absence_channel',
      'Absence Reminders',
      channelDescription: 'Reminders when away from the app',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final messages = [
      {'title': 'We miss you! 👋', 'body': 'Time to log your next activity? 🏃‍♂️💡'},
      {'title': 'Still there? 👀', 'body': 'Your journey is waiting for you! Keep the streak alive! 🔥'},
      {'title': 'Hey champion! 🏆', 'body': 'A quick check-in goes a long way. Log your progress now!'},
      {'title': 'Take a moment 🧘‍♂️', 'body': 'It only takes a minute to track your day. We believe in you!'},
      {'title': 'Stay on track 🚂', 'body': 'Consistency is key. Tap here to record your latest win!'},
    ];
    messages.shuffle();

    int totalHoursDelay = 0;
    final random = math.Random();

    // Schedule 5 dynamic notifications with randomized gaps (between 5 and 6 hours)
    for (int i = 0; i < 5; i++) {
      // Picks either 5 or 6 hours randomly for the next gap
      int gap = 5 + random.nextInt(2);
      totalHoursDelay += gap;

      await flutterLocalNotificationsPlugin.zonedSchedule(
        i + 1,
        messages[i]['title'],
        messages[i]['body'],
        tz.TZDateTime.now(tz.local).add(Duration(hours: totalHoursDelay)),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  /// Called when the app comes back to the foreground to cancel pending absence pings.
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
