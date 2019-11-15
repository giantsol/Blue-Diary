
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';

abstract class UserRepository {
  Future<String> getUserDisplayName();
  Future<bool> signInWithGoogle();
  Future<bool> signInWithFacebook();
  Future<bool> signOut();
  Future<void> setRankingUserInfo(String uid, RankingUserInfo info);
  Stream<RankingUserInfosEvent> observeRankingUserInfosEvent();
  void initRankingUserInfosCount();
  void increaseRankingUserInfosCount();
  Future<String> getUserId();
  Future<void> deleteRankingUserInfo(String uid);
}