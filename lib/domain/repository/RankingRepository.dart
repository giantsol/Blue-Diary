
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';

abstract class RankingRepository {
  Future<RankingUserInfo> getRankingUserInfo(String uid);
  Future<void> setMyRankingUserInfo(RankingUserInfo info);
  Stream<RankingUserInfosEvent> observeRankingUserInfosEvent();
  void initRankingUserInfosCount();
  void increaseRankingUserInfosCount();
  Future<void> deleteRankingUserInfo(String uid);
  void increaseThumbsUp(RankingUserInfo info);
}