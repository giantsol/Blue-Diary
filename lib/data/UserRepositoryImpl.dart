
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

class UserRepositoryImpl implements UserRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> getUserDisplayName() async {
    final user = _auth.currentUser;
    return user == null ? '' : user.displayName;
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      await signOut();
      return false;
    }
  }

  @override
  Future<bool> signInWithFacebook() async {
    return false;
  }

  @override
  Future<bool> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();

      final userId = await getUserId();
      if (userId.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> getUserId() async {
    final user = _auth.currentUser;
    return user == null ? '' : user.uid;
  }

  @override
  Future<bool> setUserDisplayName(String uid, String name) async {
    try {
      final user = _auth.currentUser;
      await user.updateProfile(displayName: name);
      return true;
    } catch (e) {
      return false;
    }
  }
}