import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/flash_card.dart';

class FlashcardRepository {
  final Dio _dio = DioClient.dio;

  Future<List<Flashcard>> getByLesson(int lessonId) async {
    final response = await _dio.get(
      '/studyE/api/vocabularies/review',
      queryParameters: {'lessonId': lessonId},
    );

    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Flashcard.fromJson(e)).toList();
    } else {
      throw Exception('Load flashcards failed');
    }
  }
}
