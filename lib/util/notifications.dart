import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> createScheduledNotification(TimeOfDay timeOfDay) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'scheduled_alarm_channel',
      title: '${Emojis.time_alarm_clock} Hey your alarm is ringing!',
      body: 'Click this notification to see chart',
      notificationLayout: NotificationLayout.Default,
      category: NotificationCategory.Alarm,
      wakeUpScreen: true,
      locked: true,
    ),
    schedule: NotificationCalendar(
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}
