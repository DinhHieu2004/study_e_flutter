import 'course_vm.dart';

class TopicModel {
  final int id;
  final String name;
  final String imagePath;
  final String level;
  final int lessonCount;

  TopicModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.level,
    required this.lessonCount,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      level: json['level'] as String? ?? 'Beginner',
      lessonCount: (json['lessonCount'] as num?)?.toInt() ?? 0,
    );
  }

  /// Mapper: Topic (domain) sang CourseVm (ui)
  CourseVm toCourseVm() {
    return CourseVm(
      id: id,
      imagePath: imagePath,
      topic: name,
      title: name,
      description: 'Learn $name',
      level: level,
      lessonCount: lessonCount,
    );
  }
}
