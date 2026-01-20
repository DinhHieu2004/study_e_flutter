import 'course_vm.dart';
import '../widgets/courses/course_list_item.dart';
import 'package:flutter/material.dart';

class LessonResponseModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final String? imageUrl;
  final int topicId;
  final String topicName;
  final String? progressStatus;

  LessonResponseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.topicId,
    required this.topicName,
    this.imageUrl,
    this.progressStatus,
  });

  factory LessonResponseModel.fromJson(Map<String, dynamic> json) {
    return LessonResponseModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      topicId: (json['topicId'] as num?)?.toInt() ?? 0,
      topicName: json['topicName'] as String? ?? '',
      progressStatus: json['progressStatus'] as String?,
    );
  }

  CourseVm toCourseVm() {
    final isDone = progressStatus == 'DONE';

    return CourseVm(
      id: id,
      imagePath: imageUrl ?? '',
      topic: topicName,
      title: title,
      description: description,
      level: level,
      lessonCount: 0,
      status: isDone ? CourseCardStatus.done : CourseCardStatus.normal,
      actionIcon: isDone ? Icons.check_rounded : Icons.chevron_right,
    );
  }
}
