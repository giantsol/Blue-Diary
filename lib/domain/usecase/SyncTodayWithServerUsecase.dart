
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/presentation/App.dart';

class SyncTodayWithServerUsecase {
  final DateRepository _dateRepository = dependencies.dateRepository;

  Future<bool> invoke() {
    return _dateRepository.syncTodayWithServer();
  }
}