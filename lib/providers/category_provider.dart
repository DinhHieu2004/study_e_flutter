
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';


final categoryRepositoryProvider =
    Provider((ref) => CategoryRepository());

final categoryProvider = FutureProvider<List<Category>>((ref) {
  return ref.read(categoryRepositoryProvider).fetchCategories();
});
