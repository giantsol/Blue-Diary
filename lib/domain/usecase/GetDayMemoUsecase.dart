
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class GetDayMemoUsecase {
  final MemoRepository _memoRepository;

  GetDayMemoUsecase(this._memoRepository);

  Future<DayMemo> invoke(DateTime date) async {
    return _memoRepository.getDayMemo(date);
  }
}