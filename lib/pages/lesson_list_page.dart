import 'package:flutter/material.dart';
import '../widgets/lessons/course_header.dart';
import '../widgets/lessons/progress_line.dart';
import '../widgets/lessons/lesson_row.dart';
import '../widgets/lessons/lesson_status.dart';

class LessonListPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final lessons = <_LessonData>[
      const _LessonData(
        id: "l1",
        title: "Greetings",
        minutes: 6,
        thumbAsset: "assets/imgs/business.png",
        status: LessonStatus.done,
      ),
      const _LessonData(
        id: "l2",
        title: "Say hello",
        minutes: 6,
        thumbAsset: "assets/imgs/cafe.png",
        status: LessonStatus.done,
      ),
      const _LessonData(
        id: "l3",
        title: "Introduce",
        minutes: 6,
        thumbAsset: "assets/imgs/film.png",
        status: LessonStatus.done,
      ),
      const _LessonData(
        id: "l4",
        title: "Communicate",
        minutes: 6,
        thumbAsset: "assets/imgs/friend.png",
        status: LessonStatus.done,
      ),
      const _LessonData(
        id: "l5",
        title: "Opening model",
        minutes: 8,
        thumbAsset: "assets/imgs/hangout.png",
        status: LessonStatus.available,
      ),
      const _LessonData(
        id: "l6",
        title: "Numbers",
        minutes: 7,
        thumbAsset: "assets/imgs/office.png",
        status: LessonStatus.locked,
      ),
    ];

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
              doneLessons: doneLessons,
              estMinutes: estMinutes,
              onBack: () => Navigator.pop(context),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LessonProgressLine(
                doneLessons: doneLessons,
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

                return LessonRow(
                  thumbAsset: l.thumbAsset,
                  title: l.title,
                  subtitle: "${l.minutes} min",
                  status: l.status,
                  onTap: l.status == LessonStatus.locked
                      ? null
                      : () {
                          debugPrint("Open lesson: ${l.id}");
                        },
                  onMore: () {
                    debugPrint("More: ${l.id}");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonData {
  final String id;
  final String title;
  final int minutes;
  final String thumbAsset;
  final LessonStatus status;

  const _LessonData({
    required this.id,
    required this.title,
    required this.minutes,
    required this.thumbAsset,
    required this.status,
  });
}
