
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class SetDayMemoUsecase {
  final MemoRepository _memoRepository;

  SetDayMemoUsecase(this._memoRepository);

  void invoke(DayMemo dayMemo) {
    _memoRepository.setDayMemo(dayMemo);
  }
}
