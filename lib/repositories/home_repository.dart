import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/topics_model.dart';

class HomeRepository {
  final Dio _dio = DioClient.dio;

  Future<List<TopicModel>> getTopics() async {
    try {
      final response = await _dio.get('/studyE/api/home');

      return (response.data as List)
          .map((e) => TopicModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error fetching topics',
      );
    }
  }
}
