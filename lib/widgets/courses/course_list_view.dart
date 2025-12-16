import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/courses/course_list_item.dart';
import 'course_empty_state.dart';

class CourseVm {
  final String imagePath;
  final String topic;
  final String title;
  final String description;
  final String level;
  final int lessonCount;

  final CourseCardStatus status;
  final IconData actionIcon;

  const CourseVm({
    required this.imagePath,
    required this.topic,
    required this.title,
    required this.description,
    required this.level,
    required this.lessonCount,
    this.status = CourseCardStatus.normal,
    this.actionIcon = Icons.chevron_right,
  });
}

class CourseListView extends StatelessWidget {
  final List<CourseVm> courses;
  final ValueChanged<CourseVm> onCourseTap;

  const CourseListView({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const CourseEmptyState();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final c = courses[i];
        return CourseListItem(
          imagePath: c.imagePath,
          topic: c.topic,
          title: c.title,
          description: c.description,
          level: c.level,
          status: c.status,
          actionIcon: c.actionIcon,
          onTap: () => onCourseTap(c),
        );
      },
    );
  }
}
