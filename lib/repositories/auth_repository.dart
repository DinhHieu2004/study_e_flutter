import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../network/dio_client.dart';
import '../network/firebase_auth_service.dart';

class AuthRepository {
  final _service = FirebaseAuthService();
  final Dio _dio = DioClient.dio;

  Stream authState() => _service.authStateChanges();

  Future<void> login(String email, String password) async {
    final firebaseToken = await _service.login(email, password);
    await _loginWithBackend(firebaseToken);
  }

  Future<void> loginWithGoogle() async {
    final firebaseToken = await _service.loginWithGoogle();
    await _loginWithBackend(firebaseToken);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final fbUser = await _service.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    await _dio.post(
      '/studyE/auth/signUp',
      data: {
        'uid': fbUser.uid,
        'email': fbUser.email,
        'name': fbUser.displayName,
      },
    );
  }

  Future<void> _loginWithBackend(String firebaseToken) async {
    try {
      final response = await _dio.post(
        '/studyE/auth/login',
        data: {'idToken': firebaseToken},
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Backend login failed');
      }

      final data = response.data;

      if (data['token'] == null || data['uid'] == null) {
        throw Exception('Invalid token from backend');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', data['token']);
      await prefs.setString('uid', data['uid']);
      final fbUser = _service.currentUser;
      if (fbUser != null) {
        await prefs.setString('email', fbUser.email ?? '');
        await prefs.setString('name', fbUser.displayName ?? '');
      }

      debugPrint('[AUTH] JWT saved');
    } catch (e) {
      throw Exception('BE login error: $e');
    }
  }

  Future<void> logout() async {
    await _service.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
