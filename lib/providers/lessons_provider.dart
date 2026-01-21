import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_vm.dart';
import '../models/topics_model.dart';
import '../repositories/home_repository.dart';
import '../repositories/lessons_repository.dart';

final homeRepositoryProvider = Provider((ref) => HomeRepository());
final lessonsRepositoryProvider = Provider((ref) => LessonsRepository());

final topicsProvider = FutureProvider<List<TopicModel>>((ref) async {
  return ref.read(homeRepositoryProvider).getTopics();
});

final selectedTopicIdProvider = StateProvider<int?>((ref) => null);

final lessonsRefreshTickProvider = StateProvider<int>((ref) => 0);

final lessonsProvider = FutureProvider<List<CourseVm>>((ref) async {
  ref.watch(lessonsRefreshTickProvider);

  final repo = ref.read(lessonsRepositoryProvider);
  final page = await repo.getLessons(page: 0, size: 50);

  return page.items.map((e) => e.toCourseVm()).toList();
});
