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

final lessonsBySelectedTopicProvider = FutureProvider<List<CourseVm>>((ref) async {
  final topicId = ref.watch(selectedTopicIdProvider);
  if (topicId == null) return const [];

  final repo = ref.read(lessonsRepositoryProvider);
  final page = await repo.getLessonsByTopic(topicId: topicId, page: 0, size: 50);

  return page.items.map((e) => e.toCourseVm()).toList();
});
