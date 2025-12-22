import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_vm.dart';
import '../widgets/lessons/lesson_status.dart';

final lessonListProvider = Provider<List<LessonVm>>((ref) {
  return const [
    LessonVm(
      id: "l1",
      title: "Greetings",
      minutes: 6,
      thumbAsset: "assets/imgs/business.png",
      status: LessonStatus.done,
    ),
    LessonVm(
      id: "l2",
      title: "Say hello",
      minutes: 6,
      thumbAsset: "assets/imgs/cafe.png",
      status: LessonStatus.done,
    ),
    LessonVm(
      id: "l3",
      title: "Introduce",
      minutes: 6,
      thumbAsset: "assets/imgs/film.png",
      status: LessonStatus.done,
    ),
    LessonVm(
      id: "l4",
      title: "Communicate",
      minutes: 6,
      thumbAsset: "assets/imgs/friend.png",
      status: LessonStatus.done,
    ),
    LessonVm(
      id: "l5",
      title: "Opening model",
      minutes: 8,
      thumbAsset: "assets/imgs/hangout.png",
      status: LessonStatus.available,
    ),
    LessonVm(
      id: "l6",
      title: "Numbers",
      minutes: 7,
      thumbAsset: "assets/imgs/office.png",
      status: LessonStatus.locked,
    ),
  ];
});
