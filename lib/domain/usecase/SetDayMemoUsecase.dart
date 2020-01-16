
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/presentation/App.dart';

class SetDayMemoUsecase {
  final _memoRepository = dependencies.memoRepository;

  Future<void> invoke(DayMemo dayMemo) {
    return _memoRepository.setDayMemo(dayMemo);
  }
}
