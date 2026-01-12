import 'package:dio/dio.dart';
import '../models/dictionary_response.dart';
import '../network/dio_client.dart';

class DictionaryRepository {
  final Dio _dio = DioClient.dio;

  Future<DictionaryResponse> getWord(String word) async {
    try {
      print('Calling dictionary API with word: $word');
      final Response response = await _dio.get(
        '/studyE/dictionary/lookup',
        queryParameters: {'word': word},
      );

      if (response.statusCode == 200) {
        return DictionaryResponse.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception("Word not found: $word");
      } else {
        throw Exception("Failed to fetch word: $word");
      }
    } catch (e) {
      throw Exception("Dictionary API error: $e");
    }
  }
}
