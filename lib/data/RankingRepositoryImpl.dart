
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';

class RankingRepositoryImpl implements RankingRepository {
  static const FIRESTORE_RANKING_USER_INFO_COLLECTION = 'ranking_user_info';
  static const RANKING_PAGING_SIZE = 2;

  StreamSubscription _rankingUserInfosSubscription;
  int _currentRankingMaxCount = RANKING_PAGING_SIZE;

  final _rankingUserInfosEventSubject = BehaviorSubject<RankingUserInfosEvent>();

  RankingRepositoryImpl() {
    _rankingUserInfosEventSubject.onCancel = () {
      _rankingUserInfosSubscription?.cancel();
    };
  }

  @override
  Future<RankingUserInfo> getRankingUserInfo(String uid) async {
    final snapshot = await Firestore.instance
      .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
      .document(uid)
      .get();
    if (snapshot == null) {
      return RankingUserInfo.INVALID;
    } else {
      return RankingUserInfo.fromMap(snapshot.data);
    }
  }

  @override
  Future<void> setRankingUserInfo(String uid, RankingUserInfo info) async {
    return Firestore.instance
      .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
      .document(uid)
      .setData(info.toMap(), merge: true);
  }

  @override
  Stream<RankingUserInfosEvent> observeRankingUserInfosEvent() {
    return _rankingUserInfosEventSubject.distinct();
  }

  @override
  void initRankingUserInfosCount() {
    _setRankingUserInfosMaxCount(RANKING_PAGING_SIZE);
  }

  void _setRankingUserInfosMaxCount(int maxCount) {
    _rankingUserInfosSubscription?.cancel();
    _rankingUserInfosSubscription = Firestore.instance
      .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
      .orderBy(RankingUserInfo.KEY_COMPLETION_RATIO, descending: true)
      .orderBy(RankingUserInfo.KEY_NAME)
      .limit(maxCount)
      .snapshots()
      .listen((querySnapshot) {
      final snapshots = querySnapshot.documents;
      final infos = snapshots.map((snapshot) => RankingUserInfo.fromMap(snapshot.data)).toList();
      final hasMore = snapshots.length == maxCount;
      final event =  RankingUserInfosEvent(
        rankingUserInfos: infos,
        hasMore: hasMore,
      );
      _rankingUserInfosEventSubject.add(event);
    });

    _currentRankingMaxCount = maxCount;
  }

  @override
  void increaseRankingUserInfosCount() {
    _setRankingUserInfosMaxCount(_currentRankingMaxCount + RANKING_PAGING_SIZE);
  }

  @override
  Future<void> deleteRankingUserInfo(String uid) {
    return Firestore.instance
      .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
      .document(uid)
      .delete();
  }
}