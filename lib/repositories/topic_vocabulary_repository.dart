import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/topic_vocabulary.dart';

class TopicVocabularyRepository {
  final Dio _dio = DioClient.dio;

  Future<List<TopicVocabulary>> getWatched() async {
    final response = await _dio.get('/studyE/api/topicV');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => TopicVocabulary.fromJson(e))
          .toList();
    } else {
      throw Exception('Load watched topics failed');
    }
  }

  Future<List<TopicVocabulary>> getAllTopics() async {
    final response = await _dio.get('/studyE/api/topicV');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => TopicVocabulary.fromJson(e))
          .toList();
    } else {
      throw Exception('Load watched topics failed');
    }
  }
}
