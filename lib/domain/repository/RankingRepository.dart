
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';

abstract class RankingRepository {
  Future<RankingUserInfo> getRankingUserInfo(String uid);
  Future<void> setRankingUserInfo(RankingUserInfo info);
  Future<bool> setMyRankingUserInfo(RankingUserInfo info);
  Stream<RankingUserInfosEvent> observeRankingUserInfos();
  void initRankingUserInfosCount();
  void increaseRankingUserInfosCount();
  Future<void> deleteRankingUserInfo(String uid);
  void addThumbsUp(RankingUserInfo info);
}