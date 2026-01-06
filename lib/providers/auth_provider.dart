import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  bool isLoading = false;
  String? error;
  bool isAuthenticated = false;

  Stream get firebaseAuthState => _repo.authState();

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _repo.login(email, password);
      isAuthenticated = true;
      error = null;
    } catch (e) {
      isAuthenticated = false;
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _repo.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await _repo.loginWithGoogle();
      isAuthenticated = true;
      error = null;
    } catch (e) {
      isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _repo.logout();
    isAuthenticated = false;
    notifyListeners();
  }

  void _setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }
}
