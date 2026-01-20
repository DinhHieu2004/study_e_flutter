import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/flash_card.dart';
import '../models/unlockable_flashcard.dart';

class FlashcardRepository {
  final Dio _dio = DioClient.dio;

  Future<List<Flashcard>> getByLesson(int lessonId) async {
    final response = await _dio.get(
      '/studyE/api/vocabularies/review2',
      queryParameters: {'topicId': lessonId},
    );

    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Flashcard.fromJson(e)).toList();
    } else {
      throw Exception('Load flashcards failed');
    }
  }

  Future<List<UnlockableFlashcard>> getByTopic(int topicId) async {
    final res = await _dio.get(
      '/studyE/api/vocabularies/unlockable',
      queryParameters: {'topicId': topicId},
    );

    return (res.data as List)
        .map((e) => UnlockableFlashcard.fromJson(e))
        .toList();
  }
}
