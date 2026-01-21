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
      headers: {'Accept': 'application/json'},
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;

          final isAuthEndpoint =
              path.contains('/auth/login') || path.contains('/auth/signUp');

          final isFileEndpoint =
              path.contains('/api/files') || path.contains('/studyE/api/files');

          if (!isAuthEndpoint && !isFileEndpoint) {
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
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}
