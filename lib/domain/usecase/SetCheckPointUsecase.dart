
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/presentation/App.dart';

class SetCheckPointUsecase {
  final _memoRepository = dependencies.memoRepository;

  Future<void> invoke(CheckPoint checkPoint) {
    return _memoRepository.setCheckPoint(checkPoint);
  }
}