import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/quiz_question.dart';
import '../network/dio_client.dart';
import '../models/quiz_result_request.dart';
import '../models/Question_pageable.dart';

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
      data: {
        "amount": amount,
        "difficulty": difficulty,
        "type": type,
        "category": categoryId,
      },
    );

    final List data = response.data;
    return data.map((e) => QuizQuestion.fromJson(e)).toList();
  }

  Future<void> saveQuizResult(QuizResultRequest request) async {
    await _dio.post("/studyE/quiz-results", data: request.toJson());
  }
  Future<QuestionResponse> fetchPaginatedQuestions({
    required int page,
    required int size,
  }) async {
    final Response response = await _dio.get(
      '/studyE/question',
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return QuestionResponse.fromJson(response.data);
  }
  Future<void> importQuestion(PlatformFile file) async {
    try {
      
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path!, 
          filename: file.name,
        ),
      });

      final response = await _dio.post(
        '/studyE/question/import',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
        onSendProgress: (sent, total) {
          print('Upload progress: ${(sent / total * 100).toStringAsFixed(0)}%');
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Import failed with status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Lỗi khi import file: $errorMessage");
    } catch (e) {
      throw Exception("Đã xảy ra lỗi không xác định: $e");
    }
  }

Future<void> deleteQuestion(String id) async {
  try {
    final response = await _dio.delete('/studyE/question/$id');
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Xóa thất bại");
    }
  } on DioException catch (e) {
    final errorMessage = e.response?.data['message'] ?? e.message;
    throw Exception("Lỗi khi xóa: $errorMessage");
  }
}

}
