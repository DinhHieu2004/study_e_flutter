import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../network/dio_client.dart';
import '../models/page_response.dart';
import '../models/admin_lesson_model.dart';

class AdminLessonsRepository {
  final Dio _dio = DioClient.dio;

  static const _prefix = '/studyE/api';

  static const _lessons = '$_prefix/admin/lessions';

  static const _upload = '$_prefix/files/upload';

  Future<PageResponse<AdminLessonModel>> getLessons({
    int? topicId,
    int page = 0,
    int size = 50,
    String? q,
  }) async {
    final res = await _dio.get(
      _lessons,
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
    final res = await _dio.get('$_lessons/$id');
    return AdminLessonModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AdminLessonModel> createLesson(AdminLessonModel model) async {
    final res = await _dio.post(_lessons, data: model.toRequestJson());
    return AdminLessonModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AdminLessonModel> updateLesson(int id, AdminLessonModel model) async {
    final res = await _dio.put('$_lessons/$id', data: model.toRequestJson());
    return AdminLessonModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteLesson(int id) async {
    await _dio.delete('$_lessons/$id');
  }

  Future<String> uploadFile({
    required PlatformFile file,
    required String type, 
  }) async {
    MultipartFile mf;

    if (file.bytes != null) {
      mf = MultipartFile.fromBytes(file.bytes!, filename: file.name);
    } else {
      mf = await MultipartFile.fromFile(file.path!, filename: file.name);
    }

    final form = FormData.fromMap({'file': mf});

    final res = await _dio.post(
      _upload, 
      data: form,
      queryParameters: {'type': type},
      options: Options(
        responseType: ResponseType.plain,
        contentType: 'multipart/form-data',
      ),
    );

    return res.data.toString();
  }
}
