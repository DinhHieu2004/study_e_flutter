import 'course_vm.dart';
import '../widgets/courses/course_list_item.dart'; 

class LessonResponseModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final String? imageUrl;
  final int topicId;
  final String topicName;

  LessonResponseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.topicId,
    required this.topicName,
    this.imageUrl,
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
    );
  }

  CourseVm toCourseVm() {
    return CourseVm(
      id: id,
      imagePath: imageUrl ?? '',       
      topic: topicName,
      title: title,
      description: description,
      level: level,
      lessonCount: 0,                  
      status: CourseCardStatus.normal,  
    );
  }
}
