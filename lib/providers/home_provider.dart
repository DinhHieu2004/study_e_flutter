import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/home_repository.dart';
import '../models/course_vm.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(),
);

final homeCoursesProvider = FutureProvider<List<CourseVm>>((ref) async {
  final repo = ref.read(homeRepositoryProvider);
  final topics = await repo.getTopics();

  return topics.map((e) => e.toCourseVm()).toList();
});
