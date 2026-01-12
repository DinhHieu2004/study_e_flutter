import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  String urlForAndroid = 'http://10.0.2.2:8080';
  String urlForWeb = 'http://localhost:8080';
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'http://localhost:8080',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              if (!options.path.contains('/auth/login') &&
                  !options.path.contains('/auth/register') &&
                  !options.path.contains('/dictionary/lookup')) {
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
