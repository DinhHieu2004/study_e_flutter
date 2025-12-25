import 'package:dio/dio.dart';
import '../network/dio_client.dart';

class GeminiRepository {
  final Dio _dio = DioClient.dio;

  Future<String> getGeminiAnswer(String question, String answer) async {
  try {
    final Response response = await _dio.post(
      '/studyE/gemini',
      data: {
        "question": question,
        "answer": answer,
      },
    );

    return response.data["answer"];
  } on DioException catch (e) {
    throw Exception(e.response?.data["message"] ?? "Gemini API error");
  }
}

}

