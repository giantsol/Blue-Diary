
import 'package:flutter/material.dart';

abstract class NotificationRepository {
  Future<void> scheduleReminderNotification(BuildContext context, int year, int month, int day);
  Future<void> unscheduleReminderNotification();
  Future<void> showFirebaseMessage(BuildContext context, Map<String, dynamic> message);
}