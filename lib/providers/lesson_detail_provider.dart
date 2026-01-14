import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_detail_data.dart';
import '../models/dialog_response.dart';
import '../models/vocabulary_response.dart';
import '../repositories/lesson_detail_repository.dart';

final lessonDetailRepositoryProvider = Provider((ref) => LessonDetailRepository());

final lessonDetailDataProvider =
    FutureProvider.family<LessonDetailData, String>((ref, lessonId) async {
  final repo = ref.read(lessonDetailRepositoryProvider);

  final lesson = await repo.getLessonById(lessonId);

  List<DialogResponse> dialogs = const [];
  List<VocabularyResponse> vocabs = const [];

  try {
    dialogs = await repo.getDialogs(lessonId);
  } catch (_) {
    dialogs = const [];
  }

  try {
    vocabs = await repo.getVocabReview(lessonId);
  } catch (_) {
    vocabs = const [];
  }

  return LessonDetailData(
    lesson: lesson,
    dialogs: dialogs,
    vocabularies: vocabs,
  );
});
