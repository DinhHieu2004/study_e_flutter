import 'package:dio/dio.dart';
import '../models/category.dart';

class CategoryRepository {
  Future<List<Category>> fetchCategories() async {
    final dio = Dio(); 

    final response = await dio.get(
      'https://opentdb.com/api_category.php',
    );

    final List list = response.data['trivia_categories'];
    return list.map((e) => Category.fromJson(e)).toList();
  }
}
