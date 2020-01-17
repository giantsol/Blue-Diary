
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';

class AppFirebase {
  static const FIRESTORE_RANKING_USER_INFO_COLLECTION = 'ranking_user_info';
  static const RANKING_PAGING_SIZE = 10;
  static const RANKING_MAX_COUNT = 20;

  static const DEFAULT_TIMEOUT = Duration(seconds: 5);

  StreamSubscription _rankingUserInfosSubscription;
  int _currentRankingMaxCount = RANKING_PAGING_SIZE;

  final _rankingUserInfosEventSubject = BehaviorSubject<RankingUserInfosEvent>();

  AppFirebase() {
    _rankingUserInfosEventSubject.onCancel = () {
      _rankingUserInfosSubscription?.cancel();
    };
  }

  Future<RankingUserInfo> getRankingUserInfo(String uid) async {
    try {
      final snapshot = await Firestore.instance
        .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
        .document(uid)
        .get()
        .timeout(DEFAULT_TIMEOUT);
      if (snapshot == null || snapshot.data == null) {
        return RankingUserInfo.INVALID;
      } else {
        return RankingUserInfo.fromMap(snapshot.data);
      }
    } catch (e) {
      return RankingUserInfo.INVALID;
    }
  }

  Future<bool> setMyRankingUserInfo(RankingUserInfo info) async {
    try {
      final callable = CloudFunctions.instance.getHttpsCallable(functionName: 'setMyRankingUserInfo');
      await callable.call(info.toMyRankingUserInfoUpdateMap()).timeout(DEFAULT_TIMEOUT);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<RankingUserInfosEvent> observeRankingUserInfos() {
    return _rankingUserInfosEventSubject.distinct();
  }

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
      // todo: use documentChanges instead of documents
      final snapshots = querySnapshot.documents;

      int rank = 0;
      double prevCompletionRatio;

      final infos = snapshots.map((snapshot) {
        final userInfo = RankingUserInfo.fromMap(snapshot.data);

        if (prevCompletionRatio == null) {
          rank += 1;
          prevCompletionRatio = userInfo.completionRatio;
        } else {
          if (userInfo.completionRatio != prevCompletionRatio) {
            rank += 1;
            prevCompletionRatio = userInfo.completionRatio;
          }
        }

        return userInfo.buildNew(rank: rank);
      }).toList();
      final hasMore = maxCount < RANKING_MAX_COUNT && snapshots.length == maxCount;
      final event =  RankingUserInfosEvent(
        rankingUserInfos: infos,
        hasMore: hasMore,
      );
      _rankingUserInfosEventSubject.add(event);
    }, onError: (error) {

    });

    _currentRankingMaxCount = maxCount;
  }

  void increaseRankingUserInfosCount() {
    _setRankingUserInfosMaxCount(min<int>(_currentRankingMaxCount + RANKING_PAGING_SIZE, RANKING_MAX_COUNT));
  }

  Future<bool> deleteRankingUserInfo(String uid) async {
    try {
      await Firestore.instance.runTransaction((transaction) async {
        final doc = Firestore.instance
          .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
          .document(uid);
        await transaction.delete(doc);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addThumbUp(String uid) async {
    try {
      await Firestore.instance.runTransaction((transaction) async {
        final doc = Firestore.instance
          .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
          .document(uid);
        final snapshot = await transaction.get(doc);

        if (snapshot.data != null) {
          final rankingUserInfo = RankingUserInfo.fromMap(snapshot.data);
          final updated = rankingUserInfo.buildNew(thumbUpCount: rankingUserInfo.thumbUpCount + 1);

          await transaction.update(doc, updated.toThumbUpCountUpdateMap());
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateCompletionRatios(List<RankingUserInfo> infos) {
    final collection = Firestore.instance.collection(FIRESTORE_RANKING_USER_INFO_COLLECTION);
    final batch = Firestore.instance.batch();

    for (RankingUserInfo info in infos) {
      batch.updateData(collection.document(info.uid), info.toCompletionRatioUpdateMap());
    }

    return batch.commit();
  }
}