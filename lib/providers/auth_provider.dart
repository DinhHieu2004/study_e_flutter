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

  Stream get authState => _repo.authState();

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _repo.login(email, password);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> loginWithGoogle() async {
    _setLoading(true);
    try {
      await _repo.loginWithGoogle();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    await _repo.logout();
  }

  void _setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }
}
