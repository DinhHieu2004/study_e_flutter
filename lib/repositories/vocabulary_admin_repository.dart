import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../models/vocabulary_response.dart';
import '../models/topic_vocabulary.dart';

class VocabularyAdminRepository {
  final Dio _dio = DioClient.dio;

  Future<List<VocabularyResponse>> getVocabularies() async {
    final response = await _dio.get('/studyE/api/vocabularies');

    return (response.data as List)
        .map((e) => VocabularyResponse.fromJson(e))
        .toList();
  }

  Future<List<TopicVocabulary>> getAllTopics() async {
    final response = await _dio.get('/studyE/api/topicV');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => TopicVocabulary.fromJson(e))
          .toList();
    } else {
      throw Exception('Load watched topics failed');
    }
  }

  Future<void> updateVocabulary(int id, Map<String, dynamic> payload) async {
    await _dio.put('/studyE/api/vocabularies/$id', data: payload);
  }

  Future<List<VocabularyResponse>> previewImport(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _dio.post(
      '/studyE/api/vocabularies/import/preview',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return (response.data as List)
        .map((e) => VocabularyResponse.fromJson(e))
        .toList();
  }

  Future<List<VocabularyResponse>> previewImportBytes(
    Uint8List bytes,
    String filename,
  ) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });

    final response = await _dio.post(
      '/studyE/api/vocabularies/import/preview',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return (response.data as List)
        .map((e) => VocabularyResponse.fromJson(e))
        .toList();
  }

  Future<void> confirmImport(List<VocabularyResponse> list) async {
    await _dio.post(
      '/studyE/api/vocabularies/import',
      data: list.map((e) => e.toJson()).toList(),
    );
  }
}
