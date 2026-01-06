import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/stats_response.dart';

class StatRepository {
  final Dio _dio = DioClient.dio;

  Future<StatsResponse> getStatistics() async {
    final Response response = await _dio.get('/studyE/statistics');
    if (response.statusCode == 200) {
      return StatsResponse.fromJson(response.data);
    } else {
      throw Exception("Load stats failed");
    }
  }
}
