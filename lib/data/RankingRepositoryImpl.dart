
import 'dart:async';

import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/data/datasource/AppFirebase.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';

class RankingRepositoryImpl implements RankingRepository {
  final AppDatabase _database;
  final AppFirebase _firebase;

  RankingRepositoryImpl(this._database, this._firebase);

  @override
  Future<RankingUserInfo> getRankingUserInfo(String uid) async {
    if (uid.isEmpty) {
      return RankingUserInfo.INVALID;
    } else {
      return _firebase.getRankingUserInfo(uid);
    }
  }

  @override
  Future<bool> setMyRankingUserInfo(RankingUserInfo info) {
    return _firebase.setMyRankingUserInfo(info);
  }

  @override
  Stream<RankingUserInfosEvent> observeRankingUserInfos() {
    return _firebase.observeRankingUserInfos();
  }

  @override
  void initRankingUserInfosCount() {
    _firebase.initRankingUserInfosCount();
  }

  @override
  void increaseRankingUserInfosCount() {
    _firebase.increaseRankingUserInfosCount();
  }

  @override
  Future<bool> deleteRankingUserInfo(String uid) {
    return _firebase.deleteRankingUserInfo(uid);
  }

  @override
  Future<void> addThumbUp(String uid) async {
    await _database.addThumbedUpUid(uid);
    final success = await _firebase.addThumbUp(uid);
    if (!success) {
      return _database.removeThumbedUpUid(uid);
    }
  }

  @override
  Future<bool> isThumbedUpUid(String uid) {
    return _database.isThumbedUpUid(uid);
  }

  @override
  Future<void> updateCompletionRatios(List<RankingUserInfo> infos) {
    return _firebase.updateCompletionRatios(infos);
  }
}