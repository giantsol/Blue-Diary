
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/presentation/App.dart';

class GetDayMemoUsecase {
  final _memoRepository = dependencies.memoRepository;

  Future<DayMemo> invoke(DateTime date) async {
    return _memoRepository.getDayMemo(date);
  }
}