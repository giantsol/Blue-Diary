
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

class UserRepositoryImpl implements UserRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    await _auth.signOut();

    final userName = await getUserDisplayName();
    if (userName.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}