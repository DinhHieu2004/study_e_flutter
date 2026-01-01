import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          const token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhNm16WVpGV3Z4ZGFrZUVJd1NiN0Z1WjhsWDQzIiwiZW1haWwiOiJoaWV1dGh1b25nMTEzQGdtYWlsLmNvbSIsIm5hbWUiOiJIaWV1IFRodW9uZyIsInVzZXJJZCI6NiwiaWF0IjoxNzY2ODI5MzQxLCJleHAiOjE3NjY5MjkyNDF9.iQcM2rx7XbRWsszsw79MH4TRB0n2v77nNfAzuS6__DY9DSDs3W6swLs8daZ34s7aYY06uW74V7zVPmCm6M2w5g';
          options.headers['Authorization'] = 'Bearer $token';

          return handler.next(options);
        },
      ),
    )
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
}
