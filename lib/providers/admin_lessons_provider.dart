import 'package:flutter_application_1/models/page_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/admin_lessons_repository.dart';
import '../models/admin_lesson_model.dart';
import '../providers/lessons_provider.dart'; 

final adminLessonsRepositoryProvider = Provider((ref) => AdminLessonsRepository());

final adminTopicIdProvider = StateProvider<int?>((ref) => null);
final adminSearchProvider = StateProvider<String>((ref) => '');
final adminRefreshTickProvider = StateProvider<int>((ref) => 0);

final _adminLessonsPageProvider = FutureProvider<PageResponse<AdminLessonModel>>((ref) async {
  final repo = ref.read(adminLessonsRepositoryProvider);
  final topicId = ref.watch(adminTopicIdProvider);
  ref.watch(adminRefreshTickProvider); 

  return repo.getLessons(topicId: topicId, page: 0, size: 50);
});

final adminLessonsProvider = Provider<AsyncValue<List<AdminLessonModel>>>((ref) {
  final pageAsync = ref.watch(_adminLessonsPageProvider);
  final q = ref.watch(adminSearchProvider).trim().toLowerCase();

  return pageAsync.whenData((page) {
    if (q.isEmpty) return page.items;

    return page.items.where((e) {
      final title = (e.title).toLowerCase();
      final topic = (e.topicName).toLowerCase();
      final desc = (e.description).toLowerCase();
      final level = (e.level).toLowerCase();

      return title.contains(q) || topic.contains(q) || desc.contains(q) || level.contains(q);
    }).toList();
  });
});
