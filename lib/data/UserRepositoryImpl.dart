
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

class UserRepositoryImpl implements UserRepository {
  static const FIRESTORE_RANKING_USER_INFO_COLLECTION = 'ranking_user_info';
  static const RANKING_PAGING_SIZE = 2;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription _firestoreRankingUserInfosSubscription;
  int _currentRankingMaxCount = RANKING_PAGING_SIZE;

  final _rankingUserInfosEventSubject = BehaviorSubject<RankingUserInfosEvent>();

  UserRepositoryImpl() {
    _rankingUserInfosEventSubject.onCancel = () {
      _firestoreRankingUserInfosSubscription?.cancel();
    };
  }

  @override
  Future<String> getUserDisplayName() async {
    final user = await _auth.currentUser();
    return user == null ? '' : user.displayName;
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      await _auth.signInWithCredential(credential);
      return true;
    } catch(e) {
      //todo: deal with errors
      return false;
    }
  }

  @override
  Future<bool> signInWithFacebook() async {
    try {
      final result = await _facebookLogin.logIn(['public_profile', 'email']);
      final credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
      await _auth.signInWithCredential(credential);
      return true;
    } catch(e) {
      //todo: deal with errors
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    if (await _facebookLogin.isLoggedIn) {
      await _facebookLogin.logOut();
    }
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();

    final userName = await getUserDisplayName();
    if (userName.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> setRankingUserInfo(String uid, RankingUserInfo info) async {
    return Firestore.instance
      .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
      .document(uid)
      .setData(info.toMap());
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
    _firestoreRankingUserInfosSubscription?.cancel();
    _firestoreRankingUserInfosSubscription = Firestore.instance
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
  Future<String> getUserId() async {
    final user = await _auth.currentUser();
    return user == null ? '' : user.uid;
  }

  @override
  Future<void> deleteRankingUserInfo(String uid) {
    return Firestore.instance
      .collection(FIRESTORE_RANKING_USER_INFO_COLLECTION)
      .document(uid)
      .delete();
  }
}