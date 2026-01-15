import 'lesson_detail_response.dart';
import 'dialog_response.dart';
import 'vocabulary_response.dart';

class LessonDetailData {
  final LessonDetailResponse lesson;
  final List<DialogResponse> dialogs;
  final List<VocabularyResponse> vocabularies;

  LessonDetailData({
    required this.lesson,
    required this.dialogs,
    required this.vocabularies,
  });
}
