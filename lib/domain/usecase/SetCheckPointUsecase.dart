
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class SetCheckPointUsecase {
  final MemoRepository _memoRepository;

  SetCheckPointUsecase(this._memoRepository);

  void invoke(CheckPoint checkPoint) {
    _memoRepository.setCheckPoint(checkPoint);
  }
}