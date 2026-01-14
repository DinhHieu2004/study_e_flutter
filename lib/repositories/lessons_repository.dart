import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/page_response.dart';
import '../models/lesson_response.dart';

class LessonsRepository {
  final Dio _dio = DioClient.dio;

  static const _prefix = '/studyE/api';

  Future<PageResponse<LessonResponseModel>> getLessonsByTopic({
    required int topicId,
    int page = 0,
    int size = 50,
  }) async {
    try {
      final res = await _dio.get(
        '$_prefix/lessions',
        queryParameters: {
          'topicId': topicId,
          'page': page,
          'size': size,
        },
      );

      return PageResponse.fromJson(
        res.data as Map<String, dynamic>,
        (j) => LessonResponseModel.fromJson(j),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error fetching lessons');
    }
  }
}
