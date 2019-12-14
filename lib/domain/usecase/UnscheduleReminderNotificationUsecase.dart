
import 'package:todo_app/presentation/App.dart';

class UnscheduleReminderNotificationUsecase {
  final _notificationRepository = dependencies.notificationRepository;

  void invoke() {
    _notificationRepository.unscheduleReminderNotification();
  }
}