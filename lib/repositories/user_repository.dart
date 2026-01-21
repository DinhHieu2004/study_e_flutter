import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/user_response.dart';


class UserRepository {
  final Dio _dio = DioClient.dio;

  Future<List<User>> fetchAllUsers() async {
    try {
      final Response response = await _dio.get('/studyE/user');

      final List data = response.data;
      return data.map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Lỗi khi lấy danh sách người dùng: $errorMessage");
    }
  }

  Future<void> updateActiveStatus(String uid) async {
    try {
      await _dio.put(
        '/studyE/user',
        queryParameters: {"uid": uid},
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Lỗi khi cập nhật trạng thái: $errorMessage");
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _dio.delete('/studyE/user/$uid');
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Lỗi khi xóa người dùng: $errorMessage");
    }
  }

  Future<User> fetchUserDetail(String uid) async {
    try {
      final response = await _dio.get('/studyE/user/$uid');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Lỗi khi lấy thông tin chi tiết: $errorMessage");
    }
  }
}