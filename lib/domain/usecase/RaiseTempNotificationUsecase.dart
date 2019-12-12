
import 'package:todo_app/presentation/App.dart';

class RaiseTempNotificationUsecase {
  final _notificationRepository = dependencies.notificationRepository;

  void invoke() {
    _notificationRepository.raiseTempNotification();
  }
}