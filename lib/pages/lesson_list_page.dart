import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lesson_provider.dart';
import '../widgets/lessons/course_header.dart';
import '../widgets/lessons/progress_line.dart';
import '../widgets/lessons/lesson_row.dart';
import '../widgets/lessons/lesson_status.dart';
import 'exercise_page.dart';

class LessonListPage extends ConsumerWidget {
  final String courseTitle;
  final String courseLevel;
  final String courseImageAsset;
  final int totalLessons;
  final int doneLessons;
  final int estMinutes;

  const LessonListPage({
    super.key,
    required this.courseTitle,
    required this.courseLevel,
    required this.courseImageAsset,
    required this.totalLessons,
    required this.doneLessons,
    this.estMinutes = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonListProvider);
    final autoDone = lessons.where((l) => l.status == LessonStatus.done).length;
    final done = doneLessons == 0 ? autoDone : doneLessons;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            LessonCourseHeader(
              title: courseTitle,
              level: courseLevel,
              imageAsset: courseImageAsset,
              totalLessons: totalLessons,
              doneLessons: done,
              estMinutes: estMinutes,
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LessonProgressLine(
                doneLessons: done,
                totalLessons: totalLessons,
              ),
            ),
            const SizedBox(height: 14),

            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final l = lessons[i];
                final locked = l.status == LessonStatus.locked;

                return LessonRow(
                  thumbAsset: l.thumbAsset,
                  title: l.title,
                  subtitle: "${l.minutes} min",
                  status: l.status,
                  onTap: locked
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ExercisePage()),
                          );
                        },
                  onMore: () => debugPrint("More: ${l.id}"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
