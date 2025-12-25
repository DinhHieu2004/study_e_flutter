import 'package:dio/dio.dart';
import '../models/quiz_question.dart';
import '../network/dio_client.dart';
import '../models/quiz_result_request.dart';

class QuizRepository {
  final Dio _dio = DioClient.dio;

  Future<List<QuizQuestion>> fetchQuestions({
    required int amount,
    required String difficulty,
    required String type,
    required int categoryId,
  }) async {
    final Response response = await _dio.post(
      '/studyE/question',
      data: {"amount": amount, "difficulty": difficulty, "type": type, "category": categoryId},
    );

    final List data = response.data;
    return data.map((e) => QuizQuestion.fromJson(e)).toList();
  }

  Future<void> saveQuizResult(QuizResultRequest request) async {
  await _dio.post(
    "/studyE/quiz-results",
    data: request.toJson(),
  );
}

}
