import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/page_response.dart';
import '../models/admin_lesson_model.dart';

class AdminLessonsRepository {
  final Dio _dio = DioClient.dio;
  static const _prefix = '/studyE/api';

  Future<PageResponse<AdminLessonModel>> getLessons({
    int? topicId,
    int page = 0,
    int size = 50,
    String? q,
  }) async {
    final res = await _dio.get(
      '$_prefix/lessions',
      queryParameters: {
        if (topicId != null) 'topicId': topicId,
        'page': page,
        'size': size,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(), 
      },
    );

    return PageResponse.fromJson(
      res.data as Map<String, dynamic>,
      (j) => AdminLessonModel.fromJson(j),
    );
  }

  Future<AdminLessonModel> getLessonById(int id) async {
    final res = await _dio.get('$_prefix/lessions/$id');
    return AdminLessonModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AdminLessonModel> createLesson(AdminLessonModel model) async {
    final res = await _dio.post(
      '$_prefix/lessions',
      data: model.toRequestJson(),
    );
    return AdminLessonModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AdminLessonModel> updateLesson(int id, AdminLessonModel model) async {
    final res = await _dio.put(
      '$_prefix/lessions/$id',
      data: model.toRequestJson(),
    );
    return AdminLessonModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteLesson(int id) async {
    await _dio.delete('$_prefix/lessions/$id');
  }
}
