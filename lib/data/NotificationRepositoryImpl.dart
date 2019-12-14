
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/repository/NotificationRepository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static const NOTIFICATION_ID_REMINDER_NOTIFICATION = 1;
  static const CHANNEL_ID_REMINDER_NOTIFICATION = 'reminder.notification';

  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationRepositoryImpl() {
    _init();
  }

  Future<void> _init() async {
    final androidInitializationSettings = AndroidInitializationSettings('ic_splash');
    final iosInitializationSettings = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);

    await _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) {
      debugPrint('onSelectNotification with payload: $payload');
      return;
    });
  }

  @override
  Future<bool> isReminderNotificationScheduled() async {
    final pendingRequests = await _notificationsPlugin.pendingNotificationRequests();
    return pendingRequests.any((it) => it.id == NOTIFICATION_ID_REMINDER_NOTIFICATION);
  }

  @override
  void scheduleReminderNotification(BuildContext context) {
    final localNow = DateTime.now();
    if (localNow.hour >= 21) {
      return;
    }

    final localizations = AppLocalizations.of(context);

    final channelName = localizations.reminderNotificationChannelName;
    final channelDescription = localizations.reminderNotificationChannelDescription;
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(CHANNEL_ID_REMINDER_NOTIFICATION,
      channelName, channelDescription);
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    final title = localizations.reminderNotificationTitle;
    final body = localizations.reminderNotificationBody;
    _notificationsPlugin.schedule(NOTIFICATION_ID_REMINDER_NOTIFICATION,
      title,
      body,
      DateTime(localNow.year, localNow.month, localNow.day, 22),
      platformChannelSpecifics);
  }

  @override
  void unscheduleReminderNotification() {
    _notificationsPlugin.cancel(NOTIFICATION_ID_REMINDER_NOTIFICATION);
  }
}