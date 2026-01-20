import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/flash_card.dart';
import '../models/unlockable_flashcard.dart';
import '../models/unlock_card_question.dart';

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

  Future<UnlockQuestion> getUnlockQuestion(int cardId) async {
    final res = await _dio.get(
      '/studyE/api/vocabularies/unlock-question',
      queryParameters: {'cardId': cardId},
    );

    if (res.statusCode == 200) {
      return UnlockQuestion.fromJson(res.data);
    } else {
      throw Exception('Load unlock question failed');
    }
  }

  Future<UnlockableFlashcard> confirmUnlock(
    int questionId,
    int answerIndex,
  ) async {
    final res = await _dio.post(
      '/studyE/api/vocabularies/unlock-confirm',
      data: {'questionId': questionId, 'answerIndex': answerIndex},
    );

    if (res.statusCode == 200) {
      return UnlockableFlashcard.fromJson(res.data);
    } else {
      throw Exception('Confirm unlock failed');
    }
  }
}
