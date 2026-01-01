import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<String> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception("User null");

    final token = await user.getIdToken(true);
    if (token == null) throw Exception("Cannot get Firebase ID Token");

    return token;
  }

  Future<String> loginWithGoogle() async {
    if (kIsWeb) {
      // Web flow
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Buộc Google popup hiển thị màn chọn account
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      final userCredential = await _auth.signInWithPopup(googleProvider);

      final token = await userCredential.user!.getIdToken();
      if (token == null) throw Exception("Cannot get Firebase ID Token (Web)");
      return token;
    } else {
      // Mobile flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final token = await userCredential.user!.getIdToken();
      if (token == null)
        throw Exception("Cannot get Firebase ID Token (Mobile)");
      return token;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
