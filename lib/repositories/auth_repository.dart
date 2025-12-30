import '../network/firebase_auth_service.dart';

class AuthRepository {
  final _service = FirebaseAuthService();

  Stream authState() => _service.authStateChanges();

  Future<void> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<void> loginWithGoogle() {
    return _service.loginWithGoogle();
  }

  Future<void> logout() {
    return _service.logout();
  }
}
