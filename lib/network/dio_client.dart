import 'package:dio/dio.dart';

class DioClient {

  String urlForAndroid = 'http://10.0.2.2:8080';
  String urlForWeb = 'http://localhost:8080';
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
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
          const token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhNm16WVpGV3Z4ZGFrZUVJd1NiN0Z1WjhsWDQzIiwiZW1haWwiOiJoaWV1dGh1b25nMTEzQGdtYWlsLmNvbSIsIm5hbWUiOiJIaWV1IFRodW9uZyIsInVzZXJJZCI6NiwiaWF0IjoxNzY3NjE4MTcwLCJleHAiOjE3Njc3MTgwNzB9.nkv1-BFA6Q4nOduDawNaeEF6ZxUIS6icM5SWlmJCbXdAWfZjlkxkxzO8t6RYtzKvRqvWmZDkx3m3IJMXRpLnhA';
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
