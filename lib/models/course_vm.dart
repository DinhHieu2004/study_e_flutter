import 'package:flutter/material.dart';
import '../widgets/courses/course_list_item.dart';

class CourseVm {
  final int id;
  final String imagePath;
  final String topic;
  final String title;
  final String description;
  final String level;
  final int lessonCount;

  final CourseCardStatus status;
  final IconData actionIcon;

  const CourseVm({
    required this.id,
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
