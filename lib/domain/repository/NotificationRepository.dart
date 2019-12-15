
import 'package:flutter/material.dart';

abstract class NotificationRepository {
  Future<bool> isReminderNotificationScheduled();
  Future<void> scheduleReminderNotification(BuildContext context);
  void unscheduleReminderNotification();
  void showFirebaseMessage(BuildContext context, Map<String, dynamic> message);
}