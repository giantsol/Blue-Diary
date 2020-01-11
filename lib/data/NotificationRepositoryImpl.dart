
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/data/datasource/AppPreferences.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/NotificationRepository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static const NOTIFICATION_ID_REMINDER_NOTIFICATION = 1;
  static const NOTIFICATION_ID_FIREBASE_MESSAGING_DEFAULT = 2;

  static const CHANNEL_ID_REMINDER_NOTIFICATION = 'reminder.notification';
  static const CHANNEL_ID_FIREBASE_MESSAGING_NOTIFICATION = 'firebase.messaging.notification';

  final AppDatabase _database;
  final AppPreferences _prefs;

  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationRepositoryImpl(this._database, this._prefs) {
    _init();
  }

  Future<void> _init() {
    final androidInitializationSettings = AndroidInitializationSettings('ic_splash');
    final iosInitializationSettings = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);

    return _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {
      // todo: remove debugPrints
      debugPrint('onSelectNotification with payload: $payload');
      return true;
    });
  }

  @override
  Future<void> scheduleReminderNotification(BuildContext context, int year, int month, int day) async {
    final localizations = AppLocalizations.of(context);
    final selectedPetPhase = await _getSelectedPetPhase();

    final channelName = localizations.reminderNotificationChannelName;
    final channelDescription = localizations.reminderNotificationChannelDescription;
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(CHANNEL_ID_REMINDER_NOTIFICATION,
      channelName, channelDescription,
      largeIcon: selectedPetPhase.notificationIconName.isNotEmpty ? selectedPetPhase.notificationIconName : null,
      largeIconBitmapSource: BitmapSource.FilePath,
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    final title = localizations.reminderNotificationTitle;
    final body = localizations.reminderNotificationBody;
    return _notificationsPlugin.schedule(NOTIFICATION_ID_REMINDER_NOTIFICATION,
      title,
      body,
      DateTime(year, month, day, 22),
      platformChannelSpecifics);
  }

  Future<PetPhase> _getSelectedPetPhase() async {
    final selectedPetKey = await _prefs.getSelectedPetKey();
    if (selectedPetKey.isEmpty) {
      return PetPhase.INVALID;
    } else {
      final selectedPet = await _database.getPet(selectedPetKey);
      return selectedPet.currentPhase;
    }
  }

  @override
  Future<void> unscheduleReminderNotification() {
    return _notificationsPlugin.cancel(NOTIFICATION_ID_REMINDER_NOTIFICATION);
  }

  @override
  Future<void> showFirebaseMessage(BuildContext context, Map<String, dynamic> message) async {
    final notification = message['notification'];
    final title = notification['title'];
    final body = notification['body'];

    final data = message['data'];
    final id = data['id'] != null ? int.tryParse(data['id']) ?? NOTIFICATION_ID_FIREBASE_MESSAGING_DEFAULT
      : NOTIFICATION_ID_FIREBASE_MESSAGING_DEFAULT;

    final localizations = AppLocalizations.of(context);
    final selectedPetPhase = await _getSelectedPetPhase();
    final channelName = localizations.firebaseMessagingNotificationChannelName;
    final channelDescription = localizations.firebaseMessagingNotificationChannelDescription;
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(CHANNEL_ID_FIREBASE_MESSAGING_NOTIFICATION,
      channelName, channelDescription,
      icon: selectedPetPhase.notificationIconName.isNotEmpty ? selectedPetPhase.notificationIconName : null,
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }
}