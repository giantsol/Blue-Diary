import 'package:todo_app/presentation/App.dart';

class GetHasThumbedUpUidUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  Future<bool> invoke(String uid) {
    return _rankingRepository.isThumbedUpUid(uid);
  }
}