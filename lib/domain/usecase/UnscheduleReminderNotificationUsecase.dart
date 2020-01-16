
import 'package:todo_app/presentation/App.dart';

class UnscheduleReminderNotificationUsecase {
  final _notificationRepository = dependencies.notificationRepository;

  Future<void> invoke() {
    return _notificationRepository.unscheduleReminderNotification();
  }
}