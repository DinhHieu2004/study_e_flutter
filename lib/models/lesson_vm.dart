import '../widgets/lessons/lesson_status.dart';

class LessonVm {
  final String id;
  final String title;
  final String thumbAsset;
  final int minutes;
  final LessonStatus status;

  const LessonVm({
    required this.id,
    required this.title,
    required this.thumbAsset,
    required this.minutes,
    required this.status,
  });
}
