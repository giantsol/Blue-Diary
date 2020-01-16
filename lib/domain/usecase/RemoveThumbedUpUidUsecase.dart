import 'package:todo_app/presentation/App.dart';

class RemoveThumbedUpUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  Future<void> invoke(String uid) {
    return _rankingRepository.removeThumbedUpUid(uid);
  }
}
