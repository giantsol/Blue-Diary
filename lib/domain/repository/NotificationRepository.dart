
import 'package:flutter/material.dart';

abstract class NotificationRepository {
  Future<bool> isReminderNotificationScheduled();
  void scheduleReminderNotification(BuildContext context);
  void unscheduleReminderNotification();
}