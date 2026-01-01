import 'package:flutter_application_1/models/sentence_model.dart';

import '../network/dio_client.dart';
import 'package:dio/dio.dart';

class PronunciationRepository {
  final Dio _dio = DioClient.dio;

  Future<List<String>> getPartPronunciation(String level) async {
    try {
      final Response response = await _dio.get(
        '/studyE/sentence/part',
        queryParameters: {
          "level": level,   
        },
       
      );

      return List<String>.from(response.data["parts"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Error fetching pronunciation parts",
      );
    }
  }

  Future<List<SentenceResponse>> getSentenceByPartAndLevel(String level, int part) async{
    final response = await _dio.get('/studyE/sentence', queryParameters: {'level': level, 'part': part});
    return (response.data as List).map((e) => SentenceResponse.fromJson(e)).toList();
  }

  Future<String> getPhonetic(String text) async{
    final response = await _dio.post('/studyE/phonetic',
    data: {"text": text});

    return response.data['phonemes'];
  }
}
