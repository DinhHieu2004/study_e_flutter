import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/course_vm.dart';
import '../widgets/courses/course_list_item.dart';

final courseListProvider = Provider<List<CourseVm>>((ref) {
  return const [
    CourseVm(
      imagePath: "assets/imgs/business.png",
      topic: "Business",
      title: "Economics Conversation",
      description: "Common phrases business major",
      level: "A1",
      lessonCount: 6,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    CourseVm(
      imagePath: "assets/imgs/cafe.png",
      topic: "Travel & Coffee",
      title: "At the Cafe",
      description: "Order & small talk when hangout travel with friend",
      level: "A1",
      lessonCount: 5,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    CourseVm(
      imagePath: "assets/imgs/film.png",
      topic: "Film",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    CourseVm(
      imagePath: "assets/imgs/friend.png",
      topic: "Friend",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.activePrimary,
      actionIcon: Icons.chevron_right,
    ),
    CourseVm(
      imagePath: "assets/imgs/friend.png",
      topic: "Working",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    CourseVm(
      imagePath: "assets/imgs/film.png",
      topic: "Working",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.activeSecondary,
      actionIcon: Icons.chevron_right,
    ),
  ];
});
