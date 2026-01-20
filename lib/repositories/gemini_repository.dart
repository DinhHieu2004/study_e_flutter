import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/detected_word.dart';
import 'dart:io';
import 'dart:convert';

class GeminiRepository {
  final Dio _dio = DioClient.dio;

  Future<String> getGeminiAnswer(String question, String answer) async {
    try {
      final Response response = await _dio.post(
        '/studyE/gemini',
        data: {"question": question, "answer": answer},
      );

      return response.data["answer"];
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Gemini API error");
    }
  }

  Future<DetectedWord?> identifyImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post(
        '/studyE/gemini/identify',
        data: formData,
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.data['data']);

        if (decodedData is List && decodedData.isNotEmpty) {
          return DetectedWord.fromJson(decodedData[0]);
        } else if (decodedData is Map<String, dynamic>) {
          return DetectedWord.fromJson(decodedData);
        }
      }
      return null;
    } catch (e) {
      throw Exception("Lỗi kết nối Server: $e");
    }
  }
}
