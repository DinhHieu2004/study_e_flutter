import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static const String urlForAndroid = 'http://10.0.2.2:8080';
  static const String urlForWeb = 'http://localhost:8080';

  static String get _baseUrl => kIsWeb ? urlForWeb : urlForAndroid;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl, 
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;

          final isPublic =
              path.contains('/auth/login') ||
              path.contains('/auth/signUp') || 
              path.contains('/dictionary/lookup') ||
              path.startsWith('/studyE/api/lessions') ||      
              path.startsWith('/studyE/api/dialogs') ||      
              path.startsWith('/studyE/api/vocabularies');    

          if (!isPublic) {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('jwt_token');
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
      ),
    )
    ..interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
}
