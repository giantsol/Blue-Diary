
import 'package:flutter/material.dart';
import 'package:todo_app/domain/usecase/UnscheduleReminderNotificationUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class ScheduleReminderNotificationUsecase {
  final _notificationRepository = dependencies.notificationRepository;

  final _unscheduleReminderNotificationUsecase = UnscheduleReminderNotificationUsecase();

  Future<void> invoke(BuildContext context, int year, int month, int day) async {
    final localDate = DateTime.now();
    if (localDate.hour < 21) {
      await _unscheduleReminderNotificationUsecase.invoke();
      return _notificationRepository.scheduleReminderNotification(context, year, month, day);
    }
  }
}