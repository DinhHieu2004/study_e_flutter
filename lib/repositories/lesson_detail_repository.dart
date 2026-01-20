import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/lesson_detail_response.dart';
import '../models/dialog_response.dart';
import '../models/vocabulary_response.dart';

class LessonDetailRepository {
  final Dio _dio = DioClient.dio;

  static const _prefix = '/studyE/api';

  Future<LessonDetailResponse> getLessonById(String lessonId) async {
    final res = await _dio.get('$_prefix/lessions/$lessonId');
    return LessonDetailResponse.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> markLessonDone(String lessonId) async {
    await _dio.post(
      '$_prefix/lessions/done',
      queryParameters: {'lessonId': lessonId},
    );
  }

  Future<List<DialogResponse>> getDialogs(String lessonId) async {
    final res = await _dio.get('$_prefix/dialogs/$lessonId');
    final list = (res.data as List)
        .whereType<Map<String, dynamic>>()
        .map(DialogResponse.fromJson)
        .toList();
    return list;
  }

  Future<List<VocabularyResponse>> getVocabReview(String lessonId) async {
    final res = await _dio.get(
      '$_prefix/vocabularies/review',
      queryParameters: {'lessonId': lessonId},
    );

    final list = (res.data as List)
        .whereType<Map<String, dynamic>>()
        .map(VocabularyResponse.fromJson)
        .toList();
    return list;
  }
}
