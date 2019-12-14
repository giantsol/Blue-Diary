
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/App.dart';

class ScheduleReminderNotificationUsecase {
  final _notificationRepository = dependencies.notificationRepository;

  void invoke(BuildContext context) {
    _notificationRepository.scheduleReminderNotification(context);
  }
}