
import 'package:todo_app/presentation/App.dart';

class CancelThumbsUpUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  Future<void> invoke(String uid) {
    return _rankingRepository.cancelThumbsUp(uid);
  }
}
