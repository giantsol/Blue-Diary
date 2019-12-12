
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/domain/repository/NotificationRepository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
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
  Future<void> raiseTempNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return _notificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}