import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload == 'dismiss_alarm') {
          _notificationsPlugin.cancel(1); // Cancel the alarm notification
        }
      },
    );
  }

  static Future<void> showAlarmNotification({
    required String title,
    required String body,
    // String sound = 'alarm_sound',
  }) async {
    final List<AndroidNotificationAction> actions = [
      const AndroidNotificationAction(
        'dismiss_action',
        'Dismiss',
        showsUserInterface: true,
        cancelNotification: true,
      ),
    ];

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound(sound),
      playSound: true,
      ongoing: true,
      autoCancel: false,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      actions: actions,
      visibility: NotificationVisibility.public,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      1, // TODO Use a unique ID for each alarm notification
      title,
      body,
      platformChannelSpecifics,
      payload: 'dismiss_alarm',
    );
  }
}
